
require "lux.object"

require "globals"

require "block"
require "stage"

guy = lux.object.new{
  speed = 100,
  runspeed = 200,
  jumppower = 300,
  grav = 10,

  maxvertspeed = 500,

  height = 10,
  width = 10,
  
  image = nil, -- meh
  color = {
    255,
    255,
    255,
  },

  x = 0,
  y = 0,
  curxspd = 0,
  curyspd = 0
}

function guy:update (dt)
  
  local dir = self:dir()

  --Horizontal movement

  if self:isrunning() then
    self.curxspd = dir * self.runspeed
  else	
    self.curxspd = dir * self.speed
  end

  self.x = self.x + self.curxspd * dt

  --jumping

  if self:tryjump() and self:canjump() then
    self.curyspd = self.jumppower
  end

  --vertical movement

  self.curyspd = self.curyspd - self.grav
  
  if math.abs(self.curyspd) > self.maxvertspeed then
    if self.curyspd < 0 then
      self.curyspd = -self.maxvertspeed
    else	
      self.curyspd = self.maxvertspeed
    end	
  end	

  self.y = self.y + self.curyspd * dt

  if self.y < -20 then 
    self.y = love.graphics.getHeight() 
    --self.curyspd = 0
  end

  for _, v in pairs(stage.blocks) do
    if iscolliding(self, v) then
      if self.y > v.y then
        self.y = v.y + v.height
      else
        self.y = v.y - self.height
      end
      self.curyspd = 0
    end
  end
end

function guy:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle ("fill", self.x, self.y, self.width, self.height )
end

function guy:dir()
  if love.keyboard.isDown("left") then
    return -1
  elseif love.keyboard.isDown("right") then
    return 1
  else
    return 0
  end
end

function guy:isrunning()
  return love.keyboard.isDown("lshift")
end

function guy:tryjump()
  return pressedthisframe[" "]
end

function guy:canjump()
  for _, v in pairs(stage.blocks) do
    if iscolliding(self, v) and self.y > v.y then
      return true
    end
  end
  return false
  --return self.y <= 0
end