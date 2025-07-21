local love =require"love"
-- in this the rad is used instead of degree because the degreen function would have been way off and would have been a more tuffer to deal with it
function Player(debugging)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90) -- 90 degrees to radians almost equivalent to 1.57
    debugging = debugging or false
    return {
        x = love.graphics.getWidth()/2,
        y =love.graphics.getHeight()/2,
        radius = SHIP_SIZE/2,
        angle = VIEW_ANGLE,
        rotation = 0,
        thrusting = false,
        thrust = {
            x=0,y=0,speed=5,big_flame = false, flame=2.0
        },
        draw_flame = function (self,fill_type,color)

        end,
        draw = function (self)
            local opacity = 1
            if debugging then
                love.graphics.setColor(1,0,0)
                love.graphics.rectangle('fill', self.x-1,self.y-1,2,2)
                love.graphics.circle('line', self.x,self.y, self.radius) --collision radius added around the ship to drastically reduce the number of calcs.
            end
            love.graphics.setColor(1,1,1,opacity)
            --this function right here will set the size and shape of the ship which currently is a triangle 
            love.graphics.polygon(
            "line",
            --these two below line will make the tip of the ship or the point which will be facing the direction of the ship
            self.x+((4/3)*self.radius)*math.cos(self.angle),
            self.y-((4/3)*self.radius)*math.sin(self.angle),
            -- these two below lines will make the back of the ship,
            self.x-self.radius*(2/3*math.cos(self.angle)+math.sin(self.angle)),--first back point
            self.y+self.radius*(2/3*math.sin(self.angle)-math.cos(self.angle)),--first back point
            --here the second back point is made 
            self.x-self.radius*(2/3*math.cos(self.angle)-math.sin(self.angle)),
            self.y+self.radius*(2/3*math.sin(self.angle)+math.cos(self.angle))
        )
        end,move = function (self)
            local FPS = love.timer.getFPS()
            local friction = 0.5 -- friction to slow down the ship
            self.rotation = 360/180*math.pi/FPS --how much plaver will turn evey second
            if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
                self.angle = self.angle + self.rotation
            end
            if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
                self.angle = self.angle - self.rotation
            end
            if self.thrusting then
                self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle)/FPS --math.cos(self.angle) gives the horizontal component of the direction vector || self.thrust.speed/FPS converts speed from "per second" to "per frame" || Accumulates horizontal thrust over time
                self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle)/FPS -- vertical component of the direction vector || self.thrust.speed/FPS converts speed from "per second" to "per frame" || Accumulates vertical thrust over time

            else
                if self.thrust.x~=0 or self.thrust.y~=0 then
                    -- Apply friction
                self.thrust.x = self.thrust.x - friction*self.thrust.x/FPS
                self.thrust.y = self.thrust.y - friction*self.thrust.y/FPS
                end    
            
                
            end
            -- Apply thrust to position
            self.x = self.x + self.thrust.x
            self.y = self.y + self.thrust.y
        end
    }
end

return Player
-- IGNORE: This is a Player module for a game, defining the player's ship properties and drawing method.

-- math 
--thrust_x = speed * cos(45°) = speed * 0.707  →
--thrust_y = speed * sin(45°) = speed * 0.707  ↓