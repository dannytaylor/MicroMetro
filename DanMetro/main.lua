-- main.lua
lume = require 'lib/lume'
Object = require 'lib/classic'
Draft = require 'lib/draft'
local draft = Draft('fill')

Grid = require 'obj/Grid'
Route = require 'obj/Route'

routes = {Route()} -- list of all game routes

mX, mY, gX, gY = 0, 0, 0, 0 -- mouse location in grid coords
local dragNode = nil

function love.load()
	love.window.setTitle('micro metro')
	
	-- load water info
	local mapImage = love.image.newImageData('assets/map1.png')

	-- graphics and game sizing init
	tileSize = 8
	mapW = 64
	mapH = 48
	canvasW = mapW*tileSize
	canvasH = mapH*tileSize
	canvasScale = 2
	
	screen = love.graphics.newCanvas(canvasW, canvasH)
	screen:setFilter('nearest', 'nearest')
	love.window.setMode(canvasW*2, canvasH*2)

	gameGrid = Grid(mapImage) -- make game grid of this size

end

function love.update(dt)
	-- debug in http://127.0.0.1:8000/ 'F1'
	require("lib/lovebird").update()

	-- mouse coord adjustments for screen scale
	mX, mY = love.mouse.getPosition()
	mX, mY = mX/canvasScale, mY/canvasScale
	-- mouse in grid coords
	gX = math.floor(mX/tileSize)+1
	gY = math.floor(mY/tileSize)+1

	if gameGrid:isStation(gX,gY) then
		-- if we are in a dragging state
		if dragNode then
			-- and the moused over station isn't our drag station
			if dragNode[1]~=gX or dragNode[2]~=gY then
				-- create a route between dragNode and new node
				local line = {dragNode[1],dragNode[2],gX,gY} -- x1,y1,x2,y2
				routes[1]:addEdge(line)
				-- set new node as dragNode
				dragNode = {gX,gY,1}
			end
		else -- if there is no current drag node
			-- and you've clicked a station
			if love.mouse.isDown(1) then
				-- set the moused over node as the dragNode
				dragNode = {gX,gY,0} -- 0 is route index
				-- assume if we're clicking a station not an edge we're making a route from scratched
			end
		end
	end

	-- if a drag has been started
	if dragNode then
		-- cancel drag if mouse released
		if not love.mouse.isDown(1) then
			dragNode = nil
		end
	end

end

function love.draw()
  love.graphics.setCanvas(screen)
  love.graphics.clear()


	gameGrid:draw()


	if gameGrid:isStation(gX,gY) then
		-- draw some highlighting square
		if dragNode then love.graphics.setColor(255, 0, 0, 255)
		else love.graphics.setColor(255, 255, 000, 255) end
		draft:rectangle((gX-0.5)*tileSize,(gY-0.5)*tileSize,tileSize,tileSize)
		love.graphics.setColor(255, 255, 255, 255)
	end

	drawDrag()

	-- if there are routes to draw
	if #routes then
		for i,route in ipairs(routes) do route:draw() end
	end

  love.graphics.setCanvas()
  love.graphics.draw(screen, 0, 0, 0, canvasScale, canvasScale) 

end

function drawDrag()
	if dragNode then
		draft:line({(dragNode[1]-0.5)*tileSize,(dragNode[2]-0.5)*tileSize,mX,mY})
	end
end

function love.keypressed(key)

	if key == 'escape' then
		love.event.quit()
	-- open debug window
	elseif key == 'f1' then
		love.system.openURL( 'http://127.0.0.1:8000/' )

	elseif key == '1' then
		gameGrid:increaseSpawn(1)
	elseif key == '2' then
		gameGrid:increaseSpawn(-1)
	--test reloading map
	elseif key == '3' then
		gameGrid = nil
		gameGrid = Grid(love.image.newImageData('assets/map1.png'))
	elseif key == '4' then
		gameGrid.addStation()

	end
end