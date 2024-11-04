---@class ListNode
---@field value any
---@field next ListNode?
---@field parent ListNode?
local Node = {}

---@class LinkedList
---@filed private length integer
---@field private rootNode ListNode?
---@field private tailNode ListNode?
local LinkedList = {}


---@param t table?
---@return ListNode?, ListNode?
local function wrapIntoNodeChain(t)
   if not t then
      return nil
   end

   ---@type ListNode
   local root = nil
   ---@type ListNode
   local current = nil
   ---@type ListNode
   local prev = nil

   for _, value in pairs(t) do
      if not root then
         root = Node:new(value)
         prev = root
      else
         current = Node:new(value)
         current.parent = prev
         prev.next = current
         prev = current
      end
   end

   return root, current
end

---TODO: Delete if this function is unused
---@param node ListNode?
---@return integer
local function getNodeChainLen(node)
   local len = 0
   local currentNode = node

   while currentNode do
      len = len + 1
      currentNode = currentNode.next
   end

   return len
end


---@param default table?
---@return LinkedList
function LinkedList:new(default)
   local rootNode, tailNode = wrapIntoNodeChain(default)
   local len = 0

   if default then
      len = #default
   end

   print(rootNode)

   ---@type LinkedList
   local this = {
      rootNode = rootNode,
      tailNode = tailNode,
      length = len,
   }

   setmetatable(this, self)

   self.__index = self

   return this
end

function LinkedList:isEmpty()
   return self.rootNode == nil
end

function LinkedList:len()
   return self.length
end

function LinkedList:valueIterator()
   local currentNode = self.rootNode
   local index = 0

   return function ()
      if not currentNode then
         return nil
      end

      local value = currentNode.value

      currentNode = currentNode.next
      index = index + 1

      return index, value
   end
end

---@param item any
---@param index integer
function LinkedList:insert(item, index)
   if not self.rootNode then
      self.rootNode = Node:new(item)
      self.tailNode = self.rootNode
   else
      if self:len() <= index then
         local tail = assert(self.tailNode)

         tail.next = Node:new(item)
         self.tailNode = tail.next
      else
         self:recursiveInsert(self.rootNode, 1, item, index)
      end
   end

   self.length = self.length + 1
end

---@private
function LinkedList:recursiveInsert(currentNode, nodeIndex, item, itemIndex)
   if not currentNode then return end

   if nodeIndex + 1 == itemIndex then
      local next = currentNode.next

      currentNode.next = Node:new(item)
      currentNode.next.next = next
   end

   self:recursiveInsert(currentNode.next, nodeIndex + 1, item, itemIndex)
end


---@param value any
---@param next ListNode?
---@return ListNode
function Node:new(value, next)
   ---@type ListNode
   local this = {
      value = value,
      next = next,
      parent = nil,
   }

   setmetatable(this, self)

   self.__index = self

   return this
end


return setmetatable({}, {
   __call = function (_, default) return LinkedList:new(default) end,
   __index = LinkedList,
})
