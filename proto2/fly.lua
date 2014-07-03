
require "lux.object"

require "enemy"
require "rect"

fly = enemy:new{
  
  state = "stopped",
  timeinstate = 0,
  timemoving = 1,
  timestopped = 2,

  speed = 100,

  x = nil,
  y = nil,
  width = 15,
  height = 15,

  dirx = nil,
  diry = nil,
}

function fly:__construct()
  self.hitbox = rect:new{
    x = self.x,
    y = self.y,
    width = self.width,
    height = self.height,
  }
  self.hitbox:shrink(2)
end

function fly:update(dt, st)

  self.timeinstate = self.timeinstate + dt

  if self.state == "moving" then
--    print("a")
    self.x = self.x + self.dirx * dt * self.speed
    self.y = self.y + self.diry * dt * self.speed
    self.hitbox.x = self.x + self.hitbox.offsetx
    self.hitbox.y = self.y + self.hitbox.offsety


    if self.timeinstate >= self.timemoving then
      self.state = "stopped"
      self.timeinstate = 0
    end 

  else     
    self.timeinstate = self.timeinstate + dt
--    print(self.timeinstate)
    if self.timeinstate >= self.timestopped then

--      print("durr")

      local targetx = guy.x - self.x
      local targety = guy.y - self.y
      self.dirx = targetx / math.pow(targetx * targetx + targety * targety, 0.5)
      self.diry = targety / math.pow(targetx * targetx + targety * targety, 0.5)

      self.state = "moving"
      self.timeinstate = 0

    end 
  end
end

function fly:draw()
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function fly:iscolliding(other)
  return self.hitbox:iscolliding(other)
end