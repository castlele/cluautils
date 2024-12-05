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
      root = nil,
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
   else

      if self.root.value < value then
         self:insertRecursively(self.root, self.root.right, value)
      else
         self:insertRecursively(self.root, self.root.left, value)
      end
   end

   self.lenght = self.lenght + 1
end

---@private
---@param node BinaryTreeNode?
function BST:getNextInOrder(node)
   local currentNode = node

   if currentNode then
      if currentNode.left then
         self:getNextInOrder(currentNode.left)
      end

      coroutine.yield(currentNode)

      if currentNode.right then
         self:getNextInOrder(currentNode.right)
      end
   else
      coroutine.yield(nil)
   end

end

---@return fun(): T?
function BST:traverseInOrder()
   -- ---@type BinaryTreeNode
   local currentNode = self.root
   -- local currentState = "l"
   --
   -- while currentNode and currentNode.left do
   --    currentNode = currentNode.left
   -- end
   --
   local thread = coroutine.create(self.getNextInOrder)

   return function ()


      local _, node = coroutine.resume(thread, self, currentNode)

      currentNode = node

      if node then
         return node.value
      end

      return nil
   end
end


---@private
---@param prevNode BinaryTreeNode[T]
---@param currentNode BinaryTreeNode[T]
---@param value T
function BST:insertRecursively(prevNode, currentNode, value)
   if not currentNode then
      local newNode = TreeNode(value)

      newNode.parent = prevNode

      if prevNode.value <= value then
         prevNode.right = newNode
      elseif prevNode.value > value then
         prevNode.left = newNode
      end

      return
   end

   if currentNode.value <= value then
      self:insertRecursively(currentNode, currentNode.right, value)
   elseif currentNode.value > value then
      self:insertRecursively(currentNode, currentNode.left, value)
   end
end


return setmetatable({}, {
   __call = BST.new,
   __index = BST,
})
