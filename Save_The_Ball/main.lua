local love = require 'love'
local Enemy = require 'Enemy'
local Button = require 'Button'

math.randomseed(os.time())

local game = {

    difficulty = 1,

    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false,
    }
}

local player = {
    radius = 20,
    x=30,
    y=30
}

local buttons = {
    menu_state={}
}

local enemies = {}

function love.load()
    love.mouse.setVisible(false)
    buttons.menu_state.play_game = Button("Play Game", nil ,nil, 120, 40)
    buttons.menu_state.settings = Button("Settings", nil ,nil, 120, 40)
    buttons.menu_state.exit_game = Button("Exit", love.event.quit ,nil, 120, 40)
    table.insert(enemies,1,Enemy())
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()
    for i=1, #enemies do
        enemies[i]:move(player.x, player.y)
    end
end

function love.draw()
    love.graphics.printf("FPS: "..love.timer.getFPS(), love.graphics.newFont(16),10,love.graphics.getHeight()-30,love.graphics.getWidth())

    if game.state['running'] then
        for i=1, #enemies do
        enemies[i]:draw()
    end
        love.graphics.circle('fill', player.x,player.y, player.radius/2)
    elseif game.state['menu'] then
        buttons.menu_state.play_game:draw(10,20,17,10)
        buttons.menu_state.settings:draw(10,70,17,10)
        buttons.menu_state.exit_game:draw(10,120,17,10)
    end
    if not game.state['running'] then
        love.graphics.setColor(0.7, 0, 0.7)
        love.graphics.arc('fill', player.x,player.y,player.radius,0, math.pi / 2,500)
    end
end