Station = Object:extend()

-- if a station is full for this time you lose
Station.loseTimerMax = 10
Station.size = 16
Station.passengerSize = 8

function Station:new(x,y, type)
	-- only 1 train can load/unload passengers at a time
	self.currentTrain = nil
	-- queue of trains waiting to load/unload
	self.waitingTrains = {}

	self.passengers = {}
	-- station's location on the map
	self.x = x
	self.y = y

	-- station's shape/type
	self.type = type

	-- all stations start with capacity of 10 passengers before upgrades
	self.capacity = 10

	self.loseTimer = 0

end

function Station:addPassenger(passType)
	table.insert(self.passengers,Passenger:new(type))
end

function Station:removePassenger(passType)
	for i=#self.passengers, 1, -1 do
		local currentPassenger = self.passengers[i]
		if currentPassenger then
			if currentPassenger.type == passType then
				self.passengers[i] = nil
				return currentPassenger
			end
		end
	end
end

function Station:update(dt)
	-- need to fix this update for however LOVE deals with time
	-- if a station is over capacity then count up the lose timer
	if #self.passengers > self.capacity then
		self.loseTimer = self.loseTimer + 1
		-- if a lose timer maxes out you lose
		if self.loseTimer > self.loseTimerMax then
			-- you lose
		end
	-- else if you're below capacity and the timer isn't 0 then count down to 0
	elseif self.loseTimer > 0 then
		self.loseTimer = self.loseTimer - 1
	end
end

function Station:draw()
	-- draw the station depending on it's type
	drawShape(self.x,self.y, self.size,self.type)
	-- show passengers below station
	for i=1, #self.passengers do
		if self.passengers[i] then
			drawShape(self.x + (i - #self.passengers/2)*12 - self.passengerSize/2 - 1, self.y + self.size + 8, self.passengerSize,self.passengers[i].type)
		end
	end
end
