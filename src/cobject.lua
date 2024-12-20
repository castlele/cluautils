local memory = require("cluautils.memory")

---@class CObject
---@field protected __uuid string
local CObject = {}


---@param obj CObject
---@param ... any
---@return CObject
local function newObject(obj, ...)
   return obj:new(...)
end

---@param obj? table
---@return CObject
function CObject:extend(obj)

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
   local mt = {}

   mt.__call = newObject

   setmetatable(this, mt)

   return this
end

---@param ... any
function CObject:init(...) end

---@param ... any
---@return CObject
function CObject:new(...)
   ---@type CObject
   local this = self:extend({})

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


return setmetatable(CObject, {
   __call = newObject,
})
