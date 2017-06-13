draft = Draft('fill') -- for drawing primitives

function initGame()
	-- basic game setup stuff

	-- setup game window
	windowIcon = love.image.newImageData('assets/windowIcon.png')
	love.window.setTitle('micro metro')
	love.window.setIcon(windowIcon)

	love.window.setMode(window_width*window_scale, window_height*window_scale, {msaa = 0})

	-- canvas setup
	canvas = love.graphics.newCanvas(window_width, window_height,"normal",0)
	canvas:setFilter("nearest", "nearest")


	allNodes = {} -- no stations added yet and always start from blank map
	-- route dragging stuff
	dragState = false -- mouse can only be dragging one thing at a time so we can use a single bool
	dragNode = nil -- will be set upon drag starting
	nextRoute = 1 -- first available route
	allRoutes = {}
	maxRoutes = 8 -- some arbitrary max

	-- load the test map
	currentMap = Map('map1')
	currentMap:init()
	camera = Camera(window_width*window_scale/2,window_height*window_scale/2,ZOOM_INIT)
	overlay = Overlay()


end
