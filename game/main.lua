
require "globals"

require "guy"
require "block"
require "gen"

--seed
math.randomseed(os.time())

--waste RNs for great entropy
math.random()
math.random()

function love.load()
  local x 
  local y
  x, y = create()
  guy.x, guy.y = x, y
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
  if key == "p" then
    blocks = {}
    local x
    local y
    x,y  = create()
    guy.x, guy.y = x, y
  end
end

function love.keyreleased(key)

end