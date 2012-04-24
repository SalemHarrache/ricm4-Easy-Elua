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
    Serial2:begin(115200)
end

function App:loop()
    Serial1:print("1")
    Serial2:println("2")
    delay(1000)     -- wait for a second
end

app = App:new("Serial communication")
app:run()

