function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setNewFont(20)
    WorldSpace = love.physics.newWorld(0, 0)
    Scale = 5
    love.physics.setMeter(1)
    WorldStatus = "Map"
    ShowHitboxes = true
    WorldMap = love.graphics.newImage("textures/world.png")
    player = {}
    player.isWasdSteering = true
    player.body = love.physics.newBody(WorldSpace, 0, 0, "dynamic")
    player.shape = love.physics.newCircleShape(8)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.direction = 0
    player.directionStrength = 0
    player.health = 100
    joysticks = love.joystick.getJoysticks()
    joystick1X, joystick1Y, joystick2X, joystick2Y = 0, 0, 0, 0

    entities = {}
    UI = {}
    spawnEntity("door",0,0, "up")
end 
function love.update(dt)
    if #joysticks >= 1 then
        joystick1X, joystick1Y, joystick2X, joystick2Y = joysticks[1]:getAxes()
    end
    if WorldStatus == "Map" then 
        
    elseif WorldStatus == "InLevel" then
        if love.keyboard.isDown("space") then
            spawnEntity("wizard", math.random(-100, 100), math.random(-100, 100), "")
  end
        updateEntities(dt)
        steer(player.body, 200, player.isWasdSteering)
        WorldSpace:update(dt)
        
    elseif WorldStatus == "BossFight" then


    end
    
end
function love.draw()
    if WorldStatus == "Map" then 
        love.window.setMode(WorldMap:getWidth()*5, WorldMap:getHeight()*5)
        love.graphics.setBackgroundColor(0, 1, 0)
        love.graphics.draw(WorldMap, 0, 0, 0, 5)
    elseif WorldStatus == "InLevel" then
        love.graphics.setBackgroundColor(0, 0.5, 1)
        love.graphics.push()
            love.graphics.scale(Scale)
            love.graphics.translate(-player.body:getX() + love.graphics.getWidth()/(Scale*2), -player.body:getY() + love.graphics.getHeight()/(Scale*2))
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", player.body:getX(), player.body:getY(), 8)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", player.body:getX() + 20 * math.cos(player.direction) * player.directionStrength, player.body:getY()  + 20 * math.sin(player.direction) * player.directionStrength, 2)
            drawHitboxes(WorldSpace)
            drawEntities()
        love.graphics.pop()
    elseif WorldStatus == "BossFight" then
        love.graphics.setBackgroundColor(1, 0.5, 0)
    end
    drawUi(1)
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
        player.directionStrength = math.sqrt((math.floor(joystick2Y*10)/10)^2 + (math.floor(joystick2X*10)/10)^2)
        object:setLinearVelocity(math.floor(joystick1X*10)/10 * speed, math.floor(joystick1Y*10)/10 * speed)
    end
end

function spawnEntity(type, x, y, ...)
    local entityPrefab = require("entities/".. type)  -- Load the entity module
    local entity = {}                   -- Create a new table for the entity instance
    for key, value in pairs(entityPrefab) do
        entity[key] = value             -- Copy methods from the entity module to the instance
    end
    entity.x = x or entity.x
    entity.y = y or entity.y
    entity:load(...)                       -- Initialize the entity
    table.insert(entities, entity)      -- Insert the new entity into the entities table
end
function drawEntities()
    table.sort(entities, function (a, b) return a.z < b.z end)
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

function drawHitboxes(world)
    if ShowHitboxes then
        love.graphics.setColor(1,1,1,0.5)
        -- Iterate through all bodies in the physics world
        for _, body in pairs(world:getBodies()) do
            -- Iterate through all fixtures of the body
            for _, fixture in pairs(body:getFixtures()) do
                -- Get the shape type of the fixture
                local shapeType = fixture:getShape():getType()

                -- Draw hitbox based on shape type
                if shapeType == "circle" then
                    local x, y = body:getWorldPoint(fixture:getShape():getPoint())
                    local radius = fixture:getShape():getRadius()
                    love.graphics.circle("line", x, y, radius)
                elseif shapeType == "polygon" then
                    local vertices = {body:getWorldPoints(fixture:getShape():getPoints())}
                    love.graphics.polygon("line", vertices)
                elseif shapeType == "edge" then
                    local x1, y1, x2, y2 = body:getWorldPoints(fixture:getShape():getPoints())
                    love.graphics.line(x1, y1, x2, y2)
                elseif shapeType == "chain" then
                    local points = {body:getWorldPoints(fixture:getShape():getPoints())}
                    love.graphics.line(points)
                end
            end
        end
    end
end

function addUi(text, x, y, height, width)
    local ui = {
        x = x or 0,
        y =  y or 0,
        width = width or 400,
        height = height or 150,
        text = text
    }
    table.insert(UI, ui)
end
function drawUi(buffer)
    if buffer > #UI then
        buffer = #UI
    end
    for i = 1, buffer do
        local ui = UI[i]
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.rectangle("fill", ui.x, ui.y, ui.width, ui.height)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", ui.x + Scale, ui.y + Scale, ui.width - Scale*2, ui.height - Scale*2)
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.rectangle("fill", ui.x + Scale*2, ui.y + Scale*2, ui.width - Scale*4, ui.height - Scale*4)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(ui.text, ui.x + Scale*2, ui.y + Scale*2, ui.width - Scale*4)
    end
    UI = {}
end

function newTextureSheet(image,width,height,xDensity,yDensity)
    local textureSheet = {}
    for i = 1, yDensity do
        textureSheet[i] = {}
        for j = 1, xDensity do
            textureSheet[i][j] = love.graphics.newQuad(0 + (j-1) * width, 0 + (i-1) * height, width, height, image)
        end
    end
    return textureSheet
end

function getDirection(x1, y1, x2, y2)
    return math.atan2(x2 - x1, y2 - y1) - 1/2 * math.pi
end