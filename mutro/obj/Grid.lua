-- Grid.lua
local draft = Draft('fill')
local Grid = Object:extend()

local tileState = {{0}}

local spawnW,spawnH
local spawnX,spawnY
local numStations
local bufferSize = 2
local stations = {}


function Grid:new(mapImage)
	-- init all tile states to empty/0
	numStations = 0
	for i=1, mapW do
		tileState[i] = {}
		for j=1, mapH do
			tileState[i][j] = 0
		end
	end

	-- set all water tiles to '1' based on our map data
	for x = 1, mapImage:getWidth() do
	    for y = 1, mapImage:getHeight() do
	        -- Pixel coordinates range from 0 to mapImage width - 1 / height - 1.
	        local white = 255,255,255,255
	        if (white == mapImage:getPixel( x - 1, y - 1 )) then
	        	tileState[x][y] = 1
	        end
	    end
	end

	-- start map with 3 randomly placed stations
	-- can't be on a water tile, and can't be next to another station
	-- initially stations can only spawn in a certain area of the map
	spawnW = mapW/4 -- initialize as quarter of map size
	spawnH = mapH/4 
	spawnX = mapW/2-spawnW/2 -- spawn area in center of map
	spawnY = mapH/2-spawnH/2 

	while numStations < 3 do
		Grid:addStation()
	end
end

function Grid:draw()
	-- draw spawnable area
	love.graphics.setColor(200,0,100,255) 
	-- draft takes center points for coords
	draft:rectangle(mapW*tileSize/2,mapH*tileSize/2,spawnW*tileSize,spawnH*tileSize)
	-- draw every tile
	for i=1, mapW do
		for j=1, mapH do
			local sx = (i-0.5)*tileSize
			local sy = (j-0.5)*tileSize
			love.graphics.setColor(255,255,255,255)
			if 	   tileState[i][j] == 1 then love.graphics.setColor(000,000,255,255) draft:circle(sx,sy,tileSize/2)	--water
			elseif tileState[i][j] == 2 then love.graphics.setColor(255,255,255,255) draft:circle(sx,sy,tileSize/2)	--station
			elseif tileState[i][j] == 3 then love.graphics.setColor(055,055,055,255) draft:circle(sx,sy,tileSize/2)	--line
			elseif tileState[i][j] == 4 then love.graphics.setColor(000,128,064,255) draft:circle(sx,sy,tileSize/2)	--station buffer
			end -- empty/0

		end
	end
end

function Grid:isStation(x,y)
	if tileState and x and y then
		if tileState[x][y] == 2 then return true end
	end
	return false
end

function Grid:getAllStations()
	return stations
end

function Grid:addStation()
	-- repeat until allowable tile found; if spawn area has space
	local spawnSpace = false
	for i=1,spawnW-1 do
		for j=1,spawnH-1 do
			if tileState[i+spawnX][j+spawnY] == 0 then
				spawnSpace = true
			end
		end
	end
	-- if spawn area has room
	if spawnSpace then
		local tempNum = numStations
		while tempNum == numStations do -- retry finding a spawn tile until one is found
			-- random test point within allowable spawn area
			local testX = lume.round(love.math.random(spawnX+1,spawnX+spawnW))
			local testY = lume.round(love.math.random(spawnY+1,spawnY+spawnH))
			local testState = tileState[testX][testY]
			local testIsOK = true

			-- check if found tile is ok
			for i = 1,4 do
				if testState == i then
					testIsOK = false
				end
			end

			-- if test tile is allowable spawn station
			if testIsOK then
				-- add station tile
				tileState[testX][testY] = 2
				numStations = numStations + 1
				stations[#stations+1] = {testX,textY} 
				-- change all empty surrounding tiles to buffer space
				for i=-bufferSize,bufferSize do
					for j=-bufferSize,bufferSize do
						if tileState[testX+i][testY+j] == 0 then
							tileState[testX+i][testY+j] = 4
						end
					end
				end
				nodes[#nodes+1] = Node(testX,testY,1,{}) -- for now station type is '1', no routes will service newly created nodes
				
			end
		end
		else print('no room for more stations')
	end
end

function Grid:increaseSpawn(num)
	local increment = num or 1 -- default to 1 if not passed
	-- expanding assuming we started in the center of the map
	if spawnW < mapW-increment*2 then
		spawnW = spawnW + increment*2
		spawnX = spawnX - increment
	end
	if spawnH < mapH-increment*2 then
		spawnH = spawnH + increment*2
		spawnY = spawnY - increment
	end
end

return Grid