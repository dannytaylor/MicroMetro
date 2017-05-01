--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 4/28/2017
-- Time: 7:22 PM
-- To change this template use File | Settings | File Templates.
--

-- Station Types static enumeration class


StationType = Object:extend()

-- All of the boring regular types of stations
StationType.CommonStations = {
	Square = 0,
	Triangle = 1,
	Circle = 2,
	-- ...
}
local test = {
	as = 1
}
-- The ratios at which regular stations will appear, higher == more common
StationType.CommonStationWeight = {
	Square = 1,
	Triangle = 2,
	Circle = 4,
	-- ...
}
StationType._WeightedStations = {
	StationType.CommonStations.Square,
	StationType.CommonStations.Triangle, StationType.CommonStations.Triangle,
	StationType.CommonStations.Circle, StationType.CommonStations.Circle, StationType.CommonStations.Circle, StationType.CommonStations.Circle,
}


-- The possible Unique stations. They are effectively identical and should only ever appear once in a game
StationType.UniqueStations = {
	Star = 0,
	Diamond = 1,
}

-- Pick a random station type out of the possible types
function StationType:GetRandomStation()
	-- We need to pick a random station based on the weight
	local targetStationIndex = love.math.random(#StationType._WeightedStations)
	
	--Get the station type and return it
	local targetStationType = StationType._WeightedStations[targetStationIndex]
	return targetStationType
end

-- Pick a random station type that isn't the specified one
function StationType:GetRandomOtherStationType(invalidStationType)
	-- Just get them till it doesn't match, I'm lazy
	-- TODO: Make this not suck
	local targetStationType = nil
	repeat
		targetStationType = StationType.GetRandomStation()
	until targetStationType ~= invalidStationType
	
	return targetStationType
end


