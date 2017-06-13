function love.mousepressed(x,y,button,istouch)
	if button == 1 then -- left click
		if #allRoutes < maxRoutes then
		local testNode = getNode(gX,gY) -- get the node clicked, nil if didn't click on node
			if testNode then -- and if there are available routes to add TODO
				-- and if testNode doesn't already have one of the available routes
				dragState = true
				dragNode = testNode -- set the drag node to the one at mouse location
				dragRoute = Route(nextRoute,dragNode) -- make a new route
			end
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
			if #dragRoute.nodes > 1 then
				allRoutes[#allRoutes+1] = dragRoute
			end
			dragRoute = nil
		end
	end
end