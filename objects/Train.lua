Train = Object:extend()

Train.width = 14
Train.height = 8

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
end

function Train:loadPassenger(passenger)
  -- get list of current station
end

function Train:update(dt)
  --test movement
  self.x = self.x + self.speed
  if self.x > 240 then
    self.speed = -1
  elseif self.x < 20 then
      self.speed = 1
  end
end

function Train:draw()
  -- draw train as 8x4 box, 6 empty pixels inside for
  love.graphics.setLineWidth(1)
  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)

  -- place a passenger in the train box for each passenger
  love.graphics.setPointSize(2)
  if self.passengers then
    for i=1, #self.passengers do
      local trainX = (self.x + 2) + ( (i - 1 ) % 3 )*4
      local trainY = (self.y + 2) + math.floor((i-1)/3)*3
      love.graphics.points(trainX, trainY)
    end
  end
end
