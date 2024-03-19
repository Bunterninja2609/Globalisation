local entity = {}
entity.x = 0
entity.y = 0
entity.isExistent = true
entity.isOpened = false
entity.texture = love.graphics.newImage("textures/chest.png")
entity.frames = {{love.graphics.newQuad(0, 0, 16, 16, entity.texture), love.graphics.newQuad(16, 0, 16, 16, entity.texture)}}
entity.currentFrame = entity.frames[1][2]

function entity:load(text)
    self.body = love.physics.newBody(WorldSpace, self.x, self.y, "static")
    self.shape = love.physics.newCircleShape(8)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.text = text
end
function entity:update(dt)
    self.body:setLinearVelocity(0,0)
    
    if love.physics.getDistance(player.fixture, self.fixture) < 30 and (love.keyboard.isDown("e") or joysticks[1]:isDown(4)) then
        self.isOpened = true
    end
    self.x, self.y = self.body:getPosition()
end
function entity:draw()
    love.graphics.setColor(1,1,1,1)
    if self.isOpened then
        self.currentFrame = self.frames[1][2]
    else
        self.currentFrame = self.frames[1][1]
    end
    love.graphics.draw(self.texture, self.currentFrame, self.x, self.y,0,1,1, 8, 8)
    if love.physics.getDistance(player.fixture, self.fixture) < 30 and self.isOpened then
        addUi(self.text)
    end
end
return entity