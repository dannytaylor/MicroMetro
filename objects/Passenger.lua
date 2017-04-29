local StationType = require "objects/StationType"

Passenger = Object:extend()

function Passenger:new(type)
	-- ie shape, colour, or letter; same as destination station
	self.type = StationType.GetRandomStationType(StationType.PossibleStationTypes)
	-- either
	self.location = nil
	return Passenger
end

