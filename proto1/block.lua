
require "lux.object"

require "globals"

block = lux.object.new{
  x = 0,
  y = 0,
  width = 0,
  height = 0,
--[[  color = {
    255,
    0,
    0,
},]]
}

function block:draw(color)
  love.graphics.setColor(color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

blocks = {}