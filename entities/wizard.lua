local entity = {}
entity.z = 1
entity.x = 0
entity.y = 0
entity.color = {r=1, g=1, b=1}
entity.direction = 0
entity.speed = 100
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/wizard.png")
entity.frames = newTextureSheet(entity.texture, 16, 16, 5, 8)
entity.frameCooldown = 0.2
entity.invincibilityFrames = 0.2
entity.invincibilityFramesTimer = 0.2
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 10
entity.hitCooldown = 1
entity.hitCooldownTimer = 1
entity.damage = 1
entity.isMoving = false
entity.health = 200

function entity:load()
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end
function entity:update(dt, _)
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
    if self.direction > (1/4) * math.pi and self.direction < (3/4) * math.pi then
        self.currentFrame = self.frames[4][(math.floor(self.animationTimer / self.frameCooldown))%5 + 1]
    elseif self.direction > (3/4) * math.pi and self.direction < (5/4) * math.pi then
        self.currentFrame = self.frames[2][(math.floor(self.animationTimer / self.frameCooldown))%5 + 1]
    elseif self.direction > (5/4) * math.pi and self.direction < (7/4) * math.pi then
        self.currentFrame = self.frames[3][(math.floor(self.animationTimer / self.frameCooldown))%5 + 1]
    elseif self.direction > (5/4) * math.pi or self.direction < (1/4) * math.pi then
        self.currentFrame = self.frames[1][(math.floor(self.animationTimer / self.frameCooldown))%5 + 1]
    end
    if self.health <= 0 then
        self.fixture:destroy()
        table.remove(Entities, _)
    end
    --]]
end
function entity:draw()
    love.graphics.setColor(1 * WorldColor.r * self.color.r, 1 * WorldColor.g * self.color.g, 1 * WorldColor.b * self.color.b)
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y,0,1,1, 8, 12)
    if love.physics.getDistance(player.fixture, self.fixture) < 100 then
        --[[ Something that is leleleleleleleellleeelleELELELELLELELELELELELELELEL EL EL EL ELL ELELEL E LE LEL EL EE E EL EE LE LE E E   and range stuff--]]
    end
    --love.graphics.line(self.x, self.y, self.x + math.cos(self.direction) * 8, self.y + (-math.sin(self.direction))* 8)
end
return entity

