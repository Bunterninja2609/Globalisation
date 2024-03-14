local entity = {}
entity.x = 0
entity.y = 0
entity.isExistent = true
entity.color = {0,0,0}
function entity:load()
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(10)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end
function entity:update(dt)
    self.color = {0,0,0}
    if love.physics.getDistance(player.fixture, self.fixture) < 200 then
        self.body:applyLinearImpulse(player.body:getX() - self.body:getX(),player.body:getY() - self.body:getY())
        self.color = {1,0,0}
    end

    love.graphics.setColor(1,0,0)
    self.x, self.y = self.body:getPosition()
    
end
function entity:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, 10)
end
return entity