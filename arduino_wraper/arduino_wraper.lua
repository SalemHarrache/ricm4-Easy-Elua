--                              __
-- ___  __ _ ___ _   _    ___  / / _   _  __ _
-- / _ \/ _` / __| | | |  / _ \/ / | | | |/ _` |
--|  __/ (_| \__ \ |_| | |  __/ /__| |_| | (_| |
-- \___|\__,_|___/\__, |  \___\____/\__,_|\__,_|
--               |___/

--Copyright (c) 2012 by Salem Harrache and Elizabeth Paz.

--Some rights reserved.

--Redistribution and use in source and binary forms of the software as well
--as documentation, with or without modification, are permitted provided
--that the following conditions are met:

--* Redistributions of source code must retain the above copyright
-- notice, this list of conditions and the following disclaimer.

--* Redistributions in binary form must reproduce the above
-- copyright notice, this list of conditions and the following
-- disclaimer in the documentation and/or other materials provided
-- with the distribution.

--* The names of the contributors may not be used to endorse or
-- promote products derived from this software without specific
-- prior written permission.

OUTPUT      = pio.OUTPUT
INPUT       = pio.INPUT
HIGH        = 1
LOW         = 0
BIN         = "BIN"
HEX         = "HEX"
OCT         = "OCT"
DEC         = "DEC"
USER_BTN    = pio.PA_0
LED1        = pio.PD_12
LED2        = pio.PD_13
LED3        = pio.PD_14
LED4        = pio.PD_15
GREEN_LED   = LED1
ORANGE_LED  = LED2
RED_LED     = LED3
BLUE_LED    = LED4


--Utils

mod     = math.mod
floor   = math.floor
min     = math.min
max     = math.max
abs     = math.abs
pow     = math.pow
sqrt    = math.sqrt

function constrain(x, a, b)
    -- Constrains a number to be within a range.
    -- Returns
    --  x: the number to constrain, all data types
    --  a: the lower end of the range, all data types
    --  b: the upper end of the range, all data types
    if a <= x and x <= b then
        return x
    elseif x < a then
        return a
    else
        return b
    end
end

function numberstring(number, base)
    number = floor(number)
    digits = {}
    for i=0,9 do digits[i] = string.char(string.byte('0')+i) end
    for i=10,36 do digits[i] = string.char(string.byte('A')+i-10) end
    local s = ""
    repeat
      local remainder = mod(number,base)
      s = digits[remainder]..s
      number = (number-remainder)/base
    until number==0
    return s
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

-- Classes

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

-- Serial communication object
SerialPort = Class:new()

function SerialPort:__new(uartid, baud, databits, parity, stopbits)
    -- Initialize SerialPort
    self.uartid = uartid
    self.baud = baud or 115200
    self.databits = databits or 8
    self.parity = parity or uart.PAR_NONE
    self.stopbits = stopbits or uart.STOP_1
end

function SerialPort:begin(baud)
    -- Setup the serial port
    -- Returns: The actual baud rate set on the serial port.
    -- Depending on the hardware, this might have a different value than the
    -- baud parameter
    self.baud = baud or self.baud
    return uart.setup( self.uartid, self.baud, self.databits, self.parity,
                        self.stopbits )
end

function SerialPort:print(value, format)
    -- Prints data to the serial port as human-readable ASCII text.
    -- This method can take many forms. Numbers are printed using an ASCII
    -- character for each digit. Floats are similarly printed as ASCII digits,
    -- defaulting to two decimal places. Bytes are sent as a single character.
    --
    -- Characters and strings are sent as is. For example:
    -- Serial.print(78) gives "78"
    -- Serial.print(1.23456) gives "1.23"
    -- Serial.print('N') gives "N"
    -- Serial.print("Hello world.") gives "Hello world."

    -- An optional second parameter specifies the base (format) to use;
    -- permitted values are BIN (binary, or base 2), OCT (octal, or base 8),
    -- DEC (decimal, or base 10), HEX (hexadecimal, or base 16). For floating
    -- point numbers, this parameter specifies the number of decimal places
    -- to use. For example:
    --
    -- Serial.print(78, BIN) gives "1001110"
    -- Serial.print(78, OCT) gives "116"
    -- Serial.print(78, DEC) gives "78"
    -- Serial.print(78, HEX) gives "4E"
    -- Serial.println(1.23456, 0) gives "1"
    -- Serial.println(1.23456, 2) gives "1.23"
    -- Serial.println(1.23456, 4) gives "1.2346"

    if type (value) == "string" then
        uart.write( self.uartid, value)
    end

    if type (value) == "number" then
        if format ~= nil then
            if format == BIN then
                value = numberstring(value,2)
            elseif format == OCT then
                value = numberstring(value,8)
            elseif format == DEC then
                value = numberstring(value,10)
            elseif format == HEX then
                value = string.upper(numberstring(value,16))
            end
        elseif type (format) == "number" and format >= 0 then
            value = string.format("%." .. format .. "f", value)
        else
            -- if value is float
            if value ~= floor(value) then
                value = string.format("%.2f", value)
            else
                value = string.format("%d", value)
            end
        end
        uart.write( self.uartid, value)
    end
end

function SerialPort:println(...)
    self:print(...)
    self:print("\n")
end

function SerialPort:read()
    -- Read a single or many character(s) from the serial port
    -- Return nil if no data is available
    return uart.getchar(self.uartid, 0)
end

function SerialPort:readwait()
    -- Read a single character from the serial port
    -- Wait if no data is available
    return uart.getchar(self.uartid, uart.INF_TIMEOUT)
end

function SerialPort:write(value)
    -- Writes binary data to the serial port.
    -- This data is sent as a byte or series of bytes; to send the characters
    -- representing the digits of a number use the print() function instead.
    if type(value) ~= "string" and type(value) ~= "number" then
        value = string.format("%s", value)
    end

    if type(value) == "string" then
        for i=1, string.len(a) do
            uart.write( self.uartid, string.byte(a, i))
        end
        return string.len(a)
    else
        if value > 255 or value < 0 then
            uart.write( self.uartid, string.byte(a, i))
        else
            return -1
        end
        return 1
    end
end

Serial0 = SerialPort:new(0)
Serial1 = SerialPort:new(1)
Serial2 = SerialPort:new(2)
Serial3 = SerialPort:new(3)
Serial4 = SerialPort:new(4)
Serial5 = SerialPort:new(5)


-- App
App = Class:new()

function App:__new(name)
    -- Initialize App
    self.name = name
    self.serial = Serial0
    self.timerid = 1
    -- initialize button pin
    pinMode(USER_BTN, INPUT)
end

function App:setup()
    return
end

function App:loop()
    return
end

function App:condition()
    return self.serial:read() == ""
end

function App:run()
    self:print("Run : " .. self.name)
    self:setup()
    tmr.setclock(self.timerid , 1)
    self.start_counter = tmr.start(self.timerid)
    while self:condition() do
        self:loop()
    end
    collectgarbage()
end

function App:print(...)
    self.serial:print(...)
end

function App:println(...)
    self.serial:println(...)
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

function App:btn_pressed()
    return pio.pin.getval(USER_BTN) ~= 0
end


return App, Serial0, Serial1, Serial2, Serial3, Serial4, Serial5

