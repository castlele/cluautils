---@class BinarySearchTree
local BST = {}


---@return BinarySearchTree
function BST:new()
   ---@type BinarySearchTree
   local this = {}

   setmetatable(this, self)

   self.__index = self

   return this
end

---@return boolean
function BST:isEmpty()
   return true
end


return setmetatable({}, {
   __call = BST.new,
   __index = BST,
})
