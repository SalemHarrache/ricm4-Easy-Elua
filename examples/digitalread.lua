-- DigitalReadSerial
-- Reads a digital input on pin PA0 (B1 user), prints the result to the serial
-- monitor
require("arduino_wraper")

-- the setup routine runs once when you press reset
function App:setup()
    Serial1:begin(115200)-- initialize serial com at 115200 bits per second
    pinMode(USER_BTN, INPUT) -- Initialize the digital pin as an output.
end

function App:loop()
    buttonState = digitalRead(USER_BTN) -- read the input pin
    Serial1:println(buttonState)-- print out the state of the button
end

app = App:new("DigitalRead Serial")
app:run()

