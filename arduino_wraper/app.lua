
--function class()
--    local cls = {}
--    cls.__index = cls
--    return setmetatable(cls, {__call = function (c, ...)
--        instance = setmetatable({}, cls)
--        if cls.__init then
--            cls.__init(instance, ...)
--        end
--        return instance
--    end})
--end

Class = {}

function Class:new(super)
    local class, metatable, properties = {}, {}, {}
    class.metatable = metatable
    class.properties = properties

    function metatable:__index(key)
        local prop = properties[key]
        if prop then
            return prop.get(self)
        elseif class[key] ~= nil then
            return class[key]
        elseif super then
            return super.metatable.__index(self, key)
        else
            return nil
        end
    end

    function metatable:__newindex(key, value)
        local prop = properties[key]
        if prop then
            return prop.set(self, value)
        elseif super then
            return super.metatable.__newindex(self, key, value)
        else
            rawset(self, key, value)
        end
    end

    function class:new(...)
        local obj = setmetatable({}, self.metatable)
        if obj.__new then
            obj:__new(...)
        end
        return obj
    end

    return class
end

App = Class:new()

function App:__new(name)
    -- for debuging
    self.name = name
end

function App:setup()
    print("setup")
end

function App:loop()
    print("loop")
end

function App:run()
    print("run")
    self:setup()
    while true do
        self:loop()
    end
end


app = App:new("Main")


--function App:loop()
--    print("loop2")
--end


--function App:setup()
--    print("setup2")
--end


app:run()

