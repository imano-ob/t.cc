
require "lux.object"

require "globals"

local minheight = 5
local minwidth = 5
--local diff = 5
local boxsize = 2

local wtf = true

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
  leftcolbox = nil,
  rightcolbox = nil,
  upcolbox = nil,
  downcolbox = nil,
}

function block:__construct ()
  if self.width < minwidth then
    self.width = minwidth
  end
  if self.height < minheight then
    self.height = minheight
  end
  self.leftcolbox = {
    x = self.x,
    y = self.y, -- + diff,
    width = boxsize,
    height = self.height -- 2 * diff
  }
  self.rightcolbox = {
    x = self.x + self.width - boxsize,
    y = self.y, -- + diff,
    width = boxsize,
    height = self.height --git st- 2 *diff
  }
  self.upcolbox = {
    x = self.x, -- + diff,
    y = self.y + self.height - boxsize,
    width = self.width, -- 2 * diff,
    height = boxsize
  }
  self.downcolbox = {
    x = self.x, -- + diff,
    y = self.y,
    width = self.width, -- 2 * diff,
    height = boxsize
  }
end     

function block:update(dt)

end

function block:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  if wtf then
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("fill", self.upcolbox.x, self.upcolbox.y, self.upcolbox.width, self.upcolbox.height)
    love.graphics.rectangle("fill", self.downcolbox.x, self.downcolbox.y, self.downcolbox.width, self.downcolbox.height)
    love.graphics.rectangle("fill", self.leftcolbox.x, self.leftcolbox.y, self.leftcolbox.width, self.leftcolbox.height)
    love.graphics.rectangle("fill", self.rightcolbox.x, self.rightcolbox.y, self.rightcolbox.width, self.rightcolbox.height)
  end   
end

function block:iscolliding(other)
  res = {hor = 0, vert = 0}
  if iscolliding(self.upcolbox, other) then
    res.vert = 1
  elseif iscolliding(self.downcolbox, other) then
    res.vert = -1
  end
  if iscolliding(self.leftcolbox, other) then
    res.hor = -1
  elseif iscolliding(self.rightcolbox, other) then
    res.hor = 1
  end   
  return res
end

blocks = {}

