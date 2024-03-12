function love.load()
    WorldSpace = love.physics.newWorld(0, 0)
    love.physics.setMeter(1)
    WorldStatus = "BossFight"
    player = {}
    player.body = love.physics.newBody(WorldSpace, love.graphics:getWidth()/2, love.graphics:getHeight()/2, "dynamic")
    player.shape = love.physics.newCircleShape(10)
    player.fixture = love.physics.newFixture(player.body, player.shape)
end
function love.update(dt)
    if WorldStatus == "Map" then 
        
    elseif WorldStatus == "InLevel" then
        WASD(player.body, 200)
        
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
            love.graphics.circle("fill", player.body:getX(), player.body:getY(), 10)
        love.graphics.pop()
    elseif WorldStatus == "BossFight" then
        love.graphics.setBackgroundColor(1, 0.5, 0)
        function love.draw()
            local joysticks = love.joystick.getJoysticks()
            for i, joystick in ipairs(joysticks) do
                love.graphics.print(joystick:getName(), 10, i * 20)
            end
        end
    end
end
function WASD(object, speed)
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
end