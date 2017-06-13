-- Overlay.lua

Overlay = Object:extend()

function Overlay:new()

end

function Overlay:draw()
	love.graphics.setColor(255, 255, 255)
	draft:rectangle(WINDOW_W/2,WINDOW_H-2*TILE_SIZE,WINDOW_W,4*TILE_SIZE)
end