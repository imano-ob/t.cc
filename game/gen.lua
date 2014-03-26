
require "block"


function create(info)

  local n = 5
  
  local x = 0
  local y = 20
  
  local xdiff = 20
  local ydiff = 20
  
  local width = 50
  local height = 20
  
  local wvar = 20
  local hvar = 10
  
  if info then
    x = info.x or x
    y = info.y or y
    width = info.width or width
    height = info.height or height
    n = info.n or n
    xdiff = info.xdiff or xdiff
    ydiff = info.ydiff or ydiff
  end
  for i=1,n do
    table.insert(
      blocks,
      block:new{
        x = x,
        y = y,
        height = height + math.random(-hvar, hvar),
        width = width + math.random(-wvar, wvar),
      }
    )
    x = x + width + wvar + math.random(0, xdiff)
    y = y + ((math.random() * 2) - 1) * (height + ydiff)
  end
end
