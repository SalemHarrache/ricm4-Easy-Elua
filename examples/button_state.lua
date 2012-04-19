-- Controle App with button example
-- State change detection (edge detection)
-- Often, you don't need to know the state of a digital input all the time,
-- but you just need to know when the input changes from one state to another.
-- For example, you want to know when a button goes from OFF to ON.  This is
-- called state change detection, or edge detection.

-- This example shows how to detect when a button or button changes from off
-- to on and on to off.
require("arduino_wraper")


function App:setup()
    self.ledPin = RED_LED -- Pin PD_13 has a LED connected
    self.buttonPin = USER_BTN

    self.buttonPushCounter = 0   -- counter for the number of button presses
    self.buttonState = 0         -- current state of the button
    self.lastButtonState = 0     -- previous state of the button

    pinMode(self.ledPin, OUTPUT) -- Initialize the digital pin as an output.
end

function App:loop()
    -- read the pushbutton input pin:
    self.buttonState = digitalRead(self.buttonPin)

    -- compare the buttonState to its previous state
    if (self.buttonState ~= self.lastButtonState) then
        -- if the state has changed, increment the counter
        if self.buttonState == HIGH then
            -- if the current state is HIGH then the button
            -- wend from off to on:
            self.buttonPushCounter = self.buttonPushCounter + 1
            self:println("on");
            self:print("number of button pushes:  ")
            self:println(self.buttonPushCounter)
        else
            -- if the current state is LOW then the button
            -- wend from on to off:
            self:println("off")
        end
    end

    -- save the current state as the last state,
    -- for next time through the loop
    self.lastButtonState = self.buttonState;


    --turns on the LED every four button pushes by
    --checking the modulo of the button push counter.
    --the modulo function gives you the remainder of
    --the division of two numbers:
    if mod(self.buttonPushCounter,4) == 0 then
        digitalWrite(self.ledPin, HIGH)
    else
        digitalWrite(self.ledPin, LOW)
    end
    delay(10)
end

app = App:new("Button State Change")
app:run()

