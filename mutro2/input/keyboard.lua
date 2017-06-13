function love.keypressed(key) -- key bindings
	if key == 'escape' then
		love.event.quit()
	elseif key == 'f1' then -- open debug window
		love.system.openURL( 'http://127.0.0.1:8000/' )
	end
end