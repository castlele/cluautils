local CObject = require("cluautils.cobject")
---@class CollectionInterface : CObject
local Collection = CObject()

---@param msg string
local function fatalError(msg)
   assert(false, msg)
end


---@param obj table?
---@param name string?
---@return CollectionInterface
function Collection:extend(obj, name)
   ---@type CollectionInterface
   ---@diagnostic disable-next-line
   local collection = CObject.extend(self, obj, name or "CollectionInterface")

   return collection
end

---@param ... any
---@diagnostic disable-next-line
function Collection:init(...)
   fatalError("Collection's 'init' method should be called only from ancestors")
end

---@return boolean
function Collection:isEmpty()
   fatalError("Collection's 'isEmpty' method should be called only from ancestors")
   return false
end

---@return integer
function Collection:len()
   fatalError("Collection's 'len' method should be called only from ancestors")
   return -1
end

---@return table
function Collection:toTable()
   fatalError("Collection's 'toTable' method should be called only from ancestors")
   return {}
end


return Collection
