local entity = {}
entity.x = 0
entity.y = 0
entity.color = {r=1, g=1, b=1}
entity.direction = 0
entity.doorSize = 32
entity.isExistent = true
entity.texture = love.graphics.newImage("textures/gate.png")
entity.frames = newTextureSheet(entity.texture, 32, 16, 1, 5)
entity.frameCooldown = 0.2
entity.animationTimer = 0
entity.currentFrame = entity.frames[1][1]
entity.range = 30
entity.hitCooldown = 0
entity.hitCooldownTimer = 0
entity.openingTimer = 0
entity.damage = 10
entity.isClosed = true

function entity:load(mode)
    self.mode = mode[1]
    if self.mode == "left" or self.mode == "right" then
        self.shape = love.physics.newRectangleShape(4, self.doorSize)
    elseif self.mode == "up" or self.mode == "down" then
        self.shape = love.physics.newRectangleShape(self.doorSize, 4)
    else
        self.shape = love.physics.newCircleShape(1)
    end
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "static")
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
    
    ---[[
    
    
    self.direction = self.direction % (2*math.pi)
    self.x, self.y = self.body:getPosition()
    if DoorsAreOpen then
        self.fixture:setCategory(2)
        self.isClosed = false
        self.z = 0
    else
        self.fixture:setCategory(1)
        self.isClosed = true
        self.z = self.y
    end
    
    --]]
end
function entity:draw()
    love.graphics.setColor(1 * WorldColor.r * self.color.r, 1 * WorldColor.g * self.color.g, 1 * WorldColor.b * self.color.b)
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y, 0, 1, 1, 16, 14)
    if love.physics.getDistance(player.fixture, self.fixture) < 30 and self.isClosed then
        self.openingTimer = self.openingTimer - 0.2
        if self.openingTimer < 0 then
            self.openingTimer = 0
        end
    else 
        self.openingTimer = self.openingTimer + 0.2
        if self.openingTimer > 4 then
            self.openingTimer = 4
        end
    end
    self.currentFrame = self.frames[math.floor(self.openingTimer) + 1][1]
    
end
return entity

