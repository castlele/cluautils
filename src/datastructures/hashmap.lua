require("src.table_utils.table_utils")

---@class HashTable
---@field private storage table
local hashTable = {}


---@param predefinedValues table?
---@return HashTable
function hashTable:new(predefinedValues)
   ---@type HashTable
   local this = {
      storage = {},
   }

   if predefinedValues then
      this.storage = table.map(
         predefinedValues,
         function (item) return item end
      )
   end

   setmetatable(this, self)

   self.__index = self

   return this
end

---@return boolean
function hashTable:isEmpty()
   return table.is_empty(self.storage)
end


return hashTable
