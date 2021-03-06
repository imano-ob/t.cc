
require "block"
require "stage"

function create(info)

  local n = 5
  
  local x = 30
  local y = 300
  
  local xdiff = 20
  local ydiff = 20
  
  local width = 50
  local height = 20
  
  local wvar = 20
  local hvar = 10

  local xvar = 30
  local yvar = 30

  local miny = 0
  
  if not stage then return end

  if info then
    x = info.x or x
    y = info.y or y
    width = info.width or width
    height = info.height or height
    n = info.n or n
    xdiff = info.xdiff or xdiff
    ydiff = info.ydiff or ydiff
    wvar = info.wvar or  wvar     
    hvar = info.hvar or hvar     
    xvar = info.xvar or xvar     
    yvar = info.yvar or yvar     
  end
  local firstx
  local firsty
  for i=1,n do
    local h = height + math.random(-hvar, hvar)
    local w = width + math.random(-wvar, wvar)
    x = x + math.random(-xvar, xvar)
    y = y + math.random(-yvar, yvar)
    miny = math.min(y, miny)
    if i == 1 then
      firstx = x
      firsty = y + h
    end
    table.insert(
      stage.blocks,
      block:new{
        x = x,
        y = y,
        height = h,
        width = w,
      }
    )
    x = x + width + xdiff
    y = y + ((math.random() * 2) - 1) * (height + ydiff)
  end
  stage.miny = miny
  return firstx, firsty
end
