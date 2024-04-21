local entity = {}
entity.z = 1
entity.x = 0
entity.y = 0
entity.color = {r=1, g=1, b=1}
entity.direction = 0
entity.speed = 50
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/chineseBoss.png")
entity.frames = newTextureSheet(entity.texture, 20, 20, 4, 2)
entity.frameCooldown = 0.2
entity.invincibilityFrames = 0.2
entity.invincibilityFramesTimer = 0.2
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 16
entity.hitCooldown = 1
entity.hitCooldownTimer = 1
entity.damage = 10
entity.isMoving = false
entity.health = 250




function entity:load()
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.particleSystem = love.graphics.newParticleSystem(love.graphics.newImage("textures/particle.png"), 64)
    self.particleSystem = love.graphics.newParticleSystem(love.graphics.newImage("textures/particle.png"), 128)
    self.particleSystem:setColors(1,0,0,1, 0.1,0,0,1)
    self.particleSystem:setParticleLifetime(0.1, 1)
    
    self.particleSystem:setSpeed(30,40)
    self.particleSystem:setSizes(1, 2)
    self.particleSystem:setSpread(math.pi)
end
function entity:update(dt, _)
    self.invincibilityFramesTimer = self.invincibilityFramesTimer - dt
    if self.invincibilityFramesTimer > 0 then
        self.color = {r=1, g=0, b=0}
    else
        self.color = {r=1, g=1, b=1}
    end
    self.z = self.y
    
    local vx, vy = self.body:getLinearVelocity()
    if math.sqrt(vx^2 + vy^2) > 0 then
        self.isMoving = true
    else
        self.isMoving = false
    end
    if self.isMoving then
        self.animationTimer = self.animationTimer + dt
    end
    
    self.body:setLinearVelocity(self.speed * math.cos(self.direction),- self.speed * math.sin(self.direction) )
    self.hitCooldownTimer = self.hitCooldownTimer - dt
        --[[ deal damage --]]
    if love.physics.getDistance(player.fixture, self.fixture) < self.range and self.hitCooldownTimer <= 0 and player.invincibilityFramesTimer <= 0 then
        self.hitCooldownTimer = self.hitCooldown
        player.health = player.health - self.damage
        player.invincibilityFramesTimer = player.invincibilityFrames
    end
    self.hitCooldownTimer = self.hitCooldownTimer - dt
    ---[[
    self.direction = getDirection(self.x, self.y, player.body:getX(), player.body:getY())
    self.direction = self.direction % (2*math.pi)
    self.x, self.y = self.body:getPosition()
    if self.direction > (1/2) * math.pi and self.direction < (3/2) * math.pi then
        self.currentFrame = self.frames[2][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    elseif self.direction > (3/2) * math.pi or self.direction < (1/2) * math.pi then
        self.currentFrame = self.frames[1][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    end
    if self.health <= 0 then
        player.health = player.health + (100 - player.health) * 1/2
        for i = 0, 6 do
            spawnEntity("chineseMinion", self.x, self.y)
        end
        self.fixture:destroy()
        table.remove(Entities, _)

    end
    self.particleSystem:setPosition(self.x, self.y)
    self.particleSystem:update(dt)
    --]]
end
function entity:draw()
    love.graphics.setColor(1 * WorldColor.r * self.color.r, 1 * WorldColor.g * self.color.g, 1 * WorldColor.b * self.color.b)
    love.graphics.draw(self.particleSystem, 0, 0) 
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y,0,1,1, 8, 12)
    if love.physics.getDistance(player.fixture, self.fixture) < 100 then
        --[[ Something that is leleleleleleleellleeelleELELELELLELELELELELELELELEL EL EL EL ELL ELELEL E LE LEL EL EE E EL EE LE LE E E   and range stuff--]]
    end
    --love.graphics.line(self.x, self.y, self.x + math.cos(self.direction) * 8, self.y + (-math.sin(self.direction))* 8)
end
return entity

