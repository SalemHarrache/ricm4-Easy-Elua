--  Millis test
--  prints time since program started

require("arduino_wraper")

function App:loop()
    print(self.name .. " started since " .. self:millis() .. "us")
    -- wait a second so as not to send massive amounts of data
    delay(1000)
end

app = App:new("MyApp")
app:run()

