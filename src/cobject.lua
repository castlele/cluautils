local memory = require("cluautils.memory")

---@class CObject
---@field protected __name string
local CObject = {}


---@param obj CObject
---@param name string?
---@param ... any
---@return CObject
local function newObject(obj, name, ...)
   return obj:new(name, ...)
end

---@param obj table?
---@param name string?
---@return CObject
function CObject:extend(obj, name)
   ---@param target CObject
   ---@param destination? CObject
   ---@return CObject
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

   local this = copyObject(self, obj)
   this.__name = name or self.__name or "CObject"
   local mt = {}

   mt.__call = newObject

   setmetatable(this, mt)

   return this
end

---@param ... any
function CObject:init(...) end

---@param name string?
---@param ... any
---@return CObject
function CObject:new(name, ...)
   ---@type CObject
   local this = self:extend({}, name)

   if this.init then
      this:init(...)
   end

   return this
end

---@param other CObject
---@return boolean
function CObject:isInstance(other)
   return memory.get(self) == memory.get(other)
end

---@return string
function CObject:toString()
   return self.__name .. ":" .. memory.get(self)
end


return setmetatable(CObject, {
   __call = newObject,
})
