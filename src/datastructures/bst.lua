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

---@return fun(): T?
function BST:traverseInOrder()
   -- ---@type BinaryTreeNode
   -- local currentNode = self.root
   -- local currentState = "l"
   --
   -- while currentNode and currentNode.left do
   --    currentNode = currentNode.left
   -- end
   --
   -- return function ()
   --    if not currentNode then
   --       return nil
   --    end
   --
   --    local copy = currentNode
   --
   --    if currentState == "l" and currentNode.right then
   --       currentNode = currentNode.right
   --       currentState = "r"
   --    else
   --       currentNode = currentNode.parent
   --       currentState = "l"
   --    end
   --
   --    return copy
   -- end
end


---@private
---@param prevNode BinaryTreeNode<T>
---@param currentNode BinaryTreeNode<T>
---@param value T
function BST:insertRecursively(prevNode, currentNode, value)
   if not currentNode then
      local newNode = TreeNode(value)

      newNode.parent = prevNode

      if prevNode.value <= value then
         prevNode.left = newNode
      elseif prevNode.value > value then
         prevNode.right = newNode
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
