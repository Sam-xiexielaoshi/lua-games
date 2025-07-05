_G.love = require('love')

function love.load()
    _G.hero = {
        x=0,
        y=0,
        sprite = love.graphics.newImage('sprites/spritesheet.png'),
        animation = {
            direction = 'right',
            idle= true,
            frame =1,
            max_frames = 8,
            speed = 20,
            timer = 0.1
        }
    }

    SPRITE_WIDTH , SPRITE_HEIGHT = 5352, 569
    QUAD_WIDTH = 669
    QUAD_HEIGHT = SPRITE_HEIGHT
    love.graphics.newQuad(0,0,QUAD_WIDTH,QUAD_HEIGHT,SPRITE_WIDTH,SPRITE_HEIGHT)
    
    _G.quads={ }
        for i=1, hero.animation.max_frames do
            quads[i] = love.graphics.newQuad(QUAD_WIDTH*(i-1),0,QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
        end
end

function love.update(dt)

    if love.keyboard.isDown('d') then
        hero.animation.idle=false
        hero.animation.direction='right'
    elseif love.keyboard.isDown('a') then
        hero.animation.idle = false
        hero.animation.direction = 'left'
    else 
        hero.animation.idle = true
        hero.animation.frame = 1
    end

    if not hero.animation.idle then
        hero.animation.timer = hero.animation.timer+dt

        if hero.animation.timer>0.15 then
            hero.animation.timer=0.1
            
            hero.animation.frame = hero.animation.frame+1

            if hero.animation.direction == 'right' then
                hero.x = hero.x + hero.animation.speed
            elseif  hero.animation.direction == 'left' then
                hero.x = hero.x - hero.animation.speed
            end

            if hero.animation.frame> hero.animation.max_frames then
                hero.animation.frame = 1
            end
        end
    end
end

function love.draw()
    love.graphics.scale(0.3)

    if hero.animation.direction == 'right' then
        love.graphics.draw(hero.sprite,quads[hero.animation.frame],hero.x,hero.y)
    else
        love.graphics.draw(hero.sprite,quads[hero.animation.frame],hero.x,hero.y,0,-1,1,QUAD_WIDTH,0)
    end

end