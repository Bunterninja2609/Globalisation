function love.load()
    WorldSpace = love.physics.newWorld(0, 0)
    love.physics.setMeter(10)
    WorldStatus = "Map"
    player = {}
    player.body = love.physics.newBody(WorldSpace, 0, 0, "dynamic")
    player.shape = love.physics.newCircleShape(10)
    player.fixture = love.physics.newFixture(player.body, player.shape)
end
function love.update()
    if WorldStatus = "Map" then 

    elseif WorldStatus = "InLevel" then

    elseif WorldStatus = "BossFight" then

    end
end
function love.draw()
    
end