local TEXT = require "Asteroid.components.Text"
local ASTEROIDS = require "Asteroid.objects.Asteroids"

function Game()
    local paused_title = TEXT(
        "PAUSED",
        0,
        love.graphics.getHeight() * 0.4,
        "h1",
        false,
        false,
        love.graphics.getWidth(),
        "center",
        1
    )

    local paused_subtitle = TEXT(
        "enter esc to resume",
        0,
        love.graphics.getHeight() * 0.4 + 60,
        "h5",
        false,
        false,
        love.graphics.getWidth(),
        "center",
        1
    )

    return {
        level = 1,
        states = {
            menu = true,
            paused = false,
            running = false,
            ended = false
        },
        changeState = function(self, state)
            self.states.menu = state == "menu"
            self.states.paused = state == "paused"
            self.states.running = state == "running"
            self.states.ended = state == "ended"
        end,

        draw = function(self, faded)
            if faded then
                paused_title:draw()
                paused_subtitle:draw()
            end
        end,
        startNewGame = function(self, player)
            self:changeState("running")
            _G.asteroids = {}
            local asteroid_x = math.floor(math.random(love.graphics.getWidth()))
            local asteroid_y = math.floor(math.random(love.graphics.getHeight()))
            table.insert(asteroids, 1, ASTEROIDS(asteroid_x, asteroid_y, 100, self.level))
        end
    }
end

return Game
