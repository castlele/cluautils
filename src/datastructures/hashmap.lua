require("cluautils.table_utils")

---@class HashMap
---@field private storage table
---@field private hashFunction fun(item: any): integer
local hashTable = {}


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
---@param storage integer?
---@param hashFunction (fun(item: any): integer)?
---@return HashMap
function hashTable:new(predefinedValues, storage, hashFunction)
   storage = storage or 100

   ---@type HashMap
   local this = {
      storage = {},
      hashFunction = hashFunction or simpleHashFunction,
   }

   if predefinedValues then
      table.foreach(predefinedValues, function (key, value)
         local index = this.hashFunction(key)

         -- WARN: This zero allocation will be removed after changing lua table to linked list
         if #this.storage < index then
            this.storage = table.alloc(index, 0)
         end

         this.storage[index] = value
      end)
   end

   setmetatable(this, self)

   self.__index = self

   return this
end

---@return boolean
function hashTable:isEmpty()
   return table.is_empty(self.storage)
end

---@param key any
---@param value any
function hashTable:put(key, value)
   local index = self.hashFunction(key)

   -- WARN: This zero allocation will be removed after changing lua table to linked list
   if #self.storage < index then
      self.storage = table.alloc(index, 0)
   end

   self.storage[index] = value
end

---@param key any
---@return any?
function hashTable:get(key)
   local index = self.hashFunction(key)

   return self.storage[index]
end

---@param key any
---@return boolean
function hashTable:remove(key)
   local index = self.hashFunction(key)
   local value = self.storage[index]

   if value then
      self.storage[index] = nil

      return true
   end

   return false
end


return setmetatable({}, {
   __call = hashTable.new,
   __index = hashTable,
})
