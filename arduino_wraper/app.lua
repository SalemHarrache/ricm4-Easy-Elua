
App = {}
App.__index = App

function App:init(name)
   self.name = name
   return self
end

function App.setup()
    return
end

function App.setup()
    print (self.name)
end

function App:run()
    self.setup()
end

-- create and use an App
application = App:init("New app")

application:run()



--A = class()
--function A:init(x)
--  self.t = 0
--  self.x = x
--end


--function GameNetwork:init(desiredMode)
--	self.mode = desiredMode
--	if desiredMode == "papaya" then
--		gameNetwork.init("papaya", "SecretCodez")
--	elseif desiredMode == "openfeint" then
--		gameNetwork.init("openfeint",
--					"SecretCodez",
--					"SecretCodez",
--					"Game Title",
--					"SecretCodez")
--	else
--		print("Unknown mode.")
--		return false
--	end
--end

