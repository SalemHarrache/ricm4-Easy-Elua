Class = {}

function Class:new(super)
    local class, metatable, properties = {}, {}, {}
    class.metatable = metatable
    class.properties = properties

    function metatable:__index(key)
        local prop = properties[key]
        if prop then
            return prop.get(self)
        elseif class[key] ~= nil then
            return class[key]
        elseif super then
            return super.metatable.__index(self, key)
        else
            return nil
        end
    end

    function metatable:__newindex(key, value)
        local prop = properties[key]
        if prop then
            return prop.set(self, value)
        elseif super then
            return super.metatable.__newindex(self, key, value)
        else
            rawset(self, key, value)
        end
    end

    function class:new(...)
        local obj = setmetatable({}, self.metatable)
        if obj.__new then
            obj:__new(...)
        end
        return obj
    end

    return class
end

OUTPUT = pio.OUTPUT
INPUT = pio.INPUT
HIGH = 1
LOW = 0

App = Class:new()

function App:__new(name)
    -- for debuging
    self.name = name
    self.uartid = 0
end

function App:setup()
    return
end

function App:loop()
    return
end

function App:run()
    print("Run : " .. self.name)
    self:setup()
    while uart.getchar( self.uartid, 0 ) == "" do
        self:loop()
    end
end

function App:pinMode(pin, mode)
    if mode == OUTPUT or mode == INPUT then
        pio.pin.setdir(mode, pin)
    end
end

function App:digitalWrite(pin, value)
    if value == HIGH or value == LOW then
        pio.pin.setval(value, pin)
    end
end

function App:digitalRead(pin)
    return pio.pin.getval(pin)
end

function App:delay(period)
    -- period in milliseconds
    tmr.delay( 0, period * 1000 )
end

function App:delayMicroseconds(period)
    -- period in us
    tmr.delay( 0, period)
end

function App:getPin(name)
    -- return pin by name
    return pio[name]
end

return App

