--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 5/1/2017
-- Time: 1:24 AM
-- To change this template use File | Settings | File Templates.
--

-- This play controller represents active gameplay
-- Therefore, things like a map should be chosen already
-- Main menu is it's own dealio

PlayController = Object:extend()

function PlayController:new(targetMapPath, difficulty)
	-- Initialize some variables
	self.targetMapPath = targetMapPath
	self.difficulty = difficulty
	
	-- Load the map up
	self.map = PlayController:LoadMap(self.targetMapPath)
	
	-- Create our grid
	self.playGrid = PlayGrid(self.map)
	
	
	
	--Return the new object
	return PlayController
end

function PlayController:LoadMap(targetMapPath)
	-- Load the map file path, probably in assets/maps/
	-- We load it as a LUA code chunk
	local mapChunk = love.filesystem.load(targetMapPath)
	
	-- Run the map chunk to create it
	local loadedMap = mapChunk()
	
	-- And we return the loaded map
	return loadedMap
end
