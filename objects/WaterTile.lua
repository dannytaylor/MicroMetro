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

function WaterTile:draw()
	-- We need to draw a circle where the water tile lives
	local drawMode = "fill"
	local drawColor = { 000, 064, 255, 255 }
	love.graphics.setColor(drawColor)
	
	-- Move the draw location to accommodate the canvas
	local canvasX, canvasY = Canvas:ToCanvasCoordinates(self.xPosition, self.yPosition)
	canvasX = canvasX + PlayGrid.GridSize / 2
	canvasY = canvasY + PlayGrid.GridSize / 2
	love.graphics.circle(drawMode, canvasX, canvasY, PlayGrid.GridSize / 2)
end