Train = Object:extend()

Train.width = 1
Train.height = 1
Train.passengerSize = 8

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

	self.width = (self.passengerSize + 2)*4
	self.height = (self.passengerSize + 2)*3
end

function Train:update(dt)
	--test movement, basic along a route
	if self.currentStation then
		self.x = self.route.stations[self.currentStation].x
		self.y = self.route.stations[self.currentStation].y
		-- move train out of station and current -> previous station
		self.previousStation = self.currentStation
		self.nextStation = self.currentStation + self.routeDir
		self.currentStation = nil
	-- if not at a current station then train is in transit
	else
		-- move along line to next station
		-- move unit vector towards next station
		local targetX = self.route.stations[self.nextStation].x
		local targetY = self.route.stations[self.nextStation].y 
		local xDis = targetX - self.route.stations[self.previousStation].x
		local yDis = targetY - self.route.stations[self.previousStation].y
		local absDis = math.sqrt(math.pow(xDis,2)+ math.pow(yDis,2))

		local newX, newY = self.x + xDis*self.speed/absDis,self.y + yDis*self.speed/absDis
		-- if moved past next station, next -> current
		-- if moving x positive and past next station
		if (xDis > 0 and newX>targetX) or (xDis< 0 and newX<targetX ) then
			-- move train to next station
			self.currentStation = self.nextStation

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

function Train:draw()
	-- draw train as box, 6 empty slots inside for passengers
	love.graphics.setLineWidth(2)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)

	-- place a passenger in the train box for each passenger
	if self.passengers then
	for i=1, #self.passengers do
		local trainX = (self.x + self.passengerSize + 2) + ( (i - 1 ) % 3 )*(self.passengerSize+2)
		local trainY = (self.y + self.passengerSize + 2) + math.floor((i-1)/3)*(self.passengerSize+2)
		drawShape(trainX,trainY,self.passengerSize,self.passengers[i].type)
	end
	end
end
