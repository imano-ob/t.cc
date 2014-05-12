
require "lux.object"

require "globals"

require "block"

guy = lux.object.new{
  speed = 100,
  runspeed = 200,
  jumppower = 500,
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

function guy:update(dt)
  
  local dir = self:dir()

  --Horizontal movement

  self.prevx = self.x
  self.prevy = self.y

  if self:isrunning() then
    self.curxspd = dir * self.runspeed
  else	
    self.curxspd = dir * self.speed
  end

  self.x = self.x + self.curxspd * dt

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

--collision detection

  for _, v in pairs(blocks) do
    colst = v:iscolliding(self)
    self.ground = false
    if colst then
      if colst.vert > 0 and self.prevy >= v.y + v.height then
        print ("prevy " .. self.prevy)
        print ("block " .. v.y + v.height)
        self.curyspd = 0
        self.y = v.height + v.y
        self.ground = true
        self.airjump = true
      elseif colst.vert < 0 and self.prevy + self.height <= v.y then
        self.curyspd = 0
        self.y = v.y - self.height
      end       

      self.wall = true

      if colst.hor > 0 and self.prevx >= v.x + v.width then
        self.curxspd = 0
        self.x = v.width + v.x
      elseif colst.hor < 0 and self.prevx + self.width <= v.x then
        self.curxspd = 0
        self.x = v.x - self.width
      else
        self.wall = false
      end
    else
      self.air = true
    end

  end

  --jumping

  if self:tryjump() then
    if self.ground or self.airjump then
      self.curyspd = self.jumppower
      if not self.ground then 
        self.airjump = false
      end
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
  for _, v in pairs(blocks) do
    if self.x + self.width >= v.x and v.x + v.width >= self.x and
      self.y <= v.y + v.height and self.y + self.height >= v.y and
      self.y > v.y then
      return true
    end
  end
  return false
  --return self.y <= 0
end