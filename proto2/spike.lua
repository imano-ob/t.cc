
require "lux.object"

require "globals"
require "enemy"

spike = enemy:new{
  width = 10,
  height = 20,
}

function spike:__construct ()
  self.hitbox = {
    x = self.x + 2,
    y = self.y + 2,
    width = self.width - 4,
    height = self.height - 4,
  }
end

function spike:draw()
  love.graphics.push()
  love.graphics.setColor(127, 127, 127)
  love.graphics.polygon("fill", self.x, self.y,
                         self.x + self.width, self.y,
                         self.x + self.width/2, self.y + self.height)
  love.graphics.pop()
end

function spike:iscolliding(other)
  return iscolliding(other, self.hitbox)
end