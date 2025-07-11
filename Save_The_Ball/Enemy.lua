local love = require 'love'

function Enemy(_level)
    local dice, _x, _y = math.random(1,4)
    local _radius = 10

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
    if dice == 1 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = -_radius * 4
    elseif dice == 2 then
        _x = -_radius * 4
        _y = math.random(_radius, love.graphics.getHeight())
    elseif dice == 3 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = love.graphics.getHeight()+(_radius *4)
    else 
        _x = love.graphics.getWidth()+(_radius *4)
        _y = math.random(_radius, love.graphics.getHeight())
    end


    return {
        level = _level or 1 ,
        radius = _radius,
        x = _x,
        y=_y,

        checkTouched = function (self, player_x, player_y, cursor_radius)
            return math.sqrt((self.x-player_x)^2 + (self.y-player_y)^2  )<=cursor_radius*2
        end,

        move = function(self, player_x, player_y)
            if player_x - self.x >0 then
                self.x = self.x + self.level
            elseif  player_x - self.x <0 then
                self.x = self.x - self.level
            end

            if player_y - self.y>0 then
                self.y = self.y + self.level
            elseif player_y - self.y <0 then
                self.y = self.y - self.level
            end
        end,
        
        draw = function(self)
            love.graphics.setColor(1,0.5,0.7)
            love.graphics.circle('fill', self.x, self.y, self.radius)
            love.graphics.setColor(1,1,1)
        end
    }
end

return Enemy