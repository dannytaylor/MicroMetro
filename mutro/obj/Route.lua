-- Route.lua
Route = Object:extend()

function Route:new(id,node)
	self.nodes = {node}
	self.id = id
	self.color = {
		['r'] = love.math.random(127,255),
		['g'] = love.math.random(127,255),
		['b'] = love.math.random(127,255)
	}
end

function Route:draw()
	if #self.nodes>1 then
		for i=2, #self.nodes do
			local x1,y1 = (self.nodes[i-1].x-0.5)*tileSize,(self.nodes[i-1].y-0.5)*tileSize
			local x2,y2 = (self.nodes[i].x-0.5)*tileSize,(self.nodes[i].y-0.5)*tileSize
			drawToPoint(x1,y1,x2,y2,self.color)
		end
	end
end

function Route:addNode(node)
	self.nodes[#self.nodes+1] = node
end