--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 4/30/2017
-- Time: 2:05 AM
-- To change this template use File | Settings | File Templates.
--

-- A Map represents a particular level a user can select

Map = Object:extend()

function Map:new(mapName, mapDescription, mapImagePath)
	
	-- Store the information of this map
	self.mapName = mapName
	self.mapDescription = mapDescription
	self.mapImagePath = mapImagePath
	
	-- Parse out map information based on the input image
	local mapInformation = Map:ParseMapImage(self.mapImagePath)
	self.mapImage = mapInformation.ImageData
	self.mapWidth = mapInformation.Width
	self.mapHeight = mapInformation.Height

	-- Return the completed object
	return Map
end

function Map:ParseMapImage(mapImagePath)
	-- We need to load the image path
	local mapImage = love.image.newImageData(mapImagePath)
	
	--Get the height and width
	local mapHeight = mapImage:getHeight()
	local mapWidth = mapImage:getWidth()
	
	--Collect this information
	local mapInformation = {
		ImageData = mapImage,
		Height = mapHeight,
		Width = mapWidth
	}
	
	--Return what we got
	return mapInformation
end

function Map:isWaterTile(tileX, tileY)
	--We need to check if we are on a water tile
	--This is simply if the tile is not BLACK!
	local red, green, blue, alpha = self.mapImage:getPixel(tileX, tileY)
	
	--They better be black!
	if red == 0 and green == 0 and blue == 0 then return false end
	return true
end