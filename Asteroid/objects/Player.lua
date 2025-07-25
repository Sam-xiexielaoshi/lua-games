require "globals"
local love = require "love"
local LAZER = require "objects.Laser"
-- in this the rad is used instead of degree because the degreen function would have been way off and would have been a more tuffer to deal with it
function Player(num_lives)
    local SHIP_SIZE = 30
    local EXPLOAD_DURATION = 5
    local VIEW_ANGLE = math.rad(90) -- 90 degrees to radians almost equivalent to 1.57
    local LAZER_DISTANCE = 0.6
    local MAX_LAZERS = 10
    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_ANGLE,
        rotation = 0,
        expload_time = 0,
        exploading = false,
        lazers = {},
        thrusting = false,
        thrust = {
            x = 0, y = 0, speed = 5, big_flame = false, flame = 2.0
        },
        lives = num_lives or 3,

        draw_flame = function(self, fill_type, color)
            love.graphics.setColor(color)
            love.graphics.polygon(
                fill_type,
                self.x - self.radius * ((2 / 3) * math.cos(self.angle) + 0.5 * math.sin(self.angle)),
                self.y + self.radius * ((2 / 3) * math.sin(self.angle) - 0.5 * math.cos(self.angle)),
                self.x - self.radius * self.thrust.flame * math.cos(self.angle),
                self.y + self.radius * self.thrust.flame * math.sin(self.angle),
                self.x - self.radius * ((2 / 3) * math.cos(self.angle) - 0.5 * math.sin(self.angle)),
                self.y + self.radius * ((2 / 3) * math.sin(self.angle) + 0.5 * math.cos(self.angle))
            )
        end,

        shootLazer = function(self)
            if #self.lazers < MAX_LAZERS then
                table.insert(self.lazers, LAZER(
                    self.x,
                    self.y,
                    self.angle
                ))
            end
        end,

        destroyLazer = function(self, index)
            table.remove(self.lazers, index)
        end,

        draw = function(self, faded)
            local opacity = 1
            if faded then
                opacity = 0.5
            end

            if not self.exploading then
                if self.thrusting then
                    if not self.thrust.big_flame then
                        self.thrust.flame = self.thrust.flame - 1 / love.timer.getFPS()
                        if self.thrust.flame < 1.5 then
                            self.thrust.big_flame = true
                            -- self.thrust.flame = 1.5
                        end
                    else
                        self.thrust.flame = self.thrust.flame + 1 / love.timer.getFPS()
                        if self.thrust.flame > 2.5 then
                            self.thrust.big_flame = false
                            -- self.thrust.flame = 1.5
                        end
                    end
                    self:draw_flame('fill', { 255 / 255, 102 / 255, 25 / 255 })
                    self:draw_flame("line", { 1, 0, 16, 0 })
                end
                if SHOW_DEBUGGING then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.rectangle('fill', self.x - 1, self.y - 1, 2, 2)
                    love.graphics.circle('line', self.x, self.y, self.radius) --collision radius added around the ship to drastically reduce the number of calcs.
                end
                love.graphics.setColor(0, 255, 0, 255, opacity)
                --this function right here will set the size and shape of the ship which currently is a triangle
                love.graphics.polygon(
                    "line",
                    --these two below line will make the tip of the ship or the point which will be facing the direction of the ship
                    self.x + ((4 / 3) * self.radius) * math.cos(self.angle),
                    self.y - ((4 / 3) * self.radius) * math.sin(self.angle),
                    -- these two below lines will make the back of the ship,
                    self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)), --first back point
                    self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)), --first back point
                    --here the second back point is made
                    self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
                    self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
                )
                for _, lazer in pairs(self.lazers) do
                    lazer:draw(faded)
                end
            else
                love.graphics.setColor(1, 0, 0, opacity)
                love.graphics.circle(
                    'fill',
                    self.x,
                    self.y,
                    self.radius * 1.6
                )
                love.graphics.setColor(1, 158 / 255, 0, opacity)
                love.graphics.circle(
                    'fill',
                    self.x,
                    self.y,
                    self.radius * 1
                )
                love.graphics.setColor(1, 234 / 255, 0, opacity)
                love.graphics.circle(
                    'fill',
                    self.x,
                    self.y,
                    self.radius * 0.5
                )
            end
        end,

        -- drawLives = function(self, faded)
        --     local opacity = faded and 0.5 or 1
        --     local heart_scale = 1 -- Smaller hearts
        --     local heart_spacing = 35
        --     local start_x = 20
        --     local start_y = 20

        --     -- Helper function to get heart points
        --     local function getHeartPoints(scale, offsetX, offsetY)
        --         local points = {}
        --         local numSegments = 30 -- Even fewer segments for performance
        --         for i = 0, numSegments do
        --             local t = i * (2 * math.pi / numSegments)
        --             local x = scale * (16 * math.sin(t) ^ 3) + offsetX
        --             local y = -scale * (13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t)) +
        --             offsetY
        --             table.insert(points, x)
        --             table.insert(points, y)
        --         end
        --         return points
        --     end

        --     -- Draw hearts for each life
        --     for life = 1, self.lives do
        --         local heart_x = start_x + (life - 1) * heart_spacing
        --         local heart_y = start_y

        --         local heart_points = getHeartPoints(heart_scale, heart_x, heart_y)

        --         -- Draw heart with gradient effect
        --         love.graphics.setColor(0.8, 0, 0, opacity) -- Dark red base
        --         love.graphics.polygon('fill', heart_points)

        --         love.graphics.setColor(1, 0.2, 0.2, opacity) -- Bright red highlight
        --         love.graphics.polygon('line', heart_points)
        --     end

        --     -- Optional: Draw empty hearts for lost lives
        --     for life = self.lives + 1, 3 do -- Assuming max 3 lives
        --         local heart_x = start_x + (life - 1) * heart_spacing
        --         local heart_y = start_y

        --         local heart_points = getHeartPoints(heart_scale, heart_x, heart_y)

        --         -- Draw empty heart outline
        --         love.graphics.setColor(0.3, 0.3, 0.3, opacity * 0.5) -- Gray, semi-transparent
        --         love.graphics.polygon('line', heart_points)
        --     end

        --     love.graphics.setColor(1, 1, 1, 1)
        -- end,

        drawLives = function(self, faded)
            local opacity = 1
            if faded then
                opacity = 0.5
            end

            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1, 0.2, 0.2, opacity)
            else
                love.graphics.setColor(1, 1, 1, opacity)
            end
            local x_pos, y_pos = 45, 30
            for i = 1, self.lives do
                if self.exploading then
                    if i == self.lives then
                        love.graphics.setColor(1, 0, 0, opacity)
                    end
                end
                love.graphics.polygon(
                    "line",
                    --these two below line will make the tip of the ship or the point which will be facing the direction of the ship
                    (i * x_pos) + ((4 / 3) * self.radius) * math.cos(VIEW_ANGLE),
                    y_pos - ((4 / 3) * self.radius) * math.sin(VIEW_ANGLE),
                    -- these two below lines will make the back of the ship,
                    (i * x_pos) - self.radius * (2 / 3 * math.cos(VIEW_ANGLE) + math.sin(VIEW_ANGLE)), --first back point
                    y_pos + self.radius * (2 / 3 * math.sin(VIEW_ANGLE) - math.cos(VIEW_ANGLE)),       --first back point
                    --here the second back point is made
                    (i * x_pos) - self.radius * (2 / 3 * math.cos(VIEW_ANGLE) - math.sin(VIEW_ANGLE)),
                    y_pos + self.radius * (2 / 3 * math.sin(VIEW_ANGLE) + math.cos(VIEW_ANGLE))
                )
            end
        end,

        move = function(self)
            self.exploading = self.expload_time > 0
            if not self.exploading then
                local FPS = love.timer.getFPS()
                local friction = 0.5                      -- friction to slow down the ship
                self.rotation = 360 / 180 * math.pi / FPS --how much plaver will turn evey second
                if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
                    self.angle = self.angle + self.rotation
                end
                if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
                    self.angle = self.angle - self.rotation
                end
                if self.thrusting then
                    self.thrust.x = self.thrust.x +
                        self.thrust.speed * math.cos(self.angle) /
                        FPS --math.cos(self.angle) gives the horizontal component of the direction vector || self.thrust.speed/FPS converts speed from "per second" to "per frame" || Accumulates horizontal thrust over time
                    self.thrust.y = self.thrust.y -
                        self.thrust.speed * math.sin(self.angle) /
                        FPS -- vertical component of the direction vector || self.thrust.speed/FPS converts speed from "per second" to "per frame" || Accumulates vertical thrust over time
                else
                    if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                        -- Apply friction
                        self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                        self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                    end
                end
                -- Apply thrust to position
                self.x = self.x + self.thrust.x
                self.y = self.y + self.thrust.y

                if self.x + self.radius < 0 then
                    self.x = love.graphics.getWidth() + self.radius
                elseif self.x - self.radius > love.graphics.getWidth() then
                    self.x = -self.radius
                end
                if self.y + self.radius < 0 then
                    self.y = love.graphics.getHeight() + self.radius
                elseif self.y - self.radius > love.graphics.getHeight() then
                    self.y = -self.radius
                end
            end
            for idx, lazer in pairs(self.lazers) do
                if lazer.exploding == 0 then
                    lazer:move() -- Only move if not exploding

                    if lazer.distance > LAZER_DISTANCE * love.graphics.getWidth() then
                        lazer:expload()
                    end
                elseif lazer.exploding == 2 then
                    self.destroyLazer(self, idx)
                end
            end
        end,

        expload = function(self)
            self.expload_time = math.ceil(EXPLOAD_DURATION * love.timer.getFPS())
        end
    }
end

return Player
-- IGNORE: This is a Player module for a game, defining the player's ship properties and drawing method.

-- math
--thrust_x = speed * cos(45°) = speed * 0.707  →
--thrust_y = speed * sin(45°) = speed * 0.707  ↓
