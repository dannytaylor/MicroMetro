-- Map.lua

Game = Object:extend()

function Game:new(name) 

	local img = love.image.newImageData('assets/'..name..'.png')
	self.w, self.h = img:getWidth(), img:getHeight()

	self.state = {}



	local waterColor = 255,255,255,255 -- the color of water indicator on map image
	-- init state grid to empty
	for i=1, WINDOW_W do -- initialize map as empty first
		self.state[i] = {}
		for j=1, WINDOW_H do
			if i<self.w + 1 and j<self.h + 1 and (waterColor == img:getPixel( i - 1, j - 1)) then
	        	self.state[i][j] = 'water'
			else
				self.state[i][j] = 'empty'
			end
		end
	end


end

function Game:addNode(type)
	local t = type -- or ''
	-- is there spawn space
	local good_spot = false
	for i=1,self.w do
		for j=1,self.h do
			if self.state[i][j] == 'empty' then
				good_spot = true -- if there's at least one good tile we can proceed
			break end
		end
	end

	if good_spot then
		repeat
			local testX, testY = lume.round(love.math.random(1,self.w)), lume.round(love.math.random(1,self.h))
			if self.state[testX][testY] == 'empty' then
				self.state[testX][testY] = 'station'

				-- change all empty surrounding tiles to buffer space
				for i=-bSize,bSize do 
					for j=-bSize,bSize do
						if (testX+i)>0 and (testY+j)>0 and (testX+i)<self.w  and (testY+j)<self.h then
							if self.state[testX+i][testY+j] == 'empty' then -- change all 
								self.state[testX+i][testY+j] = 'buffer'
							end
						end
					end
				end

				good_spot = false --break loop, shouldn't be needed
				NODES[#NODES+1] = Node(testX,testY)
				-- return type
			end
		until not good_spot
	else
		print('no more spawn area')
	end
end

function Game:draw()
	-- draw the map picture first
	if DEBUG then -- draw spawn tile indicators
		love.graphics.setColor(255,255,255,255)
		-- draw every tile state
		for i=1, WINDOW_W  do
			for j=1, WINDOW_H  do
				local sx = (i-0.5)*TILE_SIZE
				local sy = (j-0.5)*TILE_SIZE
				love.graphics.setColor(255,255,255,255)
				if 	   self.state[i][j] == 'water' 		then love.graphics.setColor(178,220,239,255) draft:square(sx,sy,TILE_SIZE)	--water
				elseif self.state[i][j] == 'station' 	then love.graphics.setColor(255,255,255,255) draft:square(sx,sy,TILE_SIZE)	--station
				elseif self.state[i][j] == 'spawn' 		then love.graphics.setColor(055,055,055,255) draft:square(sx,sy,TILE_SIZE)	--line
				elseif self.state[i][j] == 'buffer' 	then love.graphics.setColor(000,128,064,255) draft:square(sx,sy,TILE_SIZE)	--station buffer
				end -- empty tile does nothing
			end
		end
	end

	for i,node in ipairs(NODES) do
		node:draw()
	end
end

function Game:update(dt)
	for i,node in ipairs(NODES) do
		if node.x == gX and node.y == gY then
			node.mouseover = true
		else
			node.mouseover = false
		end
	end
end