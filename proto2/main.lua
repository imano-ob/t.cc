
require "globals"

require "guy"
require "block"

function love.load()
table.insert( 
              blocks,
              block:new{
                x = 200,
                y = 50,
                height = 50,
                width = 200,
              }
            )

table.insert( 
              blocks,
              block:new{
                x = 300,
                y = 130,
                height = 100,
                width = 10,
              }
            )

table.insert( 
              blocks,
              block:new{
                x = 350,
                y = 130,
                height = 100,
                width = 10,
              }
            )

end

function love.update (dt)
  guy:update(dt)
  pressedthisframe = {}
end

function love.draw ()
  love.graphics.push()
  love.graphics.translate (0, love.graphics.getHeight() - 20)
  love.graphics.scale (1, -1)
  for _,v in pairs(blocks) do
    v:draw()
  end
  guy:draw()
  love.graphics.pop()
end

function love.keypressed(key)
  pressedthisframe[key] = true
end

function love.keyreleased(key)

end