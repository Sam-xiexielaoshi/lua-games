local love = require 'love'

function Lazer(x,y,angle)
    local LAZER_SPEED = 500
    return {
        x=x,
        y=y,
        x_velocity = LAZER_SPEED * math.cos(angle)/ love.timer.getFPS(),
        y_velocity = -LAZER_SPEED * math.sin(angle)/ love.timer.getFPS(),
        distance = 0,

        draw=function (self,faded)
            local opacity = 1
            if faded then
                opacity = 0.5
            end
            love.graphics.setColor(1,1,1, opacity)
            love.graphics.setPointSize(3)
            love.graphics.points(self.x,self.y)
        end,

        move = function (self)
            self.x=self.x + self.x_velocity
            self.y=self.y + self.y_velocity

            if self.x<0 then
                self.x = love.graphics.getWidth()
            elseif self.x>love.graphics.getWidth() then
                self.x = 0
            end
            if self.y<0 then
                self.y = love.graphics.getWidth()
            elseif self.y>love.graphics.getWidth() then
                self.y = 0
            end
            self.distance = self.distance + math.sqrt(self.x_velocity^2 + self.y_velocity^2)
        end
    }
end

return Lazer