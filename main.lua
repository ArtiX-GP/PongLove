require("Vector")
require("Ball")
require("Platform")

function love.load()
    P = 0.4; -- Пропорциональный коэф.
    I = 0.2; -- Интегральный коэф.
    D = 0; -- Дифференциальный коэф.

    IMAX = 5
    IMIN = -5

    _IState = 0
    _DState = 0

    _GameState = "Welcome"

    -- Right, если хотите управлять правой платформой.
    _PlatformControl = "Right"

    _Width = love.graphics.getWidth()
    _Height = love.graphics.getHeight()

    _FieldBorderTopY = 60
    _FieldBorderBottomY = 560

    _Font =  love.graphics.newFont("fonts/AtariClassic-Regular.ttf", 24)
    love.graphics.setFont(_Font)

    _BallStartPosition = Vector:create(_Width / 2, _Height / 2)
    _Ball = Ball:create(_BallStartPosition)

    _PL = Platform:create(Vector:create(40, _Height / 2))
    _PR = Platform:create(Vector:create(737, _Height / 2))

    _SL = 0
    _SR = 0

    _SpeedMultiply = 1
end

function onBallConceded(isRightSide)
    if (_PlatformControl == "Right") then
        if (isRightSide) then
            _Ball._Position.x = _PR._Position.x - _Ball._Radius
            _Ball._Position.y = _PR._Position.y + _PR._Height / 2 - _Ball._Radius / 2
            _Ball:stop()

            _GameState = "PlayerMove"
            _SL = _SL + 1
        else
            _Ball._Position = _BallStartPosition
            _Ball._Velocity = Vector:random(2, 4, -3, 3)
            _Ball._Velocity:mul(_SpeedMultiply)
            _SR = _SR + 1
        end

        if (_SR >= 4) then
            setHard()
        end
    else
        if (isRightSide) then
            _Ball._Position = _BallStartPosition
            _Ball._Velocity = Vector:random(2, 4, -3, 3)
            _Ball._Velocity:mul(_SpeedMultiply)
            _SL = _SL + 1
        else
            _Ball._Position.x = _PR._Position.x - _Ball._Radius
            _Ball._Position.y = _PR._Position.y + _PR._Height / 2 - _Ball._Radius / 2
            _Ball:stop()

            _GameState = "PlayerMove"
            _SR = _SR + 1
        end

        if (_SL >= 4) then
            setHard()
        end
    end

    if (_SL > 9) or (_SR > 9) then
        _GameState = "Result"
    end
   
    _Ball._AudioSource:play()
end

function setHard()
    _SpeedMultiply = 3

    P = 100
    I = 0
    D = 0.2
end

function love.update(dt)
    if (_GameState == "Game") or (_GameState == "PlayerMove") then
        _PL:update()
        _PR:update()

        if (_GameState == "PlayerMove") then
            _Ball._Position.x = _PR._Position.x - _Ball._Radius
            _Ball._Position.y = _PR._Position.y + _PR._Height / 2 - _Ball._Radius / 2
        end
        _Ball:update()

        if (_PlatformControl == "Right") then
            _PL:keepTarget()
        else
            _PR:keepTarget()
        end
    end
end

function love.draw()
    if (_GameState == "Welcome") then
        love.graphics.print("Pong Game", 300, 220)
        love.graphics.print("Press space to start!", 120, 280)
    elseif (_GameState == "Game") or (_GameState == "PlayerMove") then
        love.graphics.line(400, 0, 400, 600)
        love.graphics.rectangle("line", 30, _FieldBorderTopY, 740, _FieldBorderBottomY - _FieldBorderTopY)
        love.graphics.print(tostring(_SL), 350, 20)
        love.graphics.print(tostring(_SR), 430, 20)

        _PL:draw()
        _PR:draw()
        _Ball:draw()
    elseif (_GameState == "Result") then
        if (_PlatformControl == "Right") then
            if (_SR > _SL) then 
                love.graphics.print("Congratulations!", 120, 220)
                love.graphics.print("You won!", 300, 280)
            else
                love.graphics.print("So close...", 300, 220)
                love.graphics.print("You lost!", 300, 280)
            end
        else
            if (_SR < _SL) then 
                love.graphics.print("Congratulations!", 120, 220)
                love.graphics.print("You won!", 300, 280)
            else
                love.graphics.print("So close...", 300, 220)
                love.graphics.print("You lost!", 300, 280)
            end
        end
    end
end

function love.keypressed(key)
    if (key == "space") then
        if (_GameState == "Welcome") then
            _GameState = "Game"
        elseif (_GameState == "PlayerMove") then
            _GameState = "Game"
            if (_PlatformControl == "Right") then
                _Ball._Velocity = Vector:random(-5, -3, -3, 3)
                _Ball._Velocity:mul(_SpeedMultiply)
            else
                _Ball._Velocity = Vector:random(3, 5, -3, 3)
                _Ball._Velocity:mul(_SpeedMultiply)
            end
        end
    elseif (key == "up") then
        if (_GameState == "Game") or (_GameState == "PlayerMove") then
            if (_PlatformControl == "Right") then
                _PR._Velocity.y = -4
            else
                _PL._Velocity.y = -4
            end
        end
    elseif (key == "down") then
        if (_GameState == "Game") or (_GameState == "PlayerMove") then
            if (_PlatformControl == "Right") then
                _PR._Velocity.y = 4
            else
                _PL._Velocity.y = 4
            end
        end
    end
end