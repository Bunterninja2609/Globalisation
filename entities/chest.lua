local entity = {}
entity.x = 0
entity.y = 0
entity.isExistent = true
entity.color = {1, 1, 1}
function entity:load(text)
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "static")
    self.shape = love.physics.newCircleShape(10)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.text = text
end
function entity:update(dt)
    self.color = {0,0,0}
    self.body:setLinearVelocity(0,0)
    if love.physics.getDistance(player.fixture, self.fixture) < 100 and love.keyboard.isDown("e") then
        self.color = {1,0,0}
    end

    love.graphics.setColor(1,0,0)
    self.x, self.y = self.body:getPosition()
    
end
function entity:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, 10)
    if love.physics.getDistance(player.fixture, self.fixture) < 100 and love.keyboard.isDown("e") then
        love.graphics.print(self.text, self.x, self.y)
    end
end
return entity