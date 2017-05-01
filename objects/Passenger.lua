Passenger = Object:extend()

function Passenger:new(spawnStation)
	-- Which location does this passenger spawn at?
	self.location = spawnStation
	-- What type is the passenger? It cannot be same as destination station
	-- ie shape, colour, or letter;
	self.type = StationType:GetRandomOtherStationType(spawnStation.type)
	-- either
	return Passenger
end

