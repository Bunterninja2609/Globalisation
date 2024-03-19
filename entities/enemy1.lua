local entity = {}
entity.x = 0
entity.y = 0
entity.isExistent = true
entity.color = {0,0,0}
entity.hitCooldown = 5
entity.hitCooldownTimer = 5
function entity:load()
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(10)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end
function entity:update(dt)
    self.color = {0,0,0}
    self.body:setLinearVelocity(0,0)
    self.hitCooldownTimer = self.hitCooldownTimer - dt
    if love.physics.getDistance(player.fixture, self.fixture) < 20 and self.hitCooldownTimer <= 0 then
        self.color = {1,0,0}
        self.hitCooldownTimer = self.hitCooldown
    end
    self.body:setLinearVelocity(player.body:getX() - self.body:getX(), player.body:getY() - self.body:getY())
    
    love.graphics.setColor(1,0,0)
    self.x, self.y = self.body:getPosition()
    
end
function entity:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", self.x, self.y, 10)
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, 10*(self.hitCooldownTimer/self.hitCooldown))
end
return entity