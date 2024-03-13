local entity = {}
entity.data = {}
entity.load = function()
end
entity.update = function()
end
entity.draw = function()
    love.graphics.circle("fill", entity.data.x, entity.data.y, 100)
end
return entity