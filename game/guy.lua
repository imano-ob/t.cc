
require "lux.object"

require "globals"

guy = lux.object.new{
  speed = 100,
  runspeed = 200,
  jumppower = 500,
  grav = 10,

  maxvertspeed = 500,

  height = 10,
  width = 10,
  
  image = nil, -- meh

  x = 0,
  y = 0,
  curxspd = 0,
  curyspd = 0
}

function guy:update(dt)
  
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

  if self.y > 0 then
    self.curyspd = self.curyspd - self.grav
  end

  if math.abs(self.curyspd) > self.maxvertspeed then
    if self.curyspd < 0 then
      self.curyspd = -self.maxvertspeed
    else	
      self.curyspd = self.maxvertspeed
    end	
  end	

  self.y = self.y + self.curyspd * dt

  if self.y < 0 then self.y = 0 end

end

function guy:draw()
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
  return self.y <= 0
end