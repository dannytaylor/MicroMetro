-- Overlay.lua

Overlay = Object:extend()

function Overlay:new()
	self.w = window_width
	self.h = 3*TILE_SIZE
	self.cx = self.w/2
	self.cy = window_height-self.h/2

end

function Overlay:draw()
	love.graphics.setColor(255, 255, 255)
	draft:rectangle(self.cx,self.cy,self.w,self.h)

	local rx,ry = 2*TILE_SIZE,self.cy
	for i=1,#allRoutes do
		local color = allRoutes[i].color
		love.graphics.setColor(color.r,color.g,color.b)
		draft:rectangle(rx,ry,TILE_SIZE,TILE_SIZE)
		rx = rx + 2*TILE_SIZE
	end

	love.graphics.setColor(211,211,211)

end