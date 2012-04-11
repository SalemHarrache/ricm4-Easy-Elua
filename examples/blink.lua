--  Blink
--  Turns on an LED on for one second, then off for one second, repeatedly.
--  This example code is in the public domain.
require("arduino_wraper")

function App:setup()
    self.ledpin = self:getPin("PD_13") -- Pin PD_13 has an LED connected
    self:pinMode(self.ledpin, OUTPUT) -- Initialize the digital pin as an output.
end

function App:loop()
    self:digitalWrite(self.ledpin, HIGH)    -- set the LED on
    self:delay( 1000 )                      -- wait for a second
    self:digitalWrite(self.ledpin, LOW)     -- set the LED off
    self:delay( 1000 )                      -- wait for a second
end

app = App:new("Blink led")
app:run()

