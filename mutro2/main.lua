-- main.lua

-- load libraries
lume = require 'lib/lume'    		-- basic helper functions   https://github.com/rxi/lume/
Object = require 'lib/classic'  	-- simple class module    	https://github.com/rxi/classic/
Draft = require 'lib/draft'   		-- draw shapes			    https://github.com/pelevesque/draft
Camera = require 'lib/hump/camera'	-- camera implementation	http://hump.readthedocs.io/en/latest/camera.html

-- require our objects
require 'obj/Game'   		-- map game is played on
require 'obj/Node'			-- simple station class thing
require 'obj/Route'		
require 'obj/Passenger'		
require 'obj/Overlay'		

-- 
require 'globals'
require 'init'
require 'helpers'

--inputs
require 'input/keyboard'
require 'input/mouse'


-- start our game
function love.load()
	initGame() --init.lua
end

function love.update(dt)
	require("lib/lovebird").update()-- debug in http://127.0.0.1:8000/ 'F1'
	-- updateGame() --init.lua

	mX,mY = love.mouse.getPosition() -- mouse position
	-- game logic loop
	wX,wY = math.ceil(mX/(WINDOW_SCALE)),math.ceil(mY/(WINDOW_SCALE)) -- mouse pos in world coords
	gX,gY = math.ceil(wX/(TILE_SIZE)),math.ceil(wY/(TILE_SIZE)) -- mouse pos in world coords
	game:update(dt)

end

function love.draw()
	love.graphics.setCanvas(canvas)	
	love.graphics.clear()

	game:draw()
	overlay:draw()

	love.graphics.setCanvas()
	love.graphics.draw(canvas, 0, 0, 0, WINDOW_SCALE, WINDOW_SCALE)

	if DEBUG then
		love.graphics.setColor(100,0,100,255)
		-- love.graphics.print("mX,mY = " .. mX .. ", " .. mY, WINDOW_W*WINDOW_SCALE-160, WINDOW_H*WINDOW_SCALE-64)
		love.graphics.print("gX,gY = " .. gX .. ", " .. gY, WINDOW_W*WINDOW_SCALE-160, WINDOW_H*WINDOW_SCALE-48)
		love.graphics.print("wX,wY = " .. wX .. ", " .. wY, WINDOW_W*WINDOW_SCALE-160, WINDOW_H*WINDOW_SCALE-24)
	end

end