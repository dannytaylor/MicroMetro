Route = Object:extend()

function Route:new()
	self.color = nil
	self.stations= {}
end
function Route:draw()
	love.graphics.setColor(255, 0, 255)
	if #self.stations > 1 then
		for i=1, #self.stations-1 do
			local startX, startY 	= self.stations[i].x, self.stations[i].y
			local endX, endY 		= self.stations[i+1].x, self.stations[i+1].y
			love.graphics.line(startX,startY,endX,endY)
		end
	end
	love.graphics.setColor(255, 255, 255)
end

