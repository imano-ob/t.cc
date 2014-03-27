
require "globals"

require "guy"
require "block"
require "stage"
require "gen"

--seed
math.randomseed(os.time())

--waste RNs for great entropy
math.random()
math.random()

info = {
  n = 5,
  
  x = 30,
  y = 300,
  
  xdiff = 20,
  ydiff = 20,
  
  width = 50,
  height = 20,
  
  wvar = 20,
  hvar = 10,

  xvar = 30,
  yvar = 30,
}

local x
local y

local function setup()
    stage:reset()
    x, y = create(info)
    guy.x, guy.y = x,y
    stage.xbegin, stage.ybegin = x, y
end

function love.load()
  setup()
end


function love.update (dt)
  if stage:done() then
    setup()
  end   
  guy:update(dt)
  stage:update(dt)
  pressedthisframe = {}
end

function love.draw ()
  love.graphics.push()
  love.graphics.translate (0, love.graphics.getHeight() - 20)
  love.graphics.scale (1, -1)
  stage:draw()
  guy:draw()
  love.graphics.pop()
end

function love.keypressed(key)
  pressedthisframe[key] = true
  if key == "p" then
    setup()
  end
end

function love.keyreleased(key)

end