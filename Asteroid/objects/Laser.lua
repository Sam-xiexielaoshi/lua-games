local love = require 'love'

function Lazer(x, y, angle)
    local LAZER_SPEED = 500
    local exploadingTable = {
        not_exploding = 0,
        exploding = 1,
        done_exploding = 2,
    }
    local EXPLOD_DURATION = 0.2
    return {
        x = x,
        y = y,
        x_velocity = LAZER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_velocity = -LAZER_SPEED * math.sin(angle) / love.timer.getFPS(),
        distance = 0,
        exploding = 0,
        exploding_time = 0,

        draw = function(self, faded)
            local opacity = 1
            if faded then
                opacity = 0.5
            end
            if self.exploding < 1 then
                love.graphics.setColor(1, 1, 1, opacity)
                love.graphics.setPointSize(3)
                love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor(1, 104 / 255, 0, opacity)
                love.graphics.circle(
                    'fill',
                    self.x,
                    self.y,
                    7 * 1.6
                )
                love.graphics.setColor(1, 234 / 255, 0, opacity)
                love.graphics.circle(
                    'fill',
                    self.x,
                    self.y,
                    7 * 1
                )
            end
        end,

        move = function(self)
            self.x = self.x + self.x_velocity
            self.y = self.y + self.y_velocity

            if self.exploding_time > 0 then
                self.exploding = 1
            end

            if self.x < 0 then
                self.x = love.graphics.getWidth()
            elseif self.x > love.graphics.getWidth() then
                self.x = 0
            end
            if self.y < 0 then
                self.y = love.graphics.getWidth()
            elseif self.y > love.graphics.getWidth() then
                self.y = 0
            end
            self.distance = self.distance + math.sqrt(self.x_velocity ^ 2 + self.y_velocity ^ 2)
        end,

        expload = function(self)
            self.exploding_time = math.ceil(EXPLOD_DURATION * (love.timer.getFPS() / 100))
            if self.exploding_time > EXPLOD_DURATION then
                self.exploding = 2
            end
        end
    }
end

return Lazer
