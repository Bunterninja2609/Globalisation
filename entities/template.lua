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
    self.direction = math.atan2(player.body:getX() - self.x, player.body:getY() - self.y)
    self.x, self.y = self.body:getPosition()
    if self.direction > math.pi/4 and self.direction < 3 * math.pi/4 then
        self.currentFrame = self.frames[1][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    elseif self.direction > 3 * math.pi/4 and self.direction < 5 * math.pi/4 then
        self.currentFrame = self.frames[3][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    elseif self.direction > 5 * math.pi/4 and self.direction < 7 * math.pi/4 then
        self.currentFrame = self.frames[2][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    else
        self.currentFrame = self.frames[4][(math.floor(self.animationTimer / self.frameCooldown))%4 + 1]
    end
    --]]
end
function entity:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y,0,1,1, 8, 8)
    if love.physics.getDistance(player.fixture, self.fixture) < 30 and self.isOpened then
        addUi(self.text)
    end
end
return entity

