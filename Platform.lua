Platform = {}
Platform.__index = Platform

function Platform:create(pos)
    local p = {}
    setmetatable(p, Platform)

    p._Position = pos
    p._Height = 64
    p._Width = 24
    p._Velocity = Vector:create(0, 0);

    p.ACC_MIN = -10
    p.ACC_MAX = 10

    return p
end

function Platform:draw()
    love.graphics.rectangle("fill", self._Position.x, self._Position.y, self._Width, self._Height)
end

function Platform:update()
    self._Position = self._Position + self._Velocity
    self:checkBoundaries()
end

function Platform:checkBoundaries()
    if (self._Position.y <= _FieldBorderTopY) then
        self._Position.y = _FieldBorderTopY
    end

    if (self._Position.y >= _FieldBorderBottomY - self._Height) then
        self._Position.y = _FieldBorderBottomY - self._Height
    end
end

function Platform:keepTarget()
    local e =  (_Ball._Position.y - (self._Position.y + self._Height / 2)) / (_FieldBorderBottomY - _FieldBorderTopY)


    local pTerm = P * e

    _IState = _IState + e
    if (_IState < IMIN) then 
        _IState = IMIN
    end

    if (_IState > IMAX) then
        _IState = IMAX
    end

    local iTerm = I * _IState

    local dTerm = D * (e - _DState)
    _DState = e

    print ("e: " .. e)

    local acc = pTerm + iTerm - dTerm
    if (acc < self.ACC_MIN) then
        acc = self.ACC_MIN
    end
    if (acc > self.ACC_MAX) then
        acc = self.ACC_MAX
    end

    print(acc)

    self._Velocity.y = acc
end