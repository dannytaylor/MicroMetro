local Passenger = Object:extend()

function Passenger:new(type)
  -- ie shape, colour, or letter; same as destination station
  self.type = type
  --
  self.location = nil
  self.width = 8
  self.height = 8
end

function Passenger:update(dt)

end

function Passenger:draw()

end

return Passenger
