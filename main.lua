-- load class library by rxi
Object = require "libraries/classic"
require 'drawShape'

-- Run when game is started
function love.load()

  -- load all object files in the 'objects' folder
  local object_files = {}
  recursiveEnumerate('objects',object_files)
  requireFiles(object_files)

  -- set canvas resolution
  main_canvas = love.graphics.newCanvas(320, 240)
	
	-- no aliasing
  main_canvas:setFilter('nearest','nearest')

  stations = {}
  trains = {}
  passengers = {}
  routes = {}

  -- set up 3 initial stations
  for i=1,3 do
    table.insert(stations,Station(love.math.random(20,240),love.math.random(20,160),'square'))
    -- add random # of passengers to a station
    for j=1, love.math.random(0,8) do
      table.insert(stations[i].passengers,1)
    end
  end

  -- 2 test trains
  for i=1,3 do
    table.insert(trains,Train(love.math.random(20,280),love.math.random(20,200)))
    -- add random number of passengers
    for j=1, love.math.random(0,6) do
      table.insert(trains[i].passengers,1)
    end
  end

end

-- Game loop; updates every frame
function love.update(dt)
  --update all stations
  for i=1, #stations do
    stations[i]:update(dt)
  end

  --update all trains
  for i=1, #trains do
    trains[i]:update(dt)
  end
end


-- draw loop; updates every frame
function love.draw()
  -- draw to our main canvas
  love.graphics.setCanvas(main_canvas)
  -- clear previous frame
  love.graphics.clear()

  -- -- test box and circle
  -- love.graphics.setLineWidth(10)
  -- love.graphics.rectangle('line', 160, 120, 40, 40)
  --
  -- love.graphics.setColor(255, 0, 255)
  -- love.graphics.circle('fill', x, y, 20)
  -- love.graphics.setColor(255, 255, 255)

  -- draw stations
  for i=1, #stations do
    stations[i]:draw()
  end

  -- draw trains
  for i=1, #trains do
    trains[i]:draw()
  end

  -- reset drawing to the screen
  love.graphics.setCanvas( )
  -- draw whats been put on main_canvas at x3 scale
  love.graphics.draw(main_canvas, 0, 0, 0, 3, 3)
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
