Passenger = Object:extend()

function Passenger:new(type)
	-- ie shape, colour, or letter; same as destination station
	self.type = math.random(1,3)
	-- either 
	self.location = nil
	return Passenger
end

