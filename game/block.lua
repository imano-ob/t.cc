
require "lux.object"

require "globals"

block = lux.object.new{
  x = 0,
  y = 0,
  width = 0,
  height = 0,
  color = {
    255,
    0,
    0,
  },
}

function block:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

blocks = {}

--[[table.insert( 
              blocks,
              block:new{
                x = 200,
                y = 50,
                height = 50,
                width = 200,
              }
            )
]]