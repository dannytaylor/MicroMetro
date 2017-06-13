-- main.lua

-- load libraries
lume = require 'lib/lume'    		-- basic helper functions   https://github.com/rxi/lume/
Object = require 'lib/classic'  	-- simple class module    	https://github.com/rxi/classic/
Draft = require 'lib/draft'   		-- draw shapes			    https://github.com/pelevesque/draft
Camera = require 'lib/hump/camera'	-- camera implementation	http://hump.readthedocs.io/en/latest/camera.html


-- require our objects
require 'obj/Map'   		-- map game is played on
require 'obj/Node'			-- simple station class thing
require 'obj/Route'		
require 'obj/Overlay'		

require 'globals'
require 'init'

require 'input/keyboard'
require 'input/mouse'


-- start our game
function love.load()
	initGame() --init.lua


end

function love.update(dt)
	require("lib/lovebird").update()-- debug in http://127.0.0.1:8000/ 'F1'
	mX,mY = love.mouse.getPosition() -- mouse position
	-- game logic loop
	wX,wY = camera:worldCoords(mX/window_scale,mY/window_scale) -- mouse pos in world coords
	gX,gY = math.floor(wX/TILE_SIZE)+1, math.floor(wY/TILE_SIZE)+1 -- mouse in grid coords

	-- route dragging logic
	if dragState then
		-- if we mouse over a node
		local testNode = getNode(gX,gY)
		local sameNode = dragNode.x == gX and dragNode.y == gY -- true if dragnode == mouse over
		if testNode then 			-- if we've dragged over a node
			if not testNode.dragNode then 	-- if the node isn't already on the drag route
				testNode.dragNode = true		-- add the route to the new Node
				dragRoute:addNode(testNode) 				-- add the new node to the current route
				dragNode = testNode 						-- set the new node as the new drag node
			-- if the new node isn't already a part of the dragging route
			-- else -- if same node
			-- 	if #dragRoute.nodes > 1 and then -- if we have > 1 nodes in our dragging route
			-- 		-- and it is last node in route
			elseif gX == dragRoute.nodes[1].x and gY == dragRoute.nodes[1].y then -- if it is on the route, but it's the first node
		    
		    end
		

		end

		-- -- camera zoom 'fake tween '
		-- if camera.scale then -- zoom to set value
		-- 	if camera.scale > zoomTo then
		-- 		camera:zoom(0.9999)
		-- 	end
		-- end
	end
end

function love.draw()
	-- draw loop

	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	camera:attach() -- start drawing world elements
	currentMap:draw()

	-- draw all dragging stuff
	if dragState then -- if in a dragging state
		-- draw line from dragNode to mouse
		drawToPoint((dragNode.x-0.5)*TILE_SIZE,(dragNode.y-0.5)*TILE_SIZE,wX,wY,dragRoute.color)
		dragRoute:draw()
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
	overlay:draw()

	love.graphics.setCanvas()
	love.graphics.draw(canvas, 0, 0, 0, window_scale, window_scale)
	if DEBUG then
		love.graphics.print("mX,mY = " .. mX .. ", " .. mY, 5, 5)
		love.graphics.print("gX,gY = " .. gX .. ", " .. gY, 5, 25)
		love.graphics.print("wX,xY = " .. math.floor(wX) .. ", " .. math.floor(wY), 5, 45)
	end


end

function getNode(x,y) -- gets the node at coordinates if there is one
	for i,node in ipairs(allNodes) do
		if node.x == x and node.y == y then return node end
	end
	return nil
end

function getRandomType() -- will be more complicated for more types
	return love.math.random(1,3)
end

function drawToPoint(x1,y1,x2,y2,color)
	-- angled portion will be for the shorter segment
	local dX = x2 - x1
	local dY = y2 - y1
	love.graphics.setColor(color.r,color.g,color.b)
	love.graphics.setLineWidth(ROUTE_WIDTH)

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

