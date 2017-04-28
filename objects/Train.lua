Train = Object:extend()

Train.width = 1
Train.height = 1
Train.passengerSize = 8

-- constants same for all trains
Train.speed = 1
Train.loadSpeed = 1

function Train:new(x,y)
	self.currentStation = nil
	self.nextStation = nil
	self.previousStation = nil
	self.line = nil

	self.x, self.y = x, y

	-- start with capacity of 6 before upgrades
	self.capacity = 6
	self.passengers = {}

	self.width = (self.passengerSize + 2)*4
	self.height = (self.passengerSize + 2)*3
end

function Train:addPassenger(type)
	table.insert(self.passengers,Passenger:new(type))
end

function Train:update(dt)
	--test movement
	self.x = self.x + self.speed
	if self.x > canvasWidth-200 then
	self.speed = -1
	elseif self.x < 0 then
		self.speed = 1
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
