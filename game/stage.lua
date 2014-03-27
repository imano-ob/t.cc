
require "globals"

stage = {
  blocks = {},
  tries = 5,
  clear = false,
  deaths = 0,
  xbegin = nil,
  ybegin = nil,
}

function stage:reset()
  self.deaths = 0
  self.clear = false
  self.blocks = {}
end     

function stage:update(dt)

end

function stage:done()
  return self.clear or self.deaths >= self.tries
end

function stage:success()
  return self.deaths < self.tries
end

function stage:draw()
  for _,v in pairs(self.blocks) do
    v:draw()
  end
end