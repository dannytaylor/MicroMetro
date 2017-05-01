--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 5/1/2017
-- Time: 1:19 AM
-- To change this template use File | Settings | File Templates.
--

-- This is a simple water tile. Doesn't really do anything actually

WaterTile = Object:extend()

function WaterTile:new(xPosition, yPosition)
	--Store the position just in case
	self.xPosition = xPosition
	self.yPosition = yPosition
	
	--Return the new object
	return WaterTile
end

