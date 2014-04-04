
require "block"
require "stage"

function pregen(infot)
  local n = 5
  
  local x = 30
  local y = 300
  
  local xdiff = 20
  local ydiffup = 20
  local ydiffdown = 20
  
  local width = 50
  local height = 20
  
  local wvar = 20
  local hvar = 10
  
  local xvar = 30
  local yvar = 30
  
  if not stage then return end
  
  prebuild = {
    min = {
      horgap = nil,
      ydiffup = nil,
      ydiffdown = nil,
      height = nil,
      width = nil,
      doublexdiff = nil,
      doubleydiffup = nil,
      doubleydiffdown = nil,
    },  
    max = {     
      xdiff = nil,
      ydiffup = nil,
      ydiffdown = nil,
      height = nil,
      width = nil,
      doublexdiff = nil,
      doubleydiffup = nil,
      doubleydiffdown = nil,
    },
    blocks = {},
  }     
  if infot then
    x = infot.x or x
    y = infot.y or y
    width = infot.width or width
    height = infot.height or height
    n = infot.n or n
    xdiff = infot.xdiff or xdiff
    ydiffup = infot.ydiffup or ydiffup
    ydiffdown = infot.ydiffdown or ydiffdown
    wvar = infot.wvar or  wvar     
    hvar = infot.hvar or hvar     
    xvar = infot.xvar or xvar     
    yvar = infot.yvar or yvar     
  end
  for i=1,n do
    local h = math.abs(height + math.random(-hvar, hvar))
    local w = math.abs(width + math.random(-wvar, wvar))
    x = x + math.random(-xvar, xvar)
    y = y + math.random(-yvar, yvar)
    table.insert(
      prebuild.blocks,
      block:new{
        x = x,
        y = y,
        height = h,
        width = w,
      }
    )
    x = x + width + xdiff
    if math.random() >= 0.5 then
      y = y + (math.random()) * (height + ydiffup)
    else
      y = y - (math.random()) * (height + ydiffdown)
    end

    if i == 1 then
      prebuild.max.height, prebuild.max.width = h, w
      prebuild.min.height, prebuild.min.width = h, w
    else
      prebuild.max.height = prebuild.max.height > h and prebuild.max.height or h
      prebuild.max.width = prebuild.max.width > w and prebuild.max.width or w
      prebuild.min.height = prebuild.min.height < h and prebuild.min.height or h
      prebuild.min.width = prebuild.min.width < w and prebuild.min.width or w
      
      local horgap = prebuild.blocks[i].x - 
        (prebuild.blocks[i-1].x + 
         prebuild.blocks[i-1].width)
      if prebuild.max.xdiff then
        prebuild.max.xdiff = prebuild.max.xdiff > horgap and prebuild.max.xdiff or horgap
      else
        prebuild.max.xdiff = horgap
      end    
      if prebuild.min.xdiff then
        prebuild.min.xdiff = prebuild.min.xdiff < horgap and prebuild.min.xdiff or horgap
      else
        prebuild.min.xdiff = horgap
      end    
      
      local vertgap = prebuild.blocks[i].y +
        prebuild.blocks[i].height - 
        (prebuild.blocks[i-1].y + 
         prebuild.blocks[i-1].height)
      
      if vertgap > 0 then
        
        if prebuild.max.ydiffup then
          prebuild.max.ydiffup = prebuild.max.ydiffup > vertgap and prebuild.max.ydiffup or vertgap
        else
          prebuild.max.ydiffup = vertgap
        end    
        if prebuild.min.ydiffup then
          prebuild.min.ydiffup = prebuild.min.ydiffup < vertgap and prebuild.min.ydiffup or vertgap
        else
          prebuild.min.ydiffup = vertgap
        end    
      
      else
        vertgap = vertgap * -1

        if prebuild.max.ydiffdown then
          prebuild.max.ydiffdown = prebuild.max.ydiffdown > vertgap and prebuild.max.ydiffdown or vertgap
        else
          prebuild.max.ydiffdown = vertgap
        end    
        if prebuild.min.ydiffdown then
          prebuild.min.ydiffdown = prebuild.min.ydiffdown < vertgap and prebuild.min.ydiffdown or vertgap
        else
          prebuild.min.ydiffdown = vertgap
        end    

        
      end       
    end
    if i > 2 then
      
      local horgap = prebuild.blocks[i].x - 
        (prebuild.blocks[i-2].x + 
         prebuild.blocks[i-2].width)
      if prebuild.max.doublexdiff then
        prebuild.max.doublexdiff = prebuild.max.doublexdiff > horgap and prebuild.max.doublexdiff or horgap
      else
        prebuild.max.doublexdiff = horgap
      end    
      if prebuild.min.doublexdiff then
        prebuild.min.doublexdiff = prebuild.min.doublexdiff < horgap and prebuild.min.doublexdiff or horgap
      else
        prebuild.min.doublexdiff = horgap
      end    
      
      local vertgap = prebuild.blocks[i].y +
        prebuild.blocks[i].height - 
        (prebuild.blocks[i-2].y + 
         prebuild.blocks[i-2].height)
      
      if vertgap > 0 then
        
        if prebuild.max.doubleydiffup then
          prebuild.max.doubleydiffup = prebuild.max.doubleydiffup > vertgap and prebuild.max.doubleydiffup or vertgap
        else
          prebuild.max.doubleydiffup = vertgap
        end    
        if prebuild.min.doubleydiffup then
          prebuild.min.doubleydiffup = prebuild.min.doubleydiffup < vertgap and prebuild.min.doubleydiffup or vertgap
        else
          prebuild.min.doubleydiffup = vertgap
        end    
      
      else
        vertgap = vertgap * -1
        
        if prebuild.max.doubleydiffdown then
          prebuild.max.doubleydiffdown = prebuild.max.doubleydiffdown > vertgap and prebuild.max.doubleydiffdown or vertgap
        else
          prebuild.max.doubleydiffdown = vertgap
        end    
        if prebuild.min.doubleydiffdown then
          prebuild.min.doubleydiffdown = prebuild.min.doubleydiffdown < vertgap and prebuild.min.doubleydiffdown or vertgap
        else
          prebuild.min.doubleydiffdown = vertgap
        end    
      end
    end
  end
  if not prebuild.max.ydiffup then
    prebuild.max.ydiffup = 0
    prebuild.min.ydiffup = 0
  end   
  
  if not prebuild.max.ydiffdown then
    prebuild.max.ydiffdown = 0
    prebuild.min.ydiffdown = 0
  end   


  if not prebuild.max.doubleydiffup then
    prebuild.max.doubleydiffup = 0
    prebuild.min.doubleydiffup = 0
  end   

  if not prebuild.max.doubleydiffdown then
    prebuild.max.doubleydiffdown = 0
    prebuild.min.doubleydiffdown = 0
  end           
  return prebuild
end

function create(prebuild)
  local firstx
  local firsty
  firstx, firsty = prebuild.blocks[1].x, prebuild.blocks[1].y +
    prebuild.blocks[1].height
  stage.miny = prebuild.blocks[1].y

  for i = 1, #prebuild.blocks do
    table.insert(stage.blocks, prebuild.blocks[i])
    if prebuild.blocks[i].y < stage.miny then
      stage.miny = prebuild.blocks[i].y
    end 
  end   
  
  return firstx, firsty
end
