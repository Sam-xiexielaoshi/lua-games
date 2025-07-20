local love = require "love"

function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0,0
    local show_debugging = true
end

function love.update()
    _G.mouse_x, _G.mouse_y = love.mouse.getPosition()
end

function love.draw()
    
end