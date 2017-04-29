Route = Object:extend()
Route.mSize = 32

function Route:new()
	self.color     = nil
	self.stations  = {}
	self.mouseOver = {}
	self.mouseDown = {}
end

function Route:update(dt)

	for key, value in pairs(self.stations) do

		-- check if mouse is over a hitbox area
		local sx, sy = self.stations[key].x-self.mSize/2,self.stations[key].y-self.mSize/2
		local sx2, sy2 = sx+self.mSize+self.mSize/2, sy+self.mSize+self.mSize/2
		-- if the mouse is in the hitbox
		if sx<mx and mx<sx2 and sy<my and my<sy2 then
			self.mouseDown[key] = false
			self.mouseOver[key] = true
			-- if the mouse 1 button is also down
			if love.mouse.isDown(1) then
				self.mouseDown[key] = true
				-- remove station from route here
				table.remove(self.stations,key)
			end
		else
			self.mouseOver[key] = false
			self.mouseDown[key] = false
		end
	end
end

function Route:draw()
	-- for each mouse hit box check it it's active, draw box if active
	for key, value in pairs(self.stations) do
		if self.mouseOver[key] then
			love.graphics.setColor(100, 100, 255, 200)
			-- change color if active and mouse1 down
			if self.mouseDown[key] then
				love.graphics.setColor(255, 255, 150, 200)
			end
			love.graphics.rectangle("fill", self.stations[key].x-self.mSize/2, self.stations[key].y-self.mSize/2, self.mSize,self.mSize)
		end
	end
	love.graphics.setColor(255, 0, 255)
	if #self.stations > 1 then
		for i=1, #self.stations-1 do
			local startX, startY 	= self.stations[i].x, self.stations[i].y
			local endX, endY 		= self.stations[i+1].x, self.stations[i+1].y
			love.graphics.line(startX,startY,endX,endY)
		end
	end
	love.graphics.setColor(255, 255, 255)
end

