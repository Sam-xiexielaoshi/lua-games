local love = require "love"

local Button = require "Asteroid.components.Button"

function Menu(game, player)
    local buttons = {
        Button(nil, nil, nil, love.graphics.getWidth() / 3, 50, "New Game", "center", "h3", love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.25)
    }

    return {
        draw = function(self)
            for _, button in pairs(buttons) do
                button:draw()
            end
        end
    }
end

return Menu
