local love = require "love"

function love.conf(app)
    app.window.width = 1920
    app.window.height = 1080
    app.window.title = "Asteroid Destroyer"
    app.window.icon = "logo.png"
    
end