-- Route.lua
Route = Object:extend()

function Route:new(id,node)
	self.nodes = {node}
	self.id = id
end

function Route:draw()
	if #self.nodes>1 then
		for i=2, #self.nodes do
			drawToPoint((self.nodes[i-1].x-0.5)*tileSize,(self.nodes[i-1].y-0.5)*tileSize,(self.nodes[i].x-0.5)*tileSize,(self.nodes[i].y-0.5)*tileSize)
		end
	end
end

function Route:addNode(node)
	self.nodes[#self.nodes+1] = node
end