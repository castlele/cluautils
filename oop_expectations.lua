local memory = require("cluautils.memory")

---@class BaseClass
local BaseClass = {}

--- creates new instances + copies metamethods
---@param name string
---@param ... any
---TODO: Rename
function BaseClass:new(name, ...)
   local function copyObject(target, destination)
      destination = destination or {}
      local result = {}

      for key, value in pairs(target) do
         if not result[key] then
            if type(value) == "table" then
               result[key] = copyObject(value)
            else
               result[key] = value
            end
         end
      end

      return result
   end

   ---@type BaseClass
   local this = copyObject(self, {})
   -- this.__name = name or self.__name or "CObject"
   local mt = {}

   -- mt.__call = newObject

   setmetatable(this, mt)

   return this
end

---@return Self
---TODO: This should be renamed to new. Its main goal should be to init fields aka create an instance of the class
function BaseClass:init(...)
   local this = self:new("")

   return this
end

---@return string
function BaseClass:toString()
   return "BaseClass:" .. memory.get(self)
end

---@param name string
---@return any
function BaseClass:createChild(name)
   -- Creates a copy of the base class with name
   return self:new(name)
end

---@param interface BaseClass
function BaseClass:implement(interface)
   local function copyObject(target, destination)
      for key, value in pairs(target) do
         if BaseClass[key] == nil then
            assert(destination[key] == nil, "Object '" .. destination:toString() .. "', got field: " .. key)

            if type(value) == "table" then
               copyObject(value, self)
            else
               destination[key] = value
            end
         end
      end
   end

   copyObject(interface, self)

   return self
end


---TODO: Have to be some assert on amount of inherited classes
---TODO: Pointer to parent class?
local AncestorClass = BaseClass:createChild("AncestorClass"):init()
local Interface = BaseClass:createChild("Interface")

function Interface:log()
   assert(false, "Calling log from Interface")
end

function AncestorClass:sayHello()
   print("Hello, " .. self:toString())
end

function AncestorClass:toString()
   return "AncestorClass:" .. memory.get(self)
end

local SecondAncestor = AncestorClass
   :createChild("SecondAncestor")
   :implement(Interface)
   :init()

function SecondAncestor:toString()
   return "SecondAncestor:" .. memory.get(self)
end

function SecondAncestor:log()
   print("Loggin from " .. self:toString())
end

print(BaseClass:toString())
print(AncestorClass:toString())
AncestorClass:sayHello()
print(SecondAncestor:toString())
SecondAncestor:sayHello()

SecondAncestor:log()
