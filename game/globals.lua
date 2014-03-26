
pressedthisframe = {}

function iscolliding(this, that)
  if not (this.x or this.y or this.height or this.width or
          that.x or that.y or that.height or that.width) then
    return false
  end
  if this.x + this.width >= that.x and that.x + that.width >= this.x then
    if this.y <= that.y + that.height and this.y + this.height >= that.y then
      return true
    end
  end
  return false
end