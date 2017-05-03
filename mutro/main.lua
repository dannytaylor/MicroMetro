-- todo
-- logic for adding routes removing

-- main.lua
lume = require 'lib/lume'    		-- basic helper functions   https://github.com/rxi/lume/
Object = require 'lib/classic'  	-- simple class module    	https://github.com/rxi/classic/
Draft = require 'lib/draft'   		-- draw shapes			    https://github.com/pelevesque/draft
Camera = require 'lib/hump/camera'	-- camera implementation	http://hump.readthedocs.io/en/latest/camera.html
local draft = Draft('fill')

Grid = require 'obj/Grid'   		-- my simple game grid type

require 'obj/Route'   		-- for routes
require 'obj/Node'			-- simple station class thing

routes = {}         						-- list of all game routes
nodes = {} 									-- list of all stations

tileSize = 8
mapW = 128
mapH = 72
camZoomMax = 4
camZoomMin = 1
canvasScale = 3

local dragNode = nil
local dragRoute = 1

function love.load()
	love.window.setTitle('micro metro')
	
	-- load water info
	local mapImage = love.image.newImageData('assets/map1.png')

	-- graphics and game sizing init
	canvasW = mapW*tileSize
	canvasH = mapH*tileSize
	
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	love.window.setMode(1280, 720,{resizable=true, vsync=false, minwidth=400, minheight=300})

	camera = Camera(canvasW/2,canvasH/2,camZoomMax)

	gameGrid = Grid(mapImage) -- make game grid of this size

end

function love.update(dt)
	-- debug in http://127.0.0.1:8000/ 'F1'
	require("lib/lovebird").update()

 	camera:zoom(0.9999)

	-- mouse coord adjustments from cam to world coords
	mX, mY = camera:worldCoords(love.mouse.getPosition())
	
	-- mouse in grid coords
	gX = math.floor(mX/tileSize)+1
	gY = math.floor(mY/tileSize)+1
	
	mouseLogic()
	print(#nodes)
end

function love.draw()
	camera:attach()


	gameGrid:draw()
	if mouseInBounds and gameGrid:isStation(gX,gY) then
		-- draw some highlighting square
		if dragNode then love.graphics.setColor(255, 0, 0, 255)
		else love.graphics.setColor(255, 255, 000, 255) end
		draft:rectangle((gX-0.5)*tileSize,(gY-0.5)*tileSize,tileSize,tileSize)
		love.graphics.setColor(255, 255, 255, 255)
	end

	if dragNode then -- if we're dragging then draw from dragnode to mouse
		drawToPoint((dragNode.x-0.5)*tileSize,(dragNode.y-0.5)*tileSize,mX,mY)
	end

	-- if there are routes to draw
	if #routes then
		for i,route in ipairs(routes) do route:draw() end
	end

	debugGrid()
	camera:detach()

end

function debugGrid()
	love.graphics.setColor(255,255,255,40)
	for i=1, mapW-1 do
		draft:line({i*tileSize,0,i*tileSize,canvasH})
	end
	for j=1, mapH-1 do
		draft:line({0,j*tileSize,canvasW,j*tileSize})
	end
	love.graphics.setColor(255,255,255,255)
end

function drawToPoint(x1,y1,x2,y2)
	-- angled portion will be for the shorter segment
	local dX = x2 - x1
	local dY = y2 - y1
	love.graphics.setColor(255, 255, 255)

	-- setup cases; will simplify cases later
	
	if math.abs(dX) == math.abs(dY) or dX == 0 or dY == 0 then -- diagonals case
		draft:line({x1,y1,x2,y2})
	elseif dX > 0 then -- edge moving right
		if dY > 0 then -- edge moving down
			if dX > dY then -- angled portion based on dY
				draft:line({x1,y1,x1+dY,y1+dY,x2,y2})
			else -- angled portion based on dx
				draft:line({x1,y1,x1+dX,y1+dX,x2,y2})
			end
		elseif dY < 0 then
			if math.abs(dX) > math.abs(dY) then -- angled portion based on dY
				draft:line({x1,y1,x1-dY,y1+dY,x2,y2})
			elseif math.abs(dY) > math.abs(dX) then -- angled portion based on dx
				draft:line({x1,y1,x1+dX,y1-dX,x2,y2})
			end
		end
	elseif dX < 0 then -- edge moving right
		if dY > 0 then -- edge moving down
			if math.abs(dX) > math.abs(dY) then -- angled portion based on dY
				draft:line({x1,y1,x1-dY,y1+dY,x2,y2})
			else -- angled portion based on dx
				draft:line({x1,y1,x1+dX,y1-dX,x2,y2})
			end
		elseif dY < 0 then
			if math.abs(dX) > math.abs(dY) then -- angled portion based on dY
				draft:line({x1,y1,x1+dY,y1+dY,x2,y2})
			else-- angled portion based on dx
				draft:line({x1,y1,x1+dX,y1+dX,x2,y2})
			end
		end
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
	elseif key == '3' then
		gameGrid.addStation()
	elseif key == 'q' then
		camera:zoom(1.20)
	elseif key == 'e' then
		camera:zoom(0.80)
	elseif key == 'w' then
		camera:move(0,-10)
	elseif key == 'a' then
		camera:move(-10,0)
	elseif key == 's' then
		camera:move(0,10)
	elseif key == 'd' then
		camera:move(10,0)
	end
end


function mouseLogic()
	-- assume mouse out of grid bounds for starters
	mouseInBounds = false--otherwise we're referencing non-existent grid points
	if mX > 0 and mX < canvasW and mY>0 and mY< canvasH then mouseInBounds = true end

	if mouseInBounds and gameGrid:isStation(gX,gY) then
		if dragNode then-- if we are in a dragging state
			-- and the moused over station isn't our drag station
			if dragNode.x~=gX or dragNode.y~=gY then
				-- if new node is already on dragNode's route
				if dragNode:hasRoute(dragRoute) then 
					-- remove if last node
					local lastX = routes[dragRoute].rNodes[#routes[dragRoute].rNodes].x
					local lastY = routes[dragRoute].rNodes[#routes[dragRoute].rNodes].y
					if lastX == gX and lastY == gY then
						routes[dragRoute]:removeNode(gX,gY)
					end
				else
				end
				-- remove if last node
				-- check if newNode on route
				

				-- create a route between dragNode and new node
				local line = {dragNode.x,dragNode.y,gX,gY} -- x1,y1,x2,y2
				if not routes[1] then routes[1] = Route() end

				routes[1]:addEdge(line)
				
				-- set new node as dragNode
				dragNode = getNode(gX,gY)
			end
		else -- if there is no current drag node
			-- and you've clicked a station
			if love.mouse.isDown(1) then
				-- set the moused over node as the dragNode
				dragNode = getNode(gX,gY)
				-- add the current route type(only '1') to dragNode
				dragRoute = 1
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

function getNode(x,y) -- gets whatever node is at x,y if there
	if #nodes then
		for i,testNode in ipairs(nodes) do
			if testNode.x == x and testNode.y == y then
				return testNode
			end
		end
	end
	return nil
end