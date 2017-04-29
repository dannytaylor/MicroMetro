--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 4/28/2017
-- Time: 7:22 PM
-- To change this template use File | Settings | File Templates.
--

-- Station Types

StationType = {
	Square = 1,
	Triangle = 2,
	Circle = 3,
	-- ...
}

PossibleStationTypes = { StationType.Square, StationType.Triangle, StationType.Circle }

-- Pick a random station type out of the possible types
function GetRandomStationType(possibleStationTypes)
	targetStationType = possibleStationTypes[math.random(#possibleStationTypes)]
	return targetStationType
end

-- Return this module as a table so we don't throw globals all over the place
return {
	StationType = StationType,
	PossibleStationTypes = PossibleStationTypes,
	GetRandomStationType = GetRandomStationType,
}



	

