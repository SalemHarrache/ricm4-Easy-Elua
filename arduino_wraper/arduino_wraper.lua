--                               __
--  ___  __ _ ___ _   _    ___  / / _   _  __ _
-- / _ \/ _` / __| | | |  / _ \/ / | | | |/ _` |
--|  __/ (_| \__ \ |_| | |  __/ /__| |_| | (_| |
-- \___|\__,_|___/\__, |  \___\____/\__,_|\__,_|
--                |___/

--Copyright (c) 2012 by Salem Harrache and Elizabeth Paz.

--Some rights reserved.

--Redistribution and use in source and binary forms of the software as well
--as documentation, with or without modification, are permitted provided
--that the following conditions are met:

--* Redistributions of source code must retain the above copyright
--  notice, this list of conditions and the following disclaimer.

--* Redistributions in binary form must reproduce the above
--  copyright notice, this list of conditions and the following
--  disclaimer in the documentation and/or other materials provided
--  with the distribution.

--* The names of the contributors may not be used to endorse or
--  promote products derived from this software without specific
--  prior written permission.

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
    -- Initialize App
    self.name = name
    self.uartid = 0
    self.timerid = 1
end

function App:setup()
    return
end

function App:loop()
    return
end

function App:condition()
    return uart.getchar( self.uartid, 0 ) == ""
end

function App:run()
    print("Run : " .. self.name)
    tmr.setclock(self.timerid , 1)
    self.start_counter = tmr.start(self.timerid)
    self:setup()
    while self:condition() do
        self:loop()
    end
end

function App:micros()
    -- Number of microseconds since the program started
    time = tmr.read(self.timerid)
    return tmr.gettimediff(self.timerid, self.start_counter, time)
end

function App:millis()
    -- Number of milliseconds since the program started
    return self:micros() / 1000
end


-- Fonctions similaires à l'api arduino
function pinMode(pin, mode)
    if mode == OUTPUT or mode == INPUT then
        pio.pin.setdir(mode, pin)
    end
end

function digitalWrite(pin, value)
    if value == HIGH or value == LOW then
        pio.pin.setval( value, pin )
    end
end

function digitalRead(pin)
    return pio.pin.getval( pin )
end

function delay(period)
    -- period in milliseconds
    tmr.delay( 0, period * 1000)
end

function delayMicroseconds(period)
    -- period in us
    tmr.delay(0, period)
end

function getPin(name)
    -- return pin by name
    return pio[name]
end

return App

