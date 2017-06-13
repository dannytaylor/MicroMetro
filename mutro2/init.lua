-- init.lua

draft = Draft('fill') -- for drawing primitives

function initGame()

	love.window.setMode(WINDOW_W*WINDOW_SCALE, WINDOW_H*WINDOW_SCALE, {msaa = 0})
	canvas = love.graphics.newCanvas(WINDOW_W, WINDOW_H,"normal",0)
	canvas:setFilter("nearest", "nearest")

	game = Game('map1')
	
	game:addNode(1)
	game:addNode(1)
	game:addNode(1)

	overlay = Overlay()
end