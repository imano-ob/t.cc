
require "lux.object"

require "block"

stage = lux.object.new {
  blocks = {},
  enemies = {},
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
end