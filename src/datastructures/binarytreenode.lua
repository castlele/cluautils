---@class BinaryTreeNode<T>
---@field value T
---@field left BinaryTreeNode<T>
---@field right BinaryTreeNode<T>
local TreeNode = {}


---@param value T
---@return BinaryTreeNode<T>
function TreeNode:new(value)
   local this = {
      value = value,
   }

   setmetatable(this, self)

   self.__index = self

   return this
end


return setmetatable({}, {
   __call = TreeNode.new,
   __index = TreeNode
})
