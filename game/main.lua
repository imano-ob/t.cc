
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
    if stage:success() then
      info.n = info.n+1
      info.xdiff = info.xdiff * 1.1
      info.ydiff = info.ydiff * 1.1
      info.width = info.width * 0.9
    else
      info.n = math.max(2, info.n-1)
      info.xdiff = info.xdiff * 0.9
      info.ydiff = info.ydiff * 0.9
      info.width = info.width * 1.1
    end
    setup()
  end   
  guy:update(dt)
  stage:update(dt)
  pressedthisframe = {}
end

function love.draw ()
  love.graphics.push()
  love.graphics.translate (love.graphics.getWidth()/2 -guy.x, love.graphics.getHeight()/2 + guy.y)
  love.graphics.scale (1, -1)
  stage:draw()
  guy:draw()
  love.graphics.pop()
  for i = 1, (stage.tries - stage.deaths) do
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", love.graphics.getWidth() - 20 * i, 20, 10, 50)
  end   
end

function love.keypressed(key)
  pressedthisframe[key] = true
  if key == "p" then
    setup()
  end
end

function love.keyreleased(key)

end