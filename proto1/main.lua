
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
  
  xdiff = 100,
  ydiffup = 50,
  ydiffdown = 50,
  
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
  ydiffup = 0,
  ydiffdown = 0,
  
  width = 20,
  height = 10,
  
  wvar = 0,
  hvar = 0,

  xvar = 0,
  yvar = 0,
}

local max = {
  n = 30,
  
  x = 500,
  y = 500,
  
  xdiff = 250,
  ydiffup = 200,
  ydiffdown = love.graphics.getHeight()/2 - 20,
  
  width = 100,
  height = 50,
  
  wvar = 100,
  hvar = 50,

  xvar = 50,
  yvar = 50,
}

local infos = 0

for _,_ in pairs(info) do
  infos = infos+1
end


local tries = 30
local expch = 0.05

--ML stuff
--Shamelessly C&P'd from tutorial

--TODO: figure out what numbers mean
--TODO: figure out o que tudo mean
mlp = nn.Sequential()
mlp:add( nn.Linear(infos, 25) ) -- not 10 input, 25 hidden units
mlp:add( nn.Tanh() ) -- some hyperbolic tangent transfer function
mlp:add( nn.Linear(25, 25) ) -- not 1 output
mlp:add( nn.Linear(25, 2) ) --?

criterion = nn.MSECriterion() --not Mean Squared Error criterion
trainer = nn.StochasticGradient(mlp, criterion)  
-- trainer:train(dataset) -- train using some examples
--End ML

local function setup()
    stage:reset()
    x, y = create(info)
    guy.x, guy.y = x,y
    guy.curyspd, guy.curxspd = 0, 0
    stage.xbegin, stage.ybegin = x, y
end

local function cleanup()
  newt = torch.Tensor(infos)
  local i = 1
  for k,v in pairs(info) do
    newt[i] = (v-min[k])/(max[k] - min[k])
  end
  rest = torch.Tensor(2)
  rest[1] = stage:done() and math.min(stage.deaths/10, 1) or 1
  rest[2] = stage:done() and 0 or 1
  table.insert(dataset, {newt, rest})
  if dataset:size() >= 5 then
    trainer:train(dataset)
    for i = 1,tries do
      local willexp = math.random() <= expch
      local j = 1
      anothert = torch.Tensor(infos)
      for k,_ in pairs(info) do
        anothert[j] = math.random()
        info[k] = min[k] + anothert[j] * (max[k] - min[k]) 
        j = j+1
      end
      predict = mlp:forward(anothert)
      if willexp or (predict[1]>= 0.1 and predict[1] <= 0.3 and predict[2] <= 0.3) then
        if willexp then print ("lets try something new") end
        print (i)
        break
      end
      
    end
    print(predict[1] .. " " .. predict[2])
  else 
    if stage:done() then
      info.n = info.n+1
      info.xdiff = info.xdiff * 1.2
      info.ydiffup = info.ydiffup * 1.2
      info.ydiffdown = info.ydiffdown * 1.2
      info.width = info.width * 0.8
    else
      info.n = math.max(2, info.n-1)
      info.xdiff = info.xdiff * 0.8
      info.ydiffup = info.ydiffup * 0.8
      info.ydiffdown = info.ydiffdown * 0.8
      info.width = info.width * 1.2
    end
    for k,v in pairs(info) do
      if info[k] >= max[k] then
        print(k .. "above max ".. max[k])
      end       
    end 
  end
end

function love.load()
  setup()
end


function love.update (dt)
  if stage:done() then
    cleanup()
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
 --[[
  for i = 1, (stage.tries - stage.deaths) do
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", love.graphics.getWidth() - 20 * i, 20, 10, 50)
  end

]]   
end

function love.keypressed(key)
  pressedthisframe[key] = true
  if key == "p" then
    cleanup()
    setup()
  end
end

function love.keyreleased(key)

end