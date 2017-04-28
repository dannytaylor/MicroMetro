local mode = 'fill'

function drawShape (x,y,size, shape, color)
  if shape == 'square' then
    love.graphics.rectangle(mode, x, y, size, size)
  elseif shape == 'circle' then
    love.graphics.circle(mode, x, y, size, size)
  elseif shape == 'triangle' then
    love.graphics.triangle(mode,x,y+size,x+size,y+size,x+size/2,y)
  end
end
