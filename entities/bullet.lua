local entity = {}
entity.z = 1
entity.x = 0
entity.y = 0
entity.color = {r=1, g=1, b=1}
entity.direction = 0
entity.speed = 300
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/bullet.png")
entity.frames = newTextureSheet(entity.texture, 16, 16, 1, 1)
entity.frameCooldown = 0.05
entity.invincibilityFrames = 0
entity.invincibilityFramesTimer = 0
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 1
entity.hitCooldown = 1
entity.hitCooldownTimer = 1
entity.damage = 10
entity.isMoving = false
entity.health = 30

function entity:load(direction, speed)
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(2)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.particleSystem = love.graphics.newParticleSystem(love.graphics.newImage("textures/particle.png"), 64)
    self.particleSystem:setColors(1,0,0,1, 1,0.5,0,1)
    self.particleSystem:setParticleLifetime(0.5, 1)
    self.particleSystem:setSpeed(100,200)
    self.particleSystem:setSizes(1, 2)
    self.particleSystem:setSpread(0.3)
    if speed then
        self.speed = speed
    end
    self.direction = direction
end
function entity:update(dt, _)
    self.hitCooldownTimer = self.hitCooldownTimer - dt
    self.invincibilityFramesTimer = self.invincibilityFramesTimer - dt
    if self.invincibilityFramesTimer > 0 then
        self.color = {r=1, g=0, b=0}
    else
        self.color = {r=1, g=1, b=1}
        self.body:setLinearVelocity(self.speed * math.cos(self.direction),- self.speed * math.sin(self.direction) )
    end
    self.z = self.y
    
    local vx, vy = self.body:getLinearVelocity()
    self.damage = math.sqrt(vx^2 + vy^2)/20
    
    
    if love.physics.getDistance(player.fixture, self.fixture) < self.range and player.invincibilityFramesTimer <= 0 then
        self.hitCooldownTimer = self.hitCooldown
        player.health = player.health - self.damage
        player.invincibilityFramesTimer = player.invincibilityFrames
        self.health = 0
    end
    if self.hitCooldownTimer <= 0 then
        self.health = 0
    end
    self.direction = self.direction % (2*math.pi)
    self.x, self.y = self.body:getPosition()
    if self.health <= 0 then
        self.fixture:destroy()
        table.remove(Entities, _)
    end
    --]]
end
function entity:draw()
    love.graphics.setColor(1 * WorldColor.r * self.color.r, 1 * WorldColor.g * self.color.g, 1 * WorldColor.b * self.color.b)
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y, self.direction ,1,1, 8, 8)
    if love.physics.getDistance(player.fixture, self.fixture) < 100 then
        --[[ Something that is leleleleleleleellleeelleELELELELLELELELELELELELELEL EL EL EL ELL ELELEL E LE LEL EL EE E EL EE LE LE E E   and range stuff--]]
    end
    --love.graphics.line(self.x, self.y, self.x + math.cos(self.direction) * 8, self.y + (-math.sin(self.direction))* 8)
end
return entity

