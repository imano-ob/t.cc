
require "lux.object"

require "block"
require "enemy"
require "spike"


stage = lux.object.new {
  blocks = {},
  enemies = {},
  start = {
    x = nil,
    y = nil,
  }
}

function stage:__construct()
table.insert( 
              self.blocks,
              block:new{
                x = 200,
                y = 50,
                height = 50,
                width = 200,
              }
            )

table.insert( 
              self.blocks,
              block:new{
                x = 300,
                y = 130,
                height = 100,
                width = 10,
              }
            )

table.insert( 
              self.blocks,
              block:new{
                x = 350,
                y = 130,
                height = 100,
                width = 10,
              }
            )

table.insert( 
              self.enemies,
              spike:new{
                x = 330,
                y = 100,
              }
            )

self.start = {
  x = 300, y = 300,
}
end

function stage:draw()
  for _,v in pairs(self.blocks) do
    v:draw()
  end
  for _,v in pairs(self.enemies) do
    v:draw()
  end   
end