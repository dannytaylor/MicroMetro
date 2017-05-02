-- Route.lua

-- a route will be a collection of points
-- each point will correspond to a station
-- a route can have 0+ trains
-- a route can be a loop
-- a route will have a unique colour
-- a route has at least 1 point
local Route = Object:extend()
local nodes = {}
local loop = false -- must have at least 3 nodes to loop
local draft = Draft('fill')

function Route:addEdge(line)
	-- if route is empty
	if not #nodes then nodes[1]={line[1],line[2]}
	else nodes[#nodes] = {line[1],line[2]} end
	nodes[#nodes+1] = {line[3],line[4]}


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

-- maybe call on any route change/ ie Route:check
-- function Route:update()
-- 	if #nodes < 1 or not #nodes then
-- 		Route:delete()
-- 	end
-- end

function Route:draw()
	-- change draw color
	-- for each edge
	for i=1, #nodes do
		local x1    = (nodes[i-1][1] - 0.5)*tileSize
		local y1    = (nodes[i-1][2] - 0.5)*tileSize	 -- grid pos to canvas pos
		local x2	= (nodes[i][1]	 - 0.5)*tileSize
		local y2    = (nodes[i][2]	 - 0.5)*tileSize	
		love.graphics.line(x1,y1,x2,y2)
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