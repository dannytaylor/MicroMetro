-- Map.lua

Map = Object:extend()

function Map:new(name) -- map file name
	local mapImage = love.image.newImageData('assets/'..name..'.png')
	allNodes = {} -- no stations added yet and always start from blank map
	self.tileState = {}

	-- global map dimensions based on map image
	self.width, self.height = mapImage:getWidth(), mapImage:getHeight()
	canvasW, canvasH = self.width*tileSize, self.height*tileSize

	self.spawnW, self.spawnH = self.width/4, self.height/4 -- initialize as quarter of map size
	self.spawnX, self.spawnY = self.width/2-self.spawnW/2, self.height/2-self.spawnH/2 -- spawn area in center of map

	-- set up camera for map with initial zoom in the center of map
	camera = Camera(canvasW/2,canvasH/2,zoomInit)
	zoomTo = zoomInit 

	for i=1, self.width do -- initialize map as empty first
		self.tileState[i] = {}
		for j=1, self.height do
			self.tileState[i][j] = 0
		end
	end

	local waterColor = 255,255,255,255 -- the color of water indicator on map image
	for x = 1,  self.width-1 do -- initialize map state from loaded image
	    for y = 1, self.height-1 do
	        if (waterColor == mapImage:getPixel( x, y )) then
	        	self.tileState[x][y] = 1
	        end
	    end
	end


end

function Map:init() -- some initial map setup stuff
	allNodes[1] 			= Node(1) -- one of each type at start
	allNodes[#allNodes+1] 	= Node(2) 
	allNodes[#allNodes+1] 	= Node(3) 

	-- route dragging stuff
	dragState = false -- mouse can only be dragging one thing at a time so we can use a single bool
	dragNode = nil -- will be set upon drag starting
	nextRoute = 1 -- first available route
	allRoutes = {}
end

function Map:draw()
	-- draw the map picture first
	if debug then -- draw spawn tile indicators
		-- draw spawnable area
		love.graphics.setColor(200,0,100,100) 
		draft:rectangle(self.width*tileSize/2,self.height*tileSize/2,self.spawnW*tileSize,self.spawnH*tileSize)

		-- draw grid indicator
		love.graphics.setColor(55,55,55,255)
		love.graphics.setLineWidth(0.5)
		for i=1, self.width-1 do
			draft:line({i*tileSize,0,i*tileSize,canvasH})
		end
		for j=1, self.height-1 do
			draft:line({0,j*tileSize,canvasW,j*tileSize})
		end

		love.graphics.setColor(255,255,255,255)
		-- draw every tile state
		for i=1, self.width do
			for j=1, self.height do
				local sx = (i-0.5)*tileSize
				local sy = (j-0.5)*tileSize
				love.graphics.setColor(255,255,255,255)
				if 	   self.tileState[i][j] == 1 then love.graphics.setColor(000,000,255,255) draft:circle(sx,sy,tileSize/2)	--water
				elseif self.tileState[i][j] == 2 then love.graphics.setColor(255,255,255,255) draft:circle(sx,sy,tileSize/2)	--station
				elseif self.tileState[i][j] == 3 then love.graphics.setColor(055,055,055,255) draft:circle(sx,sy,tileSize/2)	--line
				elseif self.tileState[i][j] == 4 then love.graphics.setColor(000,128,064,255) draft:circle(sx,sy,tileSize/2)	--station buffer
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