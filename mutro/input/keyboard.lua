function love.keypressed(key) -- key bindings
	if key == 'escape' then
		love.event.quit()
	elseif key == 'f1' then -- open debug window
		love.system.openURL( 'http://127.0.0.1:8000/' )

	-- elseif key == 'q' then
	-- 	camera:zoom(1.20)
	-- 	-- zoomTo = zoomTo+0.2
	-- elseif key == 'e' then
	-- 	camera:zoom(0.80)
	-- 	-- zoomTo = zoomTo -0.5
	elseif key == 'w' then
		camera:move(0,-10)
	elseif key == 'a' then
		camera:move(-10,0)
	elseif key == 's' then
		camera:move(0,10)
	elseif key == 'd' then
		camera:move(10,0)
	-- elseif key == '1' then
	-- 	currentMap:increaseSpawn()
	-- elseif key == '2' then
	-- 	currentMap:increaseSpawn(-1)
	elseif key == '3' then
		allNodes[#allNodes+1] = Node()
	end
end