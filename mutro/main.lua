-- main.lua

-- load libraries
lume = require 'lib/lume'    		-- basic helper functions   https://github.com/rxi/lume/
Object = require 'lib/classic'  	-- simple class module    	https://github.com/rxi/classic/
Draft = require 'lib/draft'   		-- draw shapes			    https://github.com/pelevesque/draft
Camera = require 'lib/hump/camera'	-- camera implementation	http://hump.readthedocs.io/en/latest/camera.html

draft = Draft('fill')

-- require our objects
require 'obj/Map'   		-- map game is played on
require 'obj/Node'			-- simple station class thing
require 'obj/Route'			

-- STATIC globals
tileSize = 8 -- static tileSize
zoomInit = 4
zoomMax = 1

debug = true -- to draw some debugging info

-- start our game
function love.load()
	-- setup game window

	windowIcon = love.image.newImageData('assets/windowIcon.png')
	cursor = love.graphics.newImage('assets/cursor.png')
	love.window.setTitle('micro metro')
	love.window.setIcon(windowIcon)
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	love.window.setMode(1280, 720,{resizable=true, vsync=false, minwidth=480, minheight=320})

	love.mouse.setVisible(false) -- hide cursor to use custom cursor
	love.mouse.setGrabbed(true) -- confine mouse to window

	-- init the game state
	GameState = 2 -- start game in map for now

	currentMap = Map('map1')
	currentMap:init()

end

function love.update(dt)
	require("lib/lovebird").update()-- debug in http://127.0.0.1:8000/ 'F1'
	mX,mY = love.mouse.getPosition() -- mouse position

	-- game logic loop
	if GameState == 1 then -- do main menu stuff
	elseif GameState == 2 then -- do game stuff
		wX,wY = camera:worldCoords(mX,mY) -- mouse pos in world coords
		gX,gY = math.floor(wX/tileSize)+1, math.floor(wY/tileSize)+1 -- mouse in grid coords

		-- route dragging logic
		if dragState then
			-- if we mouse over a node
			local testNode = getNode(gX,gY)
			local sameNode = dragNode.x == gX and dragNode.y == gY -- true if dragnode == mouse over
			if testNode then 			-- if we've dragged over a node
				if not testNode.dragNode then 	-- if the node is different from the dragnode
					testNode.dragNode = true		-- add the route to the new Node
					dragRoute:addNode(testNode) 				-- add the new node to the current route
					dragNode = testNode 						-- set the new node as the new drag node
				-- if the new node isn't already a part of the dragging route
				-- else -- if same node
				-- 	if #dragRoute.nodes > 1 and then -- if we have > 1 nodes in our dragging route
				-- 		-- and it is last node in route


				end 
			end
		end

		-- camera zoom 'fake tween '
		if camera.scale then -- zoom to set value
			if camera.scale > zoomTo then
				camera:zoom(0.9999)
			end
		end
	end
end

function love.draw()
	-- draw loop

	if GameState==2 then
		camera:attach() -- start drawing world elements
		currentMap:draw()

		-- draw all dragging stuff
		if dragState then -- if in a dragging state
			-- draw line from dragNode to mouse
			drawToPoint((dragNode.x-0.5)*tileSize,(dragNode.y-0.5)*tileSize,wX,wY,dragRoute.color)
		end

		love.graphics.setColor(255, 000, 255, 255)
		for i,r in ipairs(allRoutes) do -- draw all routes
			r:draw()
		end
		-- draw all nodes
		love.graphics.setColor(255,255,255,255)
		for i,node in ipairs(allNodes) do
			node:draw()
		end

		-- draw all trains

		camera:detach()
		-- draw UI stuff
	end

	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY()) -- draw custom cursor

end

function love.mousepressed(x,y,button,istouch)
	if button == 1 then -- left click
		local testNode = getNode(gX,gY) -- get the node clicked, nil if didn't click on node
		if testNode then -- and if there are available routes to add TODO
			-- and if testNode doesn't already have one of the available routes
			dragState = true
			dragNode = testNode -- set the drag node to the one at mouse location
			dragRoute = Route(nextRoute,dragNode) -- make a new route
			allRoutes[#allRoutes+1] = dragRoute -- add the newly created node to our list of all nodes
		end
	end
end

function love.mousereleased(x,y,button,istouch)
	if button == 1 then
		if dragState then -- stop the drag action
			dragState = false 
			dragNode = nil
			for i,n in ipairs(dragRoute.nodes) do
				n.dragNode = false
			end
			dragRoute = nil
			if #allRoutes[#allRoutes].nodes < 2 then
				allRoutes[#allRoutes] = nil -- delete last route if we left it with only 1 node
			end
		end
	end
end

function getNode(x,y) -- gets the node at coordinates if there is one
	for i,node in ipairs(allNodes) do
		if node.x == x and node.y == y then return node end
	end
	return nil
end

function love.keypressed(key) -- key bindings

	if key == 'escape' then
		love.event.quit()
	elseif key == 'f1' then -- open debug window
		love.system.openURL( 'http://127.0.0.1:8000/' )

	elseif GameState == 2 then
		if key == 'q' then
			camera:zoom(1.20)
			zoomTo = zoomTo+0.2
		elseif key == 'e' then
			zoomTo = zoomTo -0.5
		elseif key == 'w' then
			camera:move(0,-10)
		elseif key == 'a' then
			camera:move(-10,0)
		elseif key == 's' then
			camera:move(0,10)
		elseif key == 'd' then
			camera:move(10,0)
		elseif key == '1' then
			currentMap:increaseSpawn()
		elseif key == '2' then
			currentMap:increaseSpawn(-1)
		elseif key == '3' then
			allNodes[#allNodes+1] = Node()
		end
	end
end

function getRandomType() -- will be more complicated for more types
	return love.math.random(1,3)
end

function drawToPoint(x1,y1,x2,y2,color)
	-- angled portion will be for the shorter segment
	local dX = x2 - x1
	local dY = y2 - y1
	love.graphics.setColor(color['r'],color['g'],color['b'])
	love.graphics.setLineWidth(2)

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

