function Game()
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
    }
end

return Game