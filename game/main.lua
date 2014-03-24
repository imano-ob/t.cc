
require "globals"

require "guy"

function love.load()

end

function love.update (dt)
  guy:update(dt)
  pressedthisframe = {}
end

function love.draw ()
  love.graphics.translate (0, love.graphics.getHeight() - 20)
  love.graphics.scale (1, -1)
  guy:draw()
end

function love.keypressed(key)
  pressedthisframe[key] = true
  --if key == ' ' then
  --  guy.jump = true
  --end
end

function love.keyreleased(key)

end