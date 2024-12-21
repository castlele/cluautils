require("cluautils.table_utils")
local CollectionInterface = require("cluautils.collections.collection_inteface")
local LinkedList = require("cluautils.collections.linkedlist")
local Pair = require("cluautils.collections.pair")

---@class HashMap
---@field private length integer
---@field private storage table|LinkedList
---@field private hashFunction fun(item: any): integer
---@diagnostic disable-next-line
local HashMap = CollectionInterface:extend()
---
---@param obj table?
---@param name string?
---@return HashMap
function HashMap:extend(obj, name)
   ---@type HashMap
   ---@diagnostic disable-next-line
   local map = CollectionInterface.extend(self, obj, name or "HashMap")

   return map
end


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
function HashMap:init(predefinedValues, capacity, hashFunction)
   self.length = capacity or 0
   self.storage = {}
   self.hashFunction = hashFunction or simpleHashFunction

   if predefinedValues then
      for key, value in pairs(predefinedValues) do
         self:put(key, value)
      end
   end
end

---@return integer
function HashMap:len()
   return self.length
end

---@return boolean
function HashMap:isEmpty()
   return self.length == 0
end

---@param key any
---@param value any
function HashMap:put(key, value)
   local index = self.hashFunction(key)
   local existingValue = self.storage[index]

   if not existingValue or existingValue.left == key then
      self.storage[index] = Pair(key, value)
      self.length = self.length + 1
      return
   end

   if existingValue == value then
      return
   end

   if existingValue.__type == "LinkedList" then
      existingValue:append(Pair(key, value))
      return
   end

   self.storage[index] = LinkedList({
      existingValue,
      Pair(key, value),
   })
end

---@param key any
---@return any?
function HashMap:get(key)
   local index = self.hashFunction(key)

   local value = self.storage[index]

   if value then
      if value.__type == "LinkedList" then
         local pair = value:first(function (item)
            return item.left == key
         end)

         if not pair then
            return nil
         end

         return pair.right
      end

      return value.right
   end

   return nil
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

return HashMap

-- return setmetatable({}, {
--    __call = HashMap.new,
--    __index = HashMap,
-- })
