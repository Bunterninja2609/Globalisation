local entity = {}
entity.x = 0
entity.y = 0
entity.direction = 0
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/template.png")
entity.frames = newTextureSheet(entity.texture, 16, 16, 4, 4)
entity.frameCooldown = 0.2
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 30
entity.hitCooldown = 5
entity.hitCooldownTimer = 5
entity.damage = 10

function entity:load()
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(8)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end
function entity:update(dt)
    self.z = self.y
    self.animationTimer = self.animationTimer + dt
    
    self.body:setLinearVelocity(0,0)
    
    
    if love.physics.getDistance(player.fixture, self.fixture) < self.range and (love.keyboard.isDown("e") --[[ or  joysticks[1]:isDown(4) --]]) then
        --[[ interact --]]
    end
    self.hitCooldownTimer = self.hitCooldownTimer - dt
        --[[ deal damage --]]
    if love.physics.getDistance(player.fixture, self.fixture) < self.range and self.hitCooldownTimer <= 0 then
        self.hitCooldownTimer = self.hitCooldown
        player.health = player.health - self.damage
    end
    ---[[
    self.direction = getDirection(self.x, self.y, player.body:getX(), player.body:getY())
    self.direction = self.direction % (2*math.pi)
    self.x, self.y = self.body:getPosition()
    if self.direction > (1/4) * math.pi and self.direction < (3/4) * math.pi then
        self.currentFrame = self.frames[1][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    elseif self.direction > (3/4) * math.pi and self.direction < (5/4) * math.pi then
        self.currentFrame = self.frames[3][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    elseif self.direction > (5/4) * math.pi and self.direction < (7/4) * math.pi then
        self.currentFrame = self.frames[2][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    elseif self.direction > (5/4) * math.pi or self.direction < (1/4) * math.pi then
        self.currentFrame = self.frames[4][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    end
    --]]
end
function entity:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y,0,1,1, 8, 8)
    if love.physics.getDistance(player.fixture, self.fixture) < 100 then
        --[[ Something that is leleleleleleleellleeelleELELELELLELELELELELELELELEL EL EL EL ELL ELELEL E LE LEL EL EE E EL EE LE LE E E   and range stuff--]]
    end
    love.graphics.line(self.x, self.y, self.x + math.cos(self.direction) * 8, self.y + (-math.sin(self.direction))* 8)
end
return entity

