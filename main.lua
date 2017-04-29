
require 'drawShape'
require 'initTests'

font = love.graphics.newFont('assets/fonts/battlenet.ttf',16)

-- game window settings
canvasWidth  = 960
canvasHeight = 720
canvasScale  = 1

-- game info
GameTime  = 0
GameScore = 0



-- Run when game is started
function love.load()
	-- load class library by rxi
	Object = require "libraries/classic"
	-- load all object files in the 'objects' folder
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)
	
	-- only using one font so set it at load
	love.graphics.setFont(font)
	-- set canvas resolution
	main_canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
	
	-- no aliasing when scaling window
	main_canvas:setFilter('nearest', 'nearest')
	
	stations = {}
	trains = {}
	routes = {}
	
	initTests()

end

-- Game loop; updates every frame
function love.update(dt)
	-- global mouse coords available to everything
	mx = love.mouse.getX()
	my = love.mouse.getY()

	--update all stations
	for i = 1, #stations do
		stations[i]:update(dt)
	end
	
	--update all trains
	for i = 1, #trains do
		trains[i]:update(dt)
	end

	for i = 1, #routes do
		routes[i]:update(dt)
	end

	--update game time
	GameTime = GameTime + 1


end


-- draw loop; updates every frame
function love.draw()
	-- draw to our main canvas
	love.graphics.setCanvas(main_canvas)
	-- clear previous frame
	love.graphics.clear()
	
	-- draw stations
	for i = 1, #stations do
		stations[i]:draw()
	end
	
	-- draw trains
	for i = 1, #trains do
		trains[i]:draw()
	end

	-- draw routes
	for i = 1, #routes do
		routes[i]:draw()
	end
	
	--show our game timer and score
	love.graphics.print("game time: " .. GameTime, canvasWidth - 300, 8)
	love.graphics.print("game score: " .. GameScore, canvasWidth - 300, 24)

	-- -- debug train station targets
	-- love.graphics.print("previous station: " .. trains[1].previousStation, canvasWidth - 300, 40)
	-- -- love.graphics.print("current station: " .. trains[1].currentStation, canvasWidth - 300, 56)
	-- love.graphics.print("next station: " .. trains[1].nextStation, canvasWidth - 300, 62)


	-- reset drawing to the screen
	love.graphics.setCanvas()
	-- draw whats been put on main_canvas at x3 scale
	love.graphics.draw(main_canvas, 0, 0, 0, canvasScale, canvasScale)
end


-- recursive file loading function per:
-- https://github.com/adonaac/blog/issues/12
function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. '/' .. item
		if love.filesystem.isFile(file) then
			table.insert(file_list, file)
		elseif love.filesystem.isDirectory(file) then
			recursiveEnumerate(file, file_list)
		end
	end
end

function requireFiles(files)
	for _, file in ipairs(files) do
		local file = file:sub(1, -5)
		require(file)
	end
end
