local entity = {}
entity.z = 1
entity.x = 0
entity.y = 0
entity.color = {r=1, g=1, b=1}
entity.direction = 0
entity.movementTimer = 0
entity.aimingDirection = 0
entity.speed = 100
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/Trump.png")
entity.frames = newTextureSheet(entity.texture, 16, 16, 3, 2)
entity.frameCooldown = 0.05
entity.invincibilityFrames = 0.1
entity.invincibilityFramesTimer = 0.5
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 10
entity.hitCooldown = 4
entity.hitCooldownTimer = 0
entity.damage = 10
entity.isMoving = false
entity.health = 50

function entity:load()
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    
end
function entity:update(dt, _)
    self.aimingDirection = getDirection(self.x, self.y, player.body:getX(), player.body:getY())
    self.invincibilityFramesTimer = self.invincibilityFramesTimer - dt
    if self.invincibilityFramesTimer > 0 then
        self.color = {r=1, g=0, b=0}
    else
        self.color = {r=1, g=1, b=1}
        self.body:setLinearVelocity(self.speed * math.cos(self.direction),- self.speed * math.sin(self.direction) )
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
    
    
    self.hitCooldownTimer = self.hitCooldownTimer - dt
        --[[ deal damage --]]
    if self.hitCooldownTimer <= 0 and player.invincibilityFramesTimer <= 0 then
        for i = 0, 0 do
            spawnEntity("cow_shit", self.x, self.y, self.aimingDirection, 300)
        end
        self.hitCooldownTimer = self.hitCooldown
    end
    self.hitCooldownTimer = self.hitCooldownTimer - dt
    ---[[
    if self.hitCooldownTimer <= 0 then
        
    end
    if self.health <= 60 then
        self.speed = 600
    end
    if love.physics.getDistance(player.fixture, self.fixture) < 128 and false then
        self.direction = getDirection(player.body:getX(), player.body:getY(), self.x, self.y)
    elseif love.physics.getDistance(player.fixture, self.fixture) > 80 and false then
        self.direction = getDirection(self.x, self.y, player.body:getX(), player.body:getY())
    else
        self.movementTimer = self.movementTimer + 4*dt
        baseDir = getDirection(player.x, player.y, self.x, self.y)
        r = 50
        self.direction = getDirection(self.x, self.y, player.body:getX() + math.cos(baseDir+self.movementTimer)*r, player.body:getY() + math.sin(baseDir+self.movementTimer)*r)
    end
    self.direction = self.direction % (2*math.pi)
    self.x, self.y = self.body:getPosition()
    if self.aimingDirection > (1/2) * math.pi and self.aimingDirection < (3/2) * math.pi then
        self.currentFrame = self.frames[2][(math.floor(self.animationTimer / self.frameCooldown))%3 + 1]
    elseif self.aimingDirection > (3/2) * math.pi or self.aimingDirection < (1/2) * math.pi then
        self.currentFrame = self.frames[1][(math.floor(self.animationTimer / self.frameCooldown))%3 + 1]
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

