--  Blink without Delay
--  Turns on an LED on for one second, then off for one second, repeatedly
--  without using the delay() function. This means that other code can run at
--  the same time without being interrupted by the LED code.
require("arduino_wraper")

function App:setup()
    self.ledpin = ORANGE_LED -- Pin PD_13 has a LED connected
    pinMode(self.ledpin, OUTPUT) -- Initialize the digital pin as an output.

    self.ledState = LOW  -- ledState used to set the LED
    self.currentMillis = 0 -- will store current time
    self.previousMillis = 0 -- will store last time LED was updated
    self.interval = 1000 -- interval at which to blink (milliseconds)
end

function App:loop()
    --check to see if it's time to blink the LED; that is, if the difference
    --between the current time and last time you blinked the LED is bigger
    --than the interval at which you want to blink the LED.
    self.currentMillis = self:millis()
    if (self.currentMillis - self.previousMillis > self.interval) then
        self.previousMillis = self.currentMillis
        if (self.ledState == LOW) then
            self.ledState = HIGH;
        else
            self.ledState = LOW;
        end
        digitalWrite(self.ledpin, self.ledState)
    end
end

app = App:new("Blink led without delay")
app:run()

