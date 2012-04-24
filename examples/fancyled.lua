-- FancyLED
require("arduino_wrapper")

blink_toggle = function(value)
    digitalWrite(GREEN_LED, value)
    delay(1000)
    digitalWrite(ORANGE_LED, value)
    delay(1000)
    digitalWrite(RED_LED, value)
    delay(1000)
    digitalWrite(BLUE_LED, value)
    delay(1000)
end

function App:setup()
    pinMode(RED_LED, OUTPUT) -- Initialize the digital pin as an output.
    pinMode(ORANGE_LED, OUTPUT)
    pinMode(BLUE_LED, OUTPUT)
    pinMode(GREEN_LED, OUTPUT)

end

function App:loop()
    blink_toggle(HIGH)
    blink_toggle(LOW)
end

app = App:new("Fancy Blink Led")
app:run()

