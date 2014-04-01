
require "globals"

stage = {
  blocks = {},
  --tries = 3,
  clear = false,
  deaths = 0,
  xbegin = nil,
  ybegin = nil,
  miny = nil,
}

function stage:reset()
  self.deaths = 0
  self.clear = false
  self.blocks = {}
end     

function stage:update(dt)

end

function stage:done()
  return self.clear --or self.deaths >= self.tries
end

--[[
function stage:success()
  return self.deaths < self.tries
end
]]

function stage:draw()
  local color = {255, 0, 0}
  for i,v in pairs(self.blocks) do
    if i == #self.blocks then
      color = {0, 255, 0}
    end 
    v:draw(color)
  end
end