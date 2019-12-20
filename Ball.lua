Ball = {}
Ball.__index = Ball

function Ball:create(pos)
    local b = {}
    setmetatable(b, Ball)

    b._Radius = 8
    b._AudioSource = love.audio.newSource("sounds/pong.wav", "static")
    pos:subNum(b._Radius / 2)
    b._Position = pos
    b._Velocity = Vector:create(3, 0)

    return b
end

function Ball:update()
    self._Position = self._Position + self._Velocity
    self:checkPlatformCollision()
    self:checkBoundaries()
end

function Ball:draw()
    love.graphics.rectangle("fill", self._Position.x, self._Position.y, self._Radius, self._Radius)
end

function Ball:checkBoundaries()
    if (self._Position.x <= _PL._Position.x - self._Radius) then
        onBallConceded(false)
    elseif (self._Position.x >= _PR._Position.x + _PR._Width) then
        onBallConceded(true)
    elseif (self._Position.y <= _FieldBorderTopY) or (self._Position.y >= _FieldBorderBottomY - self._Radius) then
        self._AudioSource:play()
        self._Velocity.y = -self._Velocity.y
    end
end

function Ball:stop()
    self._Velocity.x = 0
    self._Velocity.y = 0
end

function Ball:checkPlatformCollision()
    local isInRight = self._Position.x > _Width / 2;
    if (isInRight) then
        if (self._Position.x >= _PR._Position.x)
            and (self._Position.x <= _PR._Position.x + _PR._Width)
            and (self._Position.y >= _PR._Position.y)
            and (self._Position.y <= _PR._Position.y + _PR._Height) then
                self._Position.x = _PR._Position.x
                self._Velocity.x = -self._Velocity.x
        end
    else
        if (self._Position.x >= _PL._Position.x)
            and (self._Position.x <= _PL._Position.x + _PL._Width)
            and (self._Position.y >= _PL._Position.y)
            and (self._Position.y <= _PL._Position.y + _PL._Height) then
                self._Position.x = _PL._Position.x + _PL._Width
                self._Velocity.x = -self._Velocity.x
        end
    end
end