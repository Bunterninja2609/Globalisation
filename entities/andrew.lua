local entity = {}
entity.x = 0
entity.y = 0
entity.health = 100

entity.isWasdSteering = true
entity.victoryAudio = love.audio.newSource("audio/andrew_victory.mp3","static")
entity.deathAudio = love.audio.newSource("audio/andrew_victory.mp3","static")
entity.color = {r=1, g=1, b=1}
entity.direction = 0
entity.directionStrength = 0
entity.movementDirection = 0
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/andrew.png")
entity.frames = newTextureSheet(entity.texture, 16, 16, 4, 2)
entity.frameCooldown = 0.2
entity.invincibilityFrames = 0.2
entity.invincibilityFramesTimer = 0.1
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 32
entity.radius = 1/2*math.pi
entity.hitCooldown = 0.2
entity.hitCooldownTimer = 0.2
entity.damage = 5
entity.isMoving = false

function entity:load()
    MaxPlayerHealth = self.health
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setMask(2)
    player = self
end
function entity:update(dt)
    self.invincibilityFramesTimer = self.invincibilityFramesTimer - dt
    if self.invincibilityFramesTimer > 0 then
        self.color = {r=1, g=0, b=0}
    else
        self.color = {r=1, g=1, b=1}
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("s") or love.keyboard.isDown("d") then
        steer(self.body, 200, self.isWasdSteering)
        self.isMoving = true
    else
        self.isMoving = false
        self.body:setLinearVelocity(0,0)
    end
    self.z = self.y
    self.animationTimer = self.animationTimer + dt
    if player.health <= 0 then
        self.deathAudio:play()
        gameOver()
    end
    
    
    self.hitCooldownTimer = self.hitCooldownTimer - dt
        --[[ deal damage --]]
    if self.hitCooldownTimer <= 0 and love.mouse.isDown(1) then
        self.hitCooldownTimer = self.hitCooldown
        for _, individualEntity in ipairs(Entities) do
            if love.physics.getDistance(self.fixture, individualEntity.fixture) < self.range and self.fixture ~= individualEntity.fixture and individualEntity.health and math.sqrt((getDirection(player.body:getX(), player.body:getY(), individualEntity.body:getX(), individualEntity.body:getY())+ 1/2*math.pi - player.direction)^2) < self.radius then
                individualEntity.health = individualEntity.health - self.damage
                individualEntity.invincibilityFramesTimer = individualEntity.invincibilityFrames
            end
        end
    end
    ---[[
    
    self.movementDirection = self.movementDirection % (2*math.pi)
    self.x, self.y = self.body:getPosition()
    if self.isMoving then
        if self.movementDirection >= (1/2) * math.pi and self.movementDirection <= (3/2) * math.pi then
            self.currentFrame = self.frames[2][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
        elseif self.movementDirection > (3/2) * math.pi or self.movementDirection < (1/2) * math.pi then
            self.currentFrame = self.frames[1][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
        end
    else
        if self.movementDirection > (1/2) * math.pi and self.movementDirection < (3/2) * math.pi then
            self.currentFrame = self.frames[2][math.floor(1)]
        elseif self.movementDirection > (3/2) * math.pi or self.movementDirection < (1/2) * math.pi then
            self.currentFrame = self.frames[1][math.floor(1)]
        end
    end
    --]]
end
function entity:draw()
    love.graphics.setColor(1 * WorldColor.r * self.color.r, 1 * WorldColor.g * self.color.g, 1 * WorldColor.b * self.color.b)
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y - 4, 0, 1, 1, 8, 8)
    
    --love.graphics.line(self.x, self.y, self.x + math.cos(self.direction - 1/2*math.pi) * 8, self.y + (-math.sin(self.direction - 1/2*math.pi))* 8)
    --love.graphics.line(self.x, self.y,self.body:getX() + love.mouse:getX() / Scale - love.graphics.getWidth()/2/ Scale, self.body:getY() + love.mouse:getY()/ Scale - love.graphics.getHeight()/2/ Scale)
end
return entity

