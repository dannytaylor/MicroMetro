-- Route.lua

-- a route will be a collection of points
-- each point will correspond to a station
-- a route can have 0+ trains
-- a route can be a loop
-- a route will have a unique colour
-- a route has at least 1 point
Route = Object:extend()

function Route:new(node1,node2,type) -- type would be colour in Mini Metro
	self.loop = false -- must have at least 3 nodes to loop
	self.rNodes = {node1,node2}
	self.type = type
end

function Route:addEdge(line)
	-- if route has no rNodes
	if not #self.rNodes then self.rNodes[1]={line[1],line[2]}
	else self.rNodes[#self.rNodes] = {line[1],line[2]} end
	self.rNodes[#self.rNodes+1] = {line[3],line[4]}


	-- assume you click somewhere on the route to change it
	local prevNode
	local nextNode

	-- you're grabbing on an  
	-- if prev = nil then you're grabbing the first in the route
		-- unless next is also nil then you're creating the route from 0
		-- new addtion can't be added if it's already in route
			-- unless addition is the last in route then loop = true
	-- if next = nil then you're grabing the last in the route
		-- new addtion can't be added if it's already in route
			-- unless addition is the first in route then loop = true
	-- if you grab the route on a station pop station off route
	-- if you grab a route on an edge then prev and next are defined
end

function Route:removeNode(x,y)
	for i,node in ipairs(self.rNodes) do
		if x == node.x and y == node.y then
			table.remove(self.rNodes,node)
		break end
	end
end

-- maybe call on any route change/ ie Route:check
-- function Route:update()
-- 	if #rNodes < 1 or not #rNodes then
-- 		Route:delete()
-- 	end
-- end

function Route:draw()
	-- change draw color
	-- for each edge
	for i=2, #self.rNodes do
		local x1    = (self.rNodes[i-1][1] - 0.5)*tileSize
		local y1    = (self.rNodes[i-1][2] - 0.5)*tileSize
		local x2	= (self.rNodes[i][1]	 - 0.5)*tileSize
		local y2    = (self.rNodes[i][2]	 - 0.5)*tileSize	
		drawToPoint(x1,y1,x2,y2)
	end
		-- 	draw edge; can have 1 or 2 segments at 45 angle
	-- for start and end node
		-- 	draw tail
end

function Route:delete()
	-- passengers get off trains at next stop
	-- remove trains when empty
	-- delete route
end

return Route