-- Map.lua

Map = Object:extend()

function Map:new(name) -- map file name
	local mapImage = love.image.newImageData('assets/'..name..'.png')
	self.tileState = {}

	-- global map dimensions based on map image
	self.width, self.height = mapImage:getWidth(), mapImage:getHeight()
	canvasW, canvasH = self.width*TILE_SIZE, self.height*TILE_SIZE

	self.spawnW, self.spawnH = self.width, self.height-3 -- minus 3 for ui height
	self.spawnX, self.spawnY = 0,0 -- spawn area in center of map

	-- set up camera for map with initial zoom in the center of map
	camera = Camera(canvasW/2,canvasH/2,ZOOM_INIT)

	for i=1, self.width do -- initialize map as empty first
		self.tileState[i] = {}
		for j=1, self.height do
			self.tileState[i][j] = 'empty'
		end
	end


	--set water colors
	local waterColor = 255,255,255,255 -- the color of water indicator on map image
	for x = 1,  self.width do -- initialize map state from loaded image
	    for y = 1, self.height do
	        if (waterColor == mapImage:getPixel( x-1, y-1 )) then
	        	self.tileState[x][y] = 'water'
	        end
	    end
	end

	-- set spawn area
	for x = 1,  self.spawnW do -- initialize map state from loaded image
	    for y = 1, self.spawnH do
	        if self.tileState[x][y] ~= 'water' then
	        	self.tileState[x][y] = 'spawn'
	        end
	    end
	end


end

function Map:init() -- some initial map setup stuff
	-- global game things
	allNodes[1] 			= Node(1) -- one of each type at start
	allNodes[#allNodes+1] 	= Node(2) 
	allNodes[#allNodes+1] 	= Node(3) 


end

function Map:draw()
	-- draw the map picture first
	if DEBUG then -- draw spawn tile indicators

		-- draw spawnable area
		love.graphics.setColor(200,0,100,100) 

		-- draw grid indicator
		love.graphics.setColor(55,55,55,255)
		love.graphics.setLineWidth(0.5)
		for i=1, self.width-1 do
			draft:line({i*TILE_SIZE,0,i*TILE_SIZE,canvasH})
		end
		for j=1, self.height-1 do
			draft:line({0,j*TILE_SIZE,canvasW,j*TILE_SIZE})
		end

		love.graphics.setColor(255,255,255,255)
		-- draw every tile state
		for i=1, self.width do
			for j=1, self.height do
				local sx = (i-0.5)*TILE_SIZE
				local sy = (j-0.5)*TILE_SIZE
				love.graphics.setColor(255,255,255,255)
				if 	   self.tileState[i][j] == 'water' 		then love.graphics.setColor(000,000,255,255) draft:circle(sx,sy,TILE_SIZE/2)	--water
				elseif self.tileState[i][j] == 'station' 	then love.graphics.setColor(255,255,255,255) draft:circle(sx,sy,TILE_SIZE/2)	--station
				elseif self.tileState[i][j] == 'spawn' 		then love.graphics.setColor(055,055,055,255) draft:circle(sx,sy,TILE_SIZE/2)	--line
				elseif self.tileState[i][j] == 'buffer' 	then love.graphics.setColor(000,128,064,255) draft:circle(sx,sy,TILE_SIZE/2)	--station buffer
				end -- empty tile does nothing
			end
		end
	end
end

function Map:increaseSpawn(num)
	local increment = num or 1 -- default to 1 if not passed
	-- expanding assuming we started in the center of the map
	if self.spawnW < self.width-increment*2 then
		self.spawnW = self.spawnW + increment*2
		self.spawnX = self.spawnX - increment
	end
	if self.spawnH < self.height-increment*2 then
		self.spawnH = self.spawnH + increment*2
		self.spawnY = self.spawnY - increment
	end
end