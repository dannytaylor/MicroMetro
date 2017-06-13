-- Node.lua

Node = Object:extend()

function Node:new(x,y,type) -- will create a new station
	self.x = x or 0
	self.y = y or 0
	self.type = type or randomType()
	self.color = 22
	self.mouseover = false
	print('new node, x:'.. self.x .. ', y:' .. self.y)
end

function Node:draw()
	local sx = (self.x - 0.5)*TILE_SIZE
	local sy = (self.y - 0.5)*TILE_SIZE

	if self.mouseover then
		love.graphics.setColor(200,0,200,255)
	else
		love.graphics.setColor(255,255,255,255)
	end
	draft:square(sx,sy,TILE_SIZE+2)

	love.graphics.setColor(48,48,48)
	draft:square(sx,sy,TILE_SIZE)
end

function Node:update()

end