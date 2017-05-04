-- Node.lua

Node = Object:extend()

-- STATIC node properties
Node.bufferSize = 3 -- buffer so stations aren't too close together

function Node:new(type) -- will create a new station
	self.type = type or getRandomType() -- if type not specified will be random
	self.routes = {} -- a new node will not be connected to any routes yet
	self.neighbors = {} -- will have no neighbors without a route
	self.x, self.y = Node:getSpawnPoint() -- needs to find an allowable spawn point
	if not self.x then return nil end -- if no spawn points left return nil, no node created
end

function Node:draw()
	if self.x then draft:rectangle((self.x-0.5)*tileSize, (self.y-0.5)*tileSize, tileSize,tileSize)
	end
end

function Node:getSpawnPoint()
	-- repeat until allowable tile found; if spawn area has space
	local spawnSpace = false -- is there spawn space
	for i=1,currentMap.spawnW-1 do
		for j=1,currentMap.spawnH-1 do
			if currentMap.tileState[i+currentMap.spawnX][j+currentMap.spawnY] == 0 then
				spawnSpace = true -- if there's at least one good tile we can proceed
			end
		end
	end

	-- if spawn area has room
	if spawnSpace then
		repeat
			-- random test point within allowable spawn area
			local testX = lume.round(love.math.random(currentMap.spawnX+1,currentMap.spawnX+currentMap.spawnW))
			local testY = lume.round(love.math.random(currentMap.spawnY+1,currentMap.spawnY+currentMap.spawnH))
			local testState = currentMap.tileState[testX][testY]
			local testIsOK = true

			-- check if found tile is ok
			for i = 1,4 do -- 1 to 4 are bad tile states
				if testState == i then
					testIsOK = false -- bad tile state found
				end
			end

			-- if test tile is allowable spawn station
			if testIsOK then
				currentMap.tileState[testX][testY] = 2 -- add station tile
				for i=-self.bufferSize,self.bufferSize do -- change all empty surrounding tiles to buffer space
					for j=-self.bufferSize,self.bufferSize do
						if currentMap.tileState[testX+i][testY+j] == 0 then -- change all 
							currentMap.tileState[testX+i][testY+j] = 4
						end
					end
				end
				return testX,testY
			end
		until isTestOK
	else 
		print('no room for more stations')
		return nil
	end -- find an allowable spawn point if exists
end

function Node:hasRoute(r)
	for i,route in ipairs(self.routes) do
		if route == r then return true end
	end
	return false
end

function Node:addRoute(route)
	self.routes[#self.routes+1]=route
end