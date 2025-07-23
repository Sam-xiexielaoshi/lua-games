local TEXT = require "Asteroid.components.Text"

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
        states={
            menu = false,
            paused = false,
            running= true,
            ended = false
        },
        changeState = function (self,state)
            self.states.menu = state == "menu"
            self.states.paused = state == "paused"
            self.states.running = state == "running"
            self.states.ended = state == "ended"
        end,

        draw=function(self,faded)
            if faded then
                paused_title:draw()
                paused_subtitle:draw()
            end
        end
    }
end

return Game