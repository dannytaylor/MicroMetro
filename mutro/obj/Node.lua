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
	self.dragNode = false
	self.loop = false

	-- planning
	self.sockets = {} -- 8 directions, 3 sockets per dir; a inc/outg route takes 1 socket, a tail takes 3
	self.passengers = {}
	self.trainLoading = nil
	self.trainQueue = {}
	
end

function Node:draw()
	if self.x then 
		if self.type == 1 then
			draft:rectangle((self.x-0.5)*TILE_SIZE, (self.y-0.5)*TILE_SIZE, TILE_SIZE,TILE_SIZE)
		elseif self.type == 2 then
			draft:triangleIsosceles((self.x-0.5)*TILE_SIZE, (self.y-0.5)*TILE_SIZE, TILE_SIZE,TILE_SIZE)
		else
			draft:rhombus((self.x-0.5)*TILE_SIZE, (self.y-0.5)*TILE_SIZE, TILE_SIZE,TILE_SIZE)
		end
	end
end

function Node:getSpawnPoint()
	-- repeat until allowable tile found; if spawn area has space
	local spawnSpace = false -- is there spawn space
	for i=1,currentMap.spawnW do
		for j=1,currentMap.spawnH do
			if currentMap.tileState[i][j] == 'spawn' then
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
			if testState ~= 'spawn' then
				testIsOK = false -- bad tile state found
			end

			-- if test tile is allowable spawn station
			if testIsOK then
				currentMap.tileState[testX][testY] = 'station' -- add station tile
				for i=-self.bufferSize,self.bufferSize do -- change all empty surrounding tiles to buffer space
					for j=-self.bufferSize,self.bufferSize do
						if (testX+i)>0 and (testY+j)>0 and (testX+i)<currentMap.width  and (testY+j)<currentMap.height then
							if currentMap.tileState[testX+i][testY+j] == 'empty' or currentMap.tileState[testX+i][testY+j] == 'spawn' then -- change all 
								currentMap.tileState[testX+i][testY+j] = 'buffer'
							end
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