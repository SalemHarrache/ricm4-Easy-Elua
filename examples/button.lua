-- Controle App with button example
-- Button
-- Turns on and off a light emitting diode(RED_LED), when
-- pressing a pushbutton B1.
require("arduino_wrapper")


function App:setup()
    self.ledpin = RED_LED -- Pin PD_13 has a LED connected
    pinMode(self.ledpin, OUTPUT) -- Initialize the digital pin as an output.

    self.blink = false
    self:blink_toggle()
end

function App:loop()
    if self:btn_pressed() then
        self.blink = not self.blink
        self:blink_toggle()
    end
    delay(10)
end

function App:blink_toggle()
    if self.blink then
        self:print("ON-")
        digitalWrite(self.ledpin, HIGH)
    else
        self:print("OFF-")
        digitalWrite(self.ledpin, LOW)
    end
    delay(1000)
end

app = App:new("Button Controle : ")
app:run()

