--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 4/30/2017
-- Time: 2:05 AM
-- To change this template use File | Settings | File Templates.
--

-- A Map represents a particular level a user can select

Map = Object:extend()

function Map:new(mapName, mapWidth, mapHeight, impassableTiles, backgroundImagePath)
	-- Store this information
	self.mapName = mapName -- The name of the map
	self.mapWidth = mapWidth -- The width of the grid
	self.mapHeight = mapHeight -- The height of the grid
	self.impassableTiles = impassableTiles -- A set of all tiles that are impassable (water, etc)
	self.backgroundImagePath = backgroundImagePath -- The image to display for the background
	
	-- Return the completed object
	return Map
end