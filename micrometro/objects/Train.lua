Train = Object:extend()

Train.width = 1
Train.height = 1
Train.passengerSize = 8
Train.MaxPassengers = 6

-- constants same for all trains
Train.speed = 4
Train.loadSpeed = 1

function Train:new(x,y)
	self.currentStation = nil
	self.nextStation = nil
	self.previousStation = nil
	self.route = nil
	-- forwards or backwards in route
	self.routeDir = 1
	-- if route is a closed loop
	self.routeLoop = false

	self.x, self.y = x, y

	-- start with capacity of 6 before upgrades
	self.capacity = 6
	self.passengers = {}
	self.unloading = true
	self.loading = false

	self.width = (self.passengerSize + 2)*4
	self.height = (self.passengerSize + 2)*3
end

function Train:update(dt)
	--test movement, basic along a route
	if self.route then
		-- if at a station
		-- unload passengers first
		if self.unloading and not self.loading then
			-- for every train passenger that has same type as station
			self:unload()
			self.loading = true
		elseif self.loading and self.unloading then
			-- for every passenger at current station
			self:load()
			self.unloading = false
		elseif self.loading and not self.unloading then
			-- move train out of station and current -> previous station
			self.previousStation = self.currentStation
			self.nextStation     = self.currentStation + self.routeDir
			self.currentStation  = nil
			self.loading = false
		-- if not at a current station then train is in transit
		else
			-- move along line to next station
			-- move unit vector towards next station
			local targetX = self.route.stations[self.nextStation].x
			local targetY = self.route.stations[self.nextStation].y
			local xDis    = targetX - self.route.stations[self.previousStation].x
			local yDis    = targetY - self.route.stations[self.previousStation].y
			local absDis  = math.sqrt(math.pow(xDis,2)+ math.pow(yDis,2))

			local newX, newY = self.x + xDis*self.speed/absDis,self.y + yDis*self.speed/absDis
			-- if moved past next station, next -> current
			-- if moving x positive and past next station
			if (xDis > 0 and newX>targetX) or (xDis< 0 and newX<targetX ) then
				-- move train to next station
				self.currentStation = self.nextStation
				self.x = self.route.stations[self.currentStation].x
				self.y = self.route.stations[self.currentStation].y

				-- assume there will be loading and unloading for now
				self.unloading = true

				-- if currentStation is last in the route change route direction
				if self.currentStation == #self.route.stations then
					self.routeDir = -1
				elseif self.currentStation == 1 then
					self.routeDir = 1
				end
			else
				self.x, self.y = newX, newY
			end
		end
	end
end

function Train:draw()
	-- draw train as box, 6 empty slots inside for passengers
	love.graphics.setLineWidth(2)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)

	-- place a passenger in the train box for each passenger
	if self.passengers then
		for i=1, #self.passengers do
			if self.passengers[i] then
				local trainX = (self.x + self.passengerSize + 2) + ( (i - 1 ) % 3 )*(self.passengerSize+2)
				local trainY = (self.y + self.passengerSize + 2) + math.floor((i-1)/3)*(self.passengerSize+2)
				drawShape(trainX,trainY,self.passengerSize,self.passengers[i].type)
			end
		end
	end
end

function Train:unload()
	local currentType = self.route.stations[self.currentStation].type
	-- start from the end of the passenger list
	for i=#self.passengers, 1, -1 do
		-- if a passenger is the same type as the current station 
		if self.passengers[i] then
			if currentType == self.passengers[i].type then
				--unload/delete him and add a score point
				self.passengers[i]=nil
				GameScore = GameScore + 1
			end
		end
	end
end

function Train:load()
	-- get a list of upcoming station types
	local upcomingTypes = {}
	-- if station list increasing
	if self.routeDir == 1 then
		local upcomingNum = #self.route.stations - self.currentStation
		for i=self.currentStation, #self.route.stations, 1 do
			table.insert(upcomingTypes,self.route.stations[i].type)
		end
	-- if station list decreasing
	elseif self.routeDir == -1 then
		for i=self.currentStation, 1, -1 do
			table.insert(upcomingTypes,self.route.stations[i].type)
		end
	end
	-- for each passenger at the station
	for i=#self.route.stations[self.currentStation].passengers, 1, -1 do
		
		-- Do we have room?
		if #self.passengers >= Train.MaxPassengers then break end
		
		if self.route.stations[self.currentStation].passengers[i] then
			local pType = self.route.stations[self.currentStation].passengers[i].type
			-- check if this train goes to that station
			for key,value in pairs(upcomingTypes) do
				-- if the passenger finds a match
				if pType == value then
					-- remove that passenger from the station and add to the train
					local removedPassenger = self.route.stations[self.currentStation]:removePassenger(value)
					self.passengers[#self.passengers + 1] = removedPassenger
				break end
			end
		end
	end
end
