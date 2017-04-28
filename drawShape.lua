local mode = 'fill'

function drawShape (x,y,size, shape, color)

	-- square
	if shape == 1 then
		love.graphics.rectangle(mode, x, y, size, size)

	-- circle
	elseif shape == 2 then
		love.graphics.circle(mode, x, y, size, size)

	-- ellipse
	elseif shape == 3 then
		love.graphics.ellipse(mode,x,y,size/2,size)
	end
end
