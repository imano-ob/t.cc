
require "torch"
require "nn"

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

dataset = {}

function dataset:size()
  return #self
end

--hardcoded stuffs

local min = {
  n = 2,
  
  x = 0,
  y = 0,
  
  xdiff = 0,
  ydiff = 0,
  
  width = 20,
  height = 10,
  
  wvar = 0,
  hvar = 0,

  xvar = 0,
  yvar = 0,
}

local max = {
  n = 50,
  
  x = 500,
  y = 500,
  
  xdiff = 100,
  ydiff = 200,
  
  width = 100,
  height = 50,
  
  wvar = 100,
  hvar = 50,

  xvar = 50,
  yvar = 50,
}

local tries = 30
local expch = 0.05

--ML stuff
--Shamelessly C&P'd from tutorial

--TODO: figure out what numbers mean
--TODO: figure out o que tudo mean
mlp = nn.Sequential()
mlp:add( nn.Linear(11, 25) ) -- not 10 input, 25 hidden units
mlp:add( nn.Tanh() ) -- some hyperbolic tangent transfer function
mlp:add( nn.Linear(25, 1) ) -- not 1 output

criterion = nn.MSECriterion() --not Mean Squared Error criterion
trainer = nn.StochasticGradient(mlp, criterion)  
-- trainer:train(dataset) -- train using some examples
--End ML

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
    newt = torch.Tensor(11)
    local i = 1
    for _,v in pairs(info) do
      newt[i] = v  
    end
    rest = torch.Tensor(1)
    rest[1] = stage.deaths
    table.insert(dataset, {newt, rest})
    if dataset:size() >= 2 then
      print(dataset[2][1])
      trainer:train(dataset)
      for i = 1,tries do
        local willexp = math.random() <= expch
        local j = 1
        anothert = torch.Tensor(11)
        for k,_ in pairs(info) do
          info[k] = math.random(min[k], max[k])
          anothert[j] = info[k]
          j = j+1
        end
        predict = mlp:forward(anothert)
        if willexp or predict[1]>= 2 and predict[1] <= 3.5 then break end
        
      end
      print(predict[1])
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