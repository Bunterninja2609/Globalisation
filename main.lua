function love.load()
    WorldSpace = love.physics.newWorld(0, 0)
    love.physics.setMeter(1)
    WorldStatus = "InLevel"
    player = {}
    player.isWasdSteering = true
    player.body = love.physics.newBody(WorldSpace, love.graphics:getWidth()/2, love.graphics:getHeight()/2, "dynamic")
    player.shape = love.physics.newCircleShape(10)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.direction = 0
    player.directionStrength = 0
    joysticks = love.joystick.getJoysticks()
    joystick1X, joystick1Y, joystick2X, joystick2Y = 0, 0, 0, 0

    entities = {}
    
end 
function love.update(dt)
    if #joysticks >= 1 then
        joystick1X, joystick1Y, joystick2X, joystick2Y = joysticks[1]:getAxes()
    end
    if WorldStatus == "Map" then 
        
    elseif WorldStatus == "InLevel" then
        if love.keyboard.isDown("space") then
            spawnEntity("enemy1", 0, 0)
        end
        updateEntities(dt)
        steer(player.body, 200, player.isWasdSteering)
        
    elseif WorldStatus == "BossFight" then

    end
    WorldSpace:update(dt)
end
function love.draw()
    if WorldStatus == "Map" then 
        love.graphics.setBackgroundColor(0, 1, 0)
    elseif WorldStatus == "InLevel" then
        love.graphics.setBackgroundColor(0, 0.5, 1)
        love.graphics.push()
            love.graphics.translate(-player.body:getX() + love.graphics:getWidth()/2, -player.body:getY() + love.graphics:getHeight()/2)
            drawEntities()
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", player.body:getX(), player.body:getY(), 10)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", player.body:getX() + 20 * math.cos(player.direction) * player.directionStrength, player.body:getY()  + 20 * math.sin(player.direction) * player.directionStrength, 3)
        love.graphics.pop()
    elseif WorldStatus == "BossFight" then
        love.graphics.setBackgroundColor(1, 0.5, 0)
    end
end
function steer(object, speed, wasd)
    if wasd then
        local velocityX, velocityY = 0, 0
        if love.keyboard.isDown("w") then
            velocityY = velocityY - 1
        end
        if love.keyboard.isDown("s") then
            velocityY = velocityY + 1
        end
        if love.keyboard.isDown("d") then
            velocityX = velocityX + 1
        end
        if love.keyboard.isDown("a") then
            velocityX = velocityX - 1
        end
            object:setLinearVelocity(velocityX * speed, velocityY * speed)
    else
        player.direction = math.atan2(math.floor(joystick2Y*10)/10 ,math.floor(joystick2X*10)/10)
        player.directionStrength = math.sqrt(joystick2Y^2 + joystick2X^2)
        object:setLinearVelocity(math.floor(joystick1X*10)/10 * speed, math.floor(joystick1Y*10)/10 * speed)
    end
end

function spawnEntity(type, x, y)
    local entityPrefab = require("entities/".. type)  -- Load the entity module
    local entity = {}                   -- Create a new table for the entity instance
    for key, value in pairs(entityPrefab) do
        entity[key] = value             -- Copy methods from the entity module to the instance
    end
    entity.x = x or entity.x
    entity.y = y or entity.y
    entity:load()                       -- Initialize the entity
    table.insert(entities, entity)      -- Insert the new entity into the entities table
end
function drawEntities()
    for _, entity in ipairs(entities) do
        
        entity:draw()
    end
end
function updateEntities(dt)
    for _, entity in ipairs(entities) do
        entity:update(dt)
    end
end

function love.keypressed(key)
    if key == "1" then
        WorldStatus = "Map"
    elseif key == "2" then
        WorldStatus = "InLevel"
    elseif key == "3" then
        WorldStatus = "BossFight"
    end
end