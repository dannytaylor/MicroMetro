-- Route.lua
Route = Object:extend()

function Route:new(id,node)
	self.nodes = {node}
	self.points = {} -- nodes + midpoints + tails
	self.id = id
	self.color = {
		r = love.math.random(55,255),
		g = love.math.random(55,255),
		b = love.math.random(55,255)
	}
end

function Route:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b)
	love.graphics.setLineWidth(ROUTE_WIDTH)
	if #self.points>1 then
		for i=2, #self.points do
			local x1,y1,x2,y2 = self.points[i-1].x,self.points[i-1].y,self.points[i].x,self.points[i].y
			draft:line({(x1-0.5)*TILE_SIZE,(y1-0.5)*TILE_SIZE,(x2-0.5)*TILE_SIZE,(y2-0.5)*TILE_SIZE})
		end
	end
	-- draw tails
	draft:line({(self.points[1].x-0.5)*TILE_SIZE-TILE_SIZE/2,(self.points[1].y+0.5)*TILE_SIZE-TILE_SIZE/2,(self.points[1].x+0.5)*TILE_SIZE-TILE_SIZE/2,(self.points[1].y-0.5)*TILE_SIZE-TILE_SIZE/2})
	draft:line({(self.points[#self.points].x-0.5)*TILE_SIZE-TILE_SIZE/2,(self.points[#self.points].y+0.5)*TILE_SIZE-TILE_SIZE/2,(self.points[#self.points].x+0.5)*TILE_SIZE-TILE_SIZE/2,(self.points[#self.points].y-0.5)*TILE_SIZE-TILE_SIZE/2})
end

function Route:addNode(node)
	self.nodes[#self.nodes+1] = node

	--initializing routes
	if #self.nodes == 2 then 
		self:initPoints()

	else
		self.points[#self.points+1] = {x=self.nodes[#self.nodes].x,y=self.nodes[#self.nodes].y}
		local midX,midY = getMidPoint(self.points[#self.points-2].x,self.points[#self.points-2].y,self.points[#self.points].x,self.points[#self.points].y)
		self.points[#self.points-1] = {x=midX,y=midY}
		
		local dX,dY
		dX,dY = self.points[3].x - self.points[2].x,self.points[3].y - self.points[2].y
		dX = lume.sign(dX)
		dY = lume.sign(dY)

		self.points[1] = {x=(self.points[2].x-dX),y=(self.points[2].y-dY)}


		dX, dY = self.points[#self.points].x - self.points[#self.points-1].x, self.points[#self.points].y - self.points[#self.points-1].y
		dX = -lume.sign(dX)
		dY = -lume.sign(dY)
		self.points[#self.points+1] = {x=(self.points[#self.points].x-dX),y=(self.points[#self.points].y-dY)}
	end

end

function Route:initPoints()
	--add tail point
	self.points[1] = {x=1,y=1}
	self.points[2] = {x=self.nodes[1].x,y=self.nodes[1].y}
	--midpoint placeholder
	self.points[3] = {x=self.nodes[1].x,y=self.nodes[1].y}
	self.points[4] = {x=self.nodes[2].x,y=self.nodes[2].y}

	local midX,midY = getMidPoint(self.points[2].x,self.points[2].y,self.points[4].x,self.points[4].y)
	self.points[3] = {x=midX,y=midY}

	local dX, dY

	dX,dY = self.points[3].x - self.points[2].x,self.points[3].y - self.points[2].y
	dX = lume.sign(dX)
	dY = lume.sign(dY)

	self.points[1] = {x=(self.points[2].x-dX),y=(self.points[2].y-dY)}

	-- dX,dY = self.points[#self.points].x - self.points[#self.points-1].x, self.points[#self.points].y - self.points[#self.points-1].y
	-- dX = -lume.sign(dX)
	-- dY = -lume.sign(dY)
	-- self.points[5] = {x=(self.points[4].x-dX),y=(self.points[4].y-dY)}
end

function getMidPoint(x1,y1,x2,y2)
	local dX = x2 - x1
	local dY = y2 - y1
	
	-- diagonals case
	if math.abs(dX) == math.abs(dY) or dX == 0 or dY == 0 then 
		return x1+dX,y1+dY
	elseif math.abs(dX) > math.abs(dY) then
		if dX>0 then
			if dY>0 then
				return x2 - dY, y2 - dY
			else
				return x2 + dY, y2 - dY
			end
		elseif dX<0 then
			if dY>0 then
				return x2 + dY, y2 - dY
			else
				return x2 - dY, y2 - dY
			end
		end
	elseif math.abs(dX) < math.abs(dY) then
		if dY>0 then
			if dX>0 then
				return x2 - dX, y2 - dX
			else
				return x2 - dX, y2 + dX
			end
		elseif dY<0 then
			if dX>0 then
				return x2 - dX, y2 + dX
			else
				return x2 - dX, y2 - dX
			end
		end
	end
end