
require "block"


function create(info)

  local n = 5
  
  local x = 0
  local y = 300
  
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
  local firstx = x
  local firsty = y
  for i=1,n do
    local h = height + math.random(-hvar, hvar)
    local w = width + math.random(-wvar, wvar)
    if i == 1 then
      firsty = y + h
    end
    table.insert(
      blocks,
      block:new{
        x = x,
        y = y,
        height = h,
        width = w,
      }
    )
    x = x + width + wvar + math.random(0, xdiff)
    y = y + ((math.random() * 2) - 1) * (height + ydiff)
  end
  return firstx, firsty
end
