local love = require 'love'

function Enemy(_level)
    local dice = math.random(1,4)
    local _radius = 10
    
    -- Add missing variable definitions
    local speed = _level or 1
    local colors = {
        {1,0,0},    -- red
        {0,1,0},    -- green
        {0,0,1},    -- blue
        {1,1,0},    -- yellow
        {1,0,1},    -- magenta
        {0,1,1},    -- cyan
    }
    local color = colors[math.random(1, #colors)]
    
    -- Add different shapes
    local shapes = {"circle", "square", "triangle", "diamond"}
    local shape = shapes[math.random(1, #shapes)]

    -- Spawn position logic
    local _x, _y
    if dice == 1 then
        _x = math.random(_radius, love.graphics.getWidth()-_radius)
        _y = math.random(_radius, love.graphics.getHeight()-_radius)
    elseif dice == 2 then
        _x = math.random(_radius, love.graphics.getWidth()-_radius)
        _y = math.random(love.graphics.getHeight()-_radius, love.graphics.getHeight()+_radius)
    elseif dice == 3 then
        _x = math.random(love.graphics.getWidth()-_radius, love.graphics.getWidth())
        _y = math.random(_radius, love.graphics.getHeight()-_radius)
    elseif dice == 4 then
        _x = math.random(love.graphics.getWidth()-_radius, love.graphics.getWidth())
        _y = math.random(love.graphics.getHeight()-_radius, love.graphics.getHeight()+_radius)
    else
        _x = 100
        _y = 100
    end

    return {
        level = speed,
        radius = _radius,
        x = _x,
        y = _y,
        color = color,
        shape = shape,

        checkTouched = function (self, player_x, player_y, cursor_radius)
            return math.sqrt((self.x-player_x)^2 + (self.y-player_y)^2) <= cursor_radius*2
        end,

        move = function(self, player_x, player_y)
            if player_x - self.x > 0 then
                self.x = self.x + self.level
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level
            end

            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y - self.y < 0 then
                self.y = self.y - self.level
            end
        end,
        
        draw = function(self)
            love.graphics.setColor(self.color)
            
            if self.shape == "circle" then
                love.graphics.circle('fill', self.x, self.y, self.radius)
                
            elseif self.shape == "square" then
                love.graphics.rectangle('fill', self.x - self.radius, self.y - self.radius, 
                                      self.radius * 2, self.radius * 2)
            elseif self.shape == "triangle" then
                love.graphics.polygon('fill',
                    self.x, self.y - self.radius,           -- top point
                    self.x - self.radius, self.y + self.radius, -- bottom left
                    self.x + self.radius, self.y + self.radius  -- bottom right
                )
                
            elseif self.shape == "diamond" then
                love.graphics.polygon('fill',
                    self.x, self.y - self.radius,           -- top
                    self.x + self.radius, self.y,           -- right
                    self.x, self.y + self.radius,           -- bottom
                    self.x - self.radius, self.y            -- left
                )
            end
            
            love.graphics.setColor(1,1,1) -- Reset color to white
        end
    }
end

return Enemy



-- Spawn position logic
    -- Use the commented version if you want things to spawn randomly within or near the screen area, like power-ups or particles.

    -- if dice == 1 then
    --     _x = math.random(_radius, love.graphics.getWidth()-_radius)
    --     _y = math.random(_radius, love.graphics.getHeight()-_radius)  -- Fixed: changed getWidth() to getHeight()
    
    -- elseif dice == 2 then
    --     _x = math.random(_radius, love.graphics.getWidth()-_radius)
    --     _y = math.random(love.graphics.getHeight()-_radius, love.graphics.getHeight()+_radius)
    -- elseif dice == 3 then
    --     _x = math.random(love.graphics.getWidth()-_radius, love.graphics.getWidth())
    --     _y = math.random(_radius, love.graphics.getHeight()-_radius)
    -- elseif dice == 4 then
    --     _x = math.random(love.graphics.getWidth()-_radius, love.graphics.getWidth())
    --     _y = math.random(_radius, love.graphics.getHeight()-_radius)
    -- else
    --     _x = 100
    --     _y = 100
    -- end

    -- Use the active version when you want objects (e.g., enemies, projectiles) to fly in from outside the screen