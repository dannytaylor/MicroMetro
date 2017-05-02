--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 5/1/2017
-- Time: 1:11 AM
-- To change this template use File | Settings | File Templates.
--

-- This represents the currently active grid. It is initialized based on the currently loaded map.

PlayGrid = Object:extend()
PlayGrid.GridSize = 16 --How many px square

function PlayGrid:new(sourceMap)
	--Create a set of empty tiles
	self.sourceMap = sourceMap
	self.tiles = {}
	for column = 0, self.sourceMap.mapWidth - 1 do
		self.tiles[column] = {}
		for row = 0, self.sourceMap.mapHeight - 1 do
			self.tiles[column][row] = {}
			
			-- Was this a water tile? Add one if so
			if self.sourceMap:isWaterTile(column, row) then
				local newWaterTile = WaterTile(column, row)
				table.insert(self.tiles[column][row], newWaterTile)
			end
		end
	end
	
	-- Return the completed object
	return PlayGrid
end

function PlayGrid:draw()
	-- Go through each tile
	for column = 0, self.sourceMap.mapWidth - 1 do
		for row = 0, self.sourceMap.mapHeight - 1 do
			-- Get everything in that tile
			for tileElementIndex, tileElement in pairs(self.tiles[column][row]) do
				-- Tell it to draw
				tileElement:draw()
			end
		end
	end
end
