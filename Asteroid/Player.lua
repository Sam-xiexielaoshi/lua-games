local love =require"love"

function Player(debugging)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90) -- 90 degrees to radians almost equivalent to 1.57
    debugging = debugging or false
    return {
        x = 0,
        y = 0,
        angle = 0,
        speed = 0,
        max_speed = 300,
        acceleration = 500,
        rotation_speed = math.rad(180), -- 180 degrees per second
        size = SHIP_SIZE,
        view_angle = VIEW_ANGLE,
        debugging = debugging,

        draw = function(self)
            if self.debugging then
                love.graphics.setColor(1, 0, 0, 1) -- Red for debugging
            else
                love.graphics.setColor(1, 1, 1, 1) -- White for normal
            end
            love.graphics.polygon("fill", self.x, self.y, 
                self.x + self.size * math.cos(self.angle - self.view_angle / 2),
                self.y + self.size * math.sin(self.angle - self.view_angle / 2),
                self.x + self.size * math.cos(self.angle + self.view_angle / 2),
                self.y + self.size * math.sin(self.angle + self.view_angle / 2))
        end,
    }
end