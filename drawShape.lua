local mode = 'fill'

local function DrawSquareStationType(x, y, size, color)
	love.graphics.rectangle(mode, x - size / 2, y - size / 2, size, size)
end

local function DrawTriangleStationType(x, y, size, color)
	love.graphics.ellipse(mode, x, y, size / 4, size / 2)
end

local function DrawCircleStationType(x, y, size, color)
	love.graphics.circle(mode, x, y, size / 2)
end

local StationTypeDrawFunctions = {}
StationTypeDrawFunctions[StationType.CommonStations.Square] = DrawSquareStationType
StationTypeDrawFunctions[StationType.CommonStations.Triangle] = DrawTriangleStationType
StationTypeDrawFunctions[StationType.CommonStations.Circle] = DrawCircleStationType

function drawShape(x, y, size, shape, color)
	
	-- Call the appropriate function
	local targetDrawFunction = StationTypeDrawFunctions[shape]
	targetDrawFunction(x, y, size, color)
end