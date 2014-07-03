
require "lux.object"

rect = lux.object.new{
  x = nil,
  y = nil,
  width = nil,
  height = nil,
  offsetx = 0,
  offsety = 0,
}

function rect:iscolliding(other)
  if not (other.x or other.y or other.height or other.width) then
    return false
  end
  if self.x + self.width >= other.x and other.x + other.width >= self.x then
    if self.y <= other.y + other.height and self.y + self.height >= other.y then
      return true
    end
  end
  return false
end

function rect:shrinkh(n)
  self.x = self.x + n
  self.width = self.width - 2 * n
  self.offsetx = self.offsetx + n
end

function rect:shrinkv(n)
  self.y = self.y + n
  self.height = self.height - 2 * n
  self.offsety = self.offsety + n
end

function rect:shrink(n)
  self:shrinkh(n)
  self:shrinkv(n)
end