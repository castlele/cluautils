local TreeNode = require("src.datastructures.binarytreenode")

---@class BinarySearchTree<T>
---@field root BinaryTreeNode<T>?
---@field lenght integer
local BST = {}


---@param default table<T>
---@return BinarySearchTree<T>
function BST:new(default)
   ---@type BinarySearchTree
   local this = {
      lenght = 0,
   }

   setmetatable(this, self)

   self.__index = self

   for _, value in ipairs(default or {}) do
      this:insert(value)
   end

   return this
end

---@return integer
function BST:len()
   return self.lenght
end

---@return boolean
function BST:isEmpty()
   return self:len() == 0
end

---@param value T
function BST:insert(value)
   if self.root == nil then
      self.root = TreeNode(value)
   end

   self.lenght = self.lenght + 1
end


---@private
---@param prevNode BinaryTreeNode<T>
---@param currentNode BinaryTreeNode<T>
---@param value T
function BST:insertRecursively(prevNode, currentNode, value)
   if not currentNode then
      if prevNode.value <= value then
         prevNode.left = TreeNode(value)
      elseif prevNode.value > value then
         prevNode.right = TreeNode(value)
      end

      return
   end

   if currentNode.value <= value then
      self:insertRecursively(currentNode, currentNode.left, value)
   elseif currentNode.value > value then
      self:insertRecursively(currentNode, currentNode.right, value)
   end
end


return setmetatable({}, {
   __call = BST.new,
   __index = BST,
})
