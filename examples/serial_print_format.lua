--  Serial communication
--  Send data to various Serials port
require("arduino_wraper")

-- Serial0 (Tx PB.6, Rx PB.7)
-- Serial1 (Tx PA.2, Rx PA.3)
-- Serial2 (Tx PC.10, Rx PC.11)
-- Serial3 (Tx PC.10, Rx PC.11)
-- Serial4 (Tx ??, Rx ??)
-- Serial5 (Tx ??, Rx ??)


function App:setup()
    Serial1:begin(115200)
--    self.serial = Serial1
end

function App:loop()
    self:println(78, BIN) -- gives "1001110"
    self:println(78, OCT) -- gives "116"
    self:println(78, DEC) -- gives "78"
    self:println(78, HEX) -- gives "4E"
    self:println(1.23456, 0) -- gives "1"
    self:println(1.23456, 2) -- gives "1.23"
    self:println(1.23456, 4) -- gives "1.2346"
    delay(1000)     -- wait for a second
end

app = App:new("Serial communication")
app:run()

