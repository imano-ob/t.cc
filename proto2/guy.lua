
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

  groundfriction = 0.3,
  rungroundfriction = 0.1,
  airfriction = 0.05,

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


function guy:update(st, dt)
  
  local prevx = self.x
  local prevy = self.y

  self:horizontalupdate(dt)
  self:verticalupdate(dt)

  if self.y < -20 then 
    self:die(st)
  end

  self:blockcollision(st, prevx, prevy)

  for _, v in pairs(st.enemies) do
    if v:iscolliding(self) then
      self:die(st)
    end    
  end   
  
  self:jump()

end



function guy:horizontalupdate(dt)

  local xacc
  local xfriction
  local maxspd

  local dir = self:dir()

  if self:isrunning() then
    maxspd = self.runspeed
    if self.ground then
      xacc = self.runaccel
      xfriction = self.rungroundfriction
    else        
      xacc = self.runairaccel
      xfriction = self.airfriction
    end 
  else
    maxspd = self.speed
    if self.ground then
      xacc = self.groundaccel
      xfriction = self.groundfriction      
    else
      xacc = self.airaccel
      xfriction = self.airfriction
    end
  end   

  xacc = dir * xacc
  xacc = xacc + xfriction * -self.curxspd

  self.curxspd = self.curxspd + xacc

  if math.abs(self.curxspd) > maxspd then
    if self.curxspd < 0 then
      self.curxspd = -maxspd
    else	
      self.curxspd = maxspd
    end	
  end
  self.x = self.x + self.curxspd * dt
end



function guy:verticalupdate(dt)
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
end



function guy:blockcollision(st, prevx, prevy)
  self.ground = false
  self.wall = false

  for _, v in pairs(st.blocks) do
    collisioninfo = v:iscolliding(self)
    if collisioninfo then
      if collisioninfo.vert > 0 and prevy >= v.y + v.height then
        self.curyspd = 0
        self.y = v.height + v.y
        self.ground = true
        self.airjump = true
      elseif collisioninfo.vert < 0 and prevy + self.height <= v.y then
        self.curyspd = 0
        self.y = v.y - self.height
      end            

      if collisioninfo.hor > 0 and prevx >= v.x + v.width then
        self.curxspd = 0
        self.x = v.width + v.x
        self.wall = 1
        self.airjump = true

      elseif collisioninfo.hor < 0 and prevx + self.width <= v.x then
        self.curxspd = 0
        self.x = v.x - self.width
        self.wall = -1
        self.airjump = true

      end
    end
  end
end



function guy:jump()
  local walljumpimpulse = 2

  if self:tryjump() then
    if self.ground then
      self.curyspd = self.jumppower
    elseif self.wall then
      self.curyspd = self.walljumppower
      self.curxspd = self.walljumppower * walljumpimpulse * self.wall
    elseif self.airjump then
      self.curyspd = self.airjumppower
      self.airjump = false
    end 
  end  
end

--End update

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

function guy:reset(st)
  self.x, self.y = st.start.x, st.start.y
  self.curyspd, self.curxspd = 0, 0
  self.airjump = true
end

function guy:die(st)
--  print("ohnoes")
  self:reset(st)
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