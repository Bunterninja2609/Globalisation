local entity = {}
entity.x = 0
entity.y = 0
entity.isExistent = true
entity.isOpened = false
entity.texture = love.graphics.newImage("textures/chest.png")
entity.textures = {love.graphics.newQuad(0, 0, 16, 16, entity.texture), love.graphics.newQuad(16, 0, 16, 16, entity.texture)}

function entity:load(text)
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "static")
    self.shape = love.physics.newCircleShape(8)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.text = text
end
function entity:update(dt)
    self.body:setLinearVelocity(0,0)
    if love.physics.getDistance(player.fixture, self.fixture) < 30 and love.keyboard.isDown("e") then
        self.isOpened = true
    end
    self.x, self.y = self.body:getPosition()
end
function entity:draw()
    love.graphics.setColor(1,1,1,1)
    if self.isOpened then
        love.graphics.draw(self.texture, self.textures[2], self.x, self.y,0,1,1, 8, 8)
    else
        love.graphics.draw(self.texture, self.textures[1], self.x, self.y,0,1,1, 8, 8)
    end
    if love.physics.getDistance(player.fixture, self.fixture) < 30 and self.isOpened then
        addUi(self.text)
    end
end
return entity