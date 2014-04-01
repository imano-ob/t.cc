
pressedthisframe = {}

local i = 0

function iscolliding(this, that)
  if not (this.x or this.y or this.height or this.width or
          that.x or that.y or that.height or that.width) then
    print ("what"..i)
    i = i + 1
    return false
  end
  if this.x + this.width >= that.x and that.x + that.width >= this.x and
    this.y <= that.y + that.height and this.y + this.height >= that.y then
    --print ("collision!" .. i)
    --i = i + 1
    return true
  end
  return false
end