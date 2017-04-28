Station = Object:extend()

-- if a station is full for this time you lose
Station.loseTimerMax = 10
Station.size = 8
Station.passengerSize = 3

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
    drawShape(self.x - 20 + i*5, self.y + self.size + 2, self.passengerSize,self.passengers[i].type)
  end
end

return Station
