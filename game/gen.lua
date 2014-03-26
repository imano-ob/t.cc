
require "block"

local n = 5

local x = 0
local y = 20

local xdiff = 20
local ydiff = 20

local width = 50
local height = 20

function create(info)
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
        height = height,
        width = width,
      }
    )
    x = x + width + xdiff
    y = y + height + ydiff
  end
end
