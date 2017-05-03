--Node.lua

-- temporary class, basically a station
-- to help me work through the structuring problem

Node = Object:extend()

function Node:new(x,y,t,r)
	self.x = x -- grid coords
	self.y = y
	self.type = t -- station type
	self.routes = r -- list of route ids servicing node
	self.neighbors = {} -- will be empty on new station
end

function Node:addRoute(r)
	-- if node has no routes
	if not #self.routes then
		self.routes[1]=r
		
	-- check if route already on node
	elseif not self:hasRoute(r) then
		self.routes[#self.routes+1] = r
	end
	-- if route already added do nothing
end

function Node:hasRoute(r)
	for i,testRoute in ipairs(self.routes) do
		if testRoute == r then return true end
	end
	return false
end
