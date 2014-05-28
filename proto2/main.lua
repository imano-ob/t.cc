
require "globals"

require "guy"
require "block"
require "stage"

function love.load()
  st = stage:new{}
end

function love.update (dt)
  guy:update(st, dt)
  pressedthisframe = {}
end

function love.draw ()
  love.graphics.push()
  love.graphics.translate (0, love.graphics.getHeight() - 20)
  love.graphics.scale (1, -1)
  for _,v in pairs(st.blocks) do
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