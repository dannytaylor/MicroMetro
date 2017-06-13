--
-- Created by IntelliJ IDEA.
-- User: Devin
-- Date: 5/1/2017
-- Time: 10:49 PM
-- To change this template use File | Settings | File Templates.
--

Canvas = Object:extend()

function Canvas:ToCanvasCoordinates(gridX, gridY)
	-- We need to multiply by the size of the grids
	local canvasX = gridX * PlayGrid.GridSize
	local canvasY = gridY * PlayGrid.GridSize
	return canvasX, canvasY
end