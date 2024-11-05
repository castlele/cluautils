require("cluautils.table_utils")

---@class HashMap
---@field private length integer
---@field private storage table
---@field private hashFunction fun(item: any): integer
local HashMap = {}


---@param item any
---@return integer
local function simpleHashFunction(item)
   if tostring(item) then
      return #item % 5
   end

   if tonumber(item) then
      return item % 5
   end

   return #item % 5
end


---@param predefinedValues table?
---@param capacity integer?
---@param hashFunction (fun(item: any): integer)?
---@return HashMap
function HashMap:new(predefinedValues, capacity, hashFunction)
   capacity = capacity

   ---@type HashMap
   local this = {
      length = capacity or 0,
      storage = {},
      hashFunction = hashFunction or simpleHashFunction,
   }

   setmetatable(this, self)

   if predefinedValues then
      for key, value in pairs(predefinedValues) do
         this:put(key, value)
      end
   end

   self.__index = self

   return this
end

---@return boolean
function HashMap:isEmpty()
   return self.length == 0
end

---@param key any
---@param value any
function HashMap:put(key, value)
   local index = self.hashFunction(key)

   self.storage[index] = value
   self.length = self.length + 1
end

---@param key any
---@return any?
function HashMap:get(key)
   local index = self.hashFunction(key)

   return self.storage[index]
end

---@param key any
---@return boolean
function HashMap:remove(key)
   local index = self.hashFunction(key)
   local value = self.storage[index]

   if value then
      self.storage[index] = nil
      self.length = self.length - 1

      return true
   end

   return false
end


return setmetatable({}, {
   __call = HashMap.new,
   __index = HashMap,
})
