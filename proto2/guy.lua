
require "lux.object"

require "globals"

require "block"

guy = lux.object.new{
  speed = 100,
  runspeed = 200,
  
  groundaccel = 20,
  runaccel = 50,
  airaccel = 15,
  runairaccel = 30,

  groundtraction = 0.3,
  rungroundtraction = 0.1,
  airtraction = 0.05,

  jumppower = 200,
  airjumppower = 150,
  walljumppower = 200,
  
  grav = 10,
  maxvertspeed = 500,

  wallgrav = 3,
  maxwallspeed = 100,

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

  local xacc
  local xtract
  local maxspd

  if self:isrunning() then
    maxspd = self.runspeed
    if self.ground then
      xacc = self.runaccel
      xtract = self.rungroundtraction
    else        
      xacc = self.runairaccel
      xtract = self.airtraction
    end 
  else
    maxspd = self.speed
    if self.ground then
      xacc = self.groundaccel
      xtract = self.groundtraction      
    else
      xacc = self.airaccel
      xtract = self.airtraction
    end
  end   

  xacc = dir * xacc
  xacc = xacc + xtract * -self.curxspd

  self.curxspd = self.curxspd + xacc

  if math.abs(self.curxspd) > maxspd then
    if self.curxspd < 0 then
      self.curxspd = -maxspd
    else	
      self.curxspd = maxspd
    end	
  end

  if dir == 0 then
    
  end   

  self.x = self.x + self.curxspd * dt

  --vertical movement
  
  local maxyspd
  local yacc

  if self.wall then
    maxyspd = self.maxwallspeed
    yacc = self.wallgrav
  else  
    maxyspd = self.maxvertspeed
    yacc = self.grav
  end   

  self.curyspd = self.curyspd - yacc
  if math.abs(self.curyspd) > maxyspd then
    if self.curyspd < 0 then
      self.curyspd = -maxyspd
    else	
      self.curyspd = maxyspd
    end	
  end	

  self.y = self.y + self.curyspd * dt

  if self.y < -20 then 
    self.y = love.graphics.getHeight() 
    --self.curyspd = 0
  end

--collision detection
  self.ground = false
  self.wall = false

  for _, v in pairs(blocks) do
    colst = v:iscolliding(self)
    if colst then
      if colst.vert > 0 and self.prevy >= v.y + v.height then
        self.curyspd = 0
        self.y = v.height + v.y
        self.ground = true
        self.airjump = true
      elseif colst.vert < 0 and self.prevy + self.height <= v.y then
        self.curyspd = 0
        self.y = v.y - self.height
      end            


      if colst.hor > 0 and self.prevx >= v.x + v.width then
        self.curxspd = 0
        self.x = v.width + v.x
        self.wall = 1
        self.airjump = true

      elseif colst.hor < 0 and self.prevx + self.width <= v.x then
        self.curxspd = 0
        self.x = v.x - self.width
        self.wall = -1
        self.airjump = true

      end
    end

  end

  --jumping

  if self:tryjump() then
    if self.ground then
      self.curyspd = self.jumppower
    elseif self.wall then
      self.curyspd = self.walljumppower
      self.curxspd = self.walljumppower * 2 * self.wall
    elseif self.airjump then
      self.curyspd = self.airjumppower
      self.airjump = false
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