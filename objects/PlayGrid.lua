--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 5/1/2017
-- Time: 1:11 AM
-- To change this template use File | Settings | File Templates.
--

-- This represents the currently active grid. It is initialized based on the currently loaded map.

PlayGrid = Object:extend()
PlayGrid.GridSize = 30 --30px square

function PlayGrid:new(sourceMap)
	--Create a set of empty tiles
	self.tiles = {}
	for column = 1, sourceMap.mapWidth do
		self.tiles[column] = {}
		for row = 1, sourceMap.mapHeight do
			self.tiles[column][row] = {}
		end
	end
	
	-- Fill in the tiles with water
	for impassableX, impassableY in pairs(sourceMap.impassableTiles) do
		self.tiles[impassableX][impassableY].insert(WaterTile(impassableX, impassableY))
	end
	
	-- Return the completed object
	return PlayGrid
end