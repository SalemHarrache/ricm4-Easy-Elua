--   ASCII table
-- Prints out byte values in all possible formats:
--  * as raw binary values
--  * as ASCII-encoded decimal, hex, octal, and binary values
require("arduino_wraper")

-- the setup routine runs once when you press reset
function App:setup()
    -- first visible ASCIIcharacter '!' is number 33:
    self.byte = 33 -- '!' ASCII character
end

function App:loop()
    -- prints ending line break
    self:println()
    -- ASCII, so 33, the first number,  will show up as '!'
    self:write(self.byte)
    -- prints value as simple number (base 10)
    self:print(", dec: " .. self.byte)
    self:print(", hex: ")
    -- prints value as string in hexadecimal (base 16)
    self:print(self.byte, HEX)
    -- prints value as string in octal (base 8)
    self:print(", oct: ")

    self:print(self.byte, OCT)
    self:print(", bin: ")
    -- prints value as string in binary (base 2)
    self:print(self.byte, BIN)

    self.byte = self.byte + 1
    delay(1000)
end

app = App:new("ASCII Table ~ Character Map")
app:run()

