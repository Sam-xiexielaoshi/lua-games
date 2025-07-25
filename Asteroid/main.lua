require "globals"
local love = require "love"
local Player = require "Asteroid.objects.Player"
local Game = require "states/Game"

math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0, 0
    _G.player = Player()
    _G.game = Game()
    game:startNewGame(player)
end

function love.keypressed(key)
    if game.states.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end
        if key == "space" or key == "kp5" then
            player:shootLazer()
        end

        if key == "escape" then
            game:changeState("paused")
        end
    elseif game.states.paused then
        if key == "escape" then
            game:changeState("running")
        end
    end
end

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.states.running then
            player:shootLazer()
        end
    end
end

function love.update(dt)
    _G.mouse_x, _G.mouse_y = love.mouse.getPosition()
    if game.states.running then
        player:move()
        for ast_idx, asteroids in pairs(_G.asteroids) do
            if not player.exploading then
                if calculateDistance(player.x, player.y, asteroids.x, asteroids.y) < asteroids.radius then
                    player:expload()
                    DESTROY_AST = true
                end
            else
                player.expload_time = player.expload_time - 1

                if player.expload_time == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeState("ended")
                        return
                    end
                    _G.player = Player(player.lives - 1)
                end
            end
            for _, lazer in pairs(player.lazers) do
                if calculateDistance(lazer.x, lazer.y, asteroids.x, asteroids.y) < asteroids.radius then
                    lazer:expload()
                    asteroids:destroy(_G.asteroids, ast_idx, game)
                end
            end
            if DESTROY_AST then
                if player.lives - 1 <= 0 then
                    if player.expload_time == 0 then
                        DESTROY_AST = false
                        asteroids:destroy(_G.asteroids, ast_idx, game)
                    end
                else
                    DESTROY_AST = false
                    asteroids:destroy(_G.asteroids, ast_idx, game)
                end
            end
            asteroids:move(dt)
        end
    end
end

function love.draw()
    if game.states.running or game.states.paused then
        player:draw(game.states.paused)
        player:drawLives(game.states.paused)
        for _, asteroids in pairs(_G.asteroids) do
            asteroids:draw(game.states.paused)
        end
        game:draw(game.states.paused)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, love.graphics.getHeight() - 20)
end
