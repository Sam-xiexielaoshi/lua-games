local love = require "love"

function Text(text, x, y, font_size, fade_in, fade_out, text_wrap, align, opacity)
    font_size = font_size or "p"
    fade_in = fade_in or false
    fade_out = fade_out or false
    text_wrap = text_wrap or love.graphics.getWidth()
    align = align or "left"
    opacity = opacity or 1
    
    -- Smoother fade durations (in seconds)
    local FADE_IN_DURATION = 1.5   -- 1.5 seconds for fade in
    local FADE_OUT_DURATION = 1.0  -- 1 second for fade out
    
    local fonts={
        h1 = love.graphics.newFont(48),
        h2 = love.graphics.newFont(36),
        h3 = love.graphics.newFont(24),
        h4 = love.graphics.newFont(18),
        h5 = love.graphics.newFont(14),
        h6 = love.graphics.newFont(12),
        p = love.graphics.newFont(10)
    }
    
    if fade_in then
        opacity = 0  -- Start completely transparent for smooth fade
    end
    
    return {
        text = text,
        x = x,
        y = y,
        opacity = opacity,
        font_size = font_size,
        text_wrap = text_wrap,
        align = align,
        fade_in = fade_in,
        fade_out = fade_out,
        fade_complete = false,

        colors = {
            r=1,
            g=1,
            b=1
        },
        
        setColor = function (self, red, green, blue)
            self.colors.r = red or 1
            self.colors.g = green or 1
            self.colors.b = blue or 1
        end,
        
        update = function(self, dt)
            -- Smooth fade in animation
            if self.fade_in and not self.fade_complete then
                if self.opacity < 1 then
                    self.opacity = self.opacity + (dt / FADE_IN_DURATION)
                    if self.opacity >= 1 then
                        self.opacity = 1
                        self.fade_complete = true
                        self.fade_in = false  -- Stop fade in
                    end
                end
            end
            
            -- Smooth fade out animation
            if self.fade_out then
                if self.opacity > 0 then
                    self.opacity = self.opacity - (dt / FADE_OUT_DURATION)
                    if self.opacity <= 0 then
                        self.opacity = 0
                    end
                end
            end
        end,
        
        draw = function (self, tbl_text, index)
            if self.opacity > 0 then
                -- Store current font to restore later
                local current_font = love.graphics.getFont()
                
                love.graphics.setColor(self.colors.r, self.colors.g, self.colors.b, self.opacity)
                love.graphics.setFont(fonts[self.font_size])
                love.graphics.printf(self.text, self.x, self.y, self.text_wrap, self.align)
                
                -- Reset graphics state
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setFont(current_font)
            else
                -- Remove from table if completely faded out
                if tbl_text and index then
                    table.remove(tbl_text, index)
                end
                return false
            end
            return true
        end,
        
        -- Trigger fade out
        startFadeOut = function(self)
            self.fade_out = true
            self.fade_in = false
        end,
        
        -- Reset for reuse
        reset = function(self)
            self.fade_in = fade_in
            self.fade_out = false
            self.fade_complete = false
            self.opacity = fade_in and 0 or 1
        end
    }
end

return Text