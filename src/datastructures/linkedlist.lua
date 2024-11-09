---@class ListNode
---@field value any
---@field next ListNode?
---@field parent ListNode?
local Node = {}

---@class LinkedList
---@field private length integer
---@field private rootNode ListNode?
---@field private tailNode ListNode?
local LinkedList = {
   __type = "LinkedList",
}


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

---TODO: This method can be optimized using tailNode
---@param index integer
---@return any?
function LinkedList:get(index)
   local node = self:getNode(index)

   if node then
      return node.value
   end

   return nil
end

---@param callback fun(item: any): boolean
---@return LinkedList
function LinkedList:filter(callback)
   local result = LinkedList:new()

   for _, item in self:valueIterator() do
      if callback(item) then
         result:append(item)
      end
   end

   return result
end

---@generic T, U
---@param callback fun(item: T): U
---@return LinkedList
function LinkedList:map(callback)
   local result = LinkedList:new()

   for _, item in self:valueIterator() do
      result:append(callback(item))
   end

   return result
end

---@param predicate fun(item: any): boolean
---@return any?
function LinkedList:first(predicate)
   for _, item in self:valueIterator() do
      if predicate(item) then
         return item
      end
   end

   return nil
end

---TODO: This method can be optimized using tailNode
---@param item any
---@param index integer
function LinkedList:insert(item, index)
   if not self.rootNode then
      self.rootNode = Node:new(item)
      self.tailNode = self.rootNode
   else
      if self:len() < index then
         local tail = assert(self.tailNode)

         tail.next = Node:new(item)
         tail.next.parent = tail
         self.tailNode = tail.next
      else
         self:recursiveInsert(self.rootNode, 1, item, index)
      end
   end

   self.length = self.length + 1
end

---@param item any
function LinkedList:append(item)
   self:insert(item, self:len() + 1)
end

---TODO: This method can be optimized using tailNode
---@param index integer
---@return any?
function LinkedList:remove(index)
   if index == 1 and self.rootNode then
      local value = self.rootNode.value
      self.rootNode = nil
      self.tailNode = nil
      self.length = self.length - 1

      return value
   end

   if index == self:len() and self.tailNode then
      local value = self.tailNode.value
      self.tailNode.parent.next = nil
      self.tailNode = nil
      self.length = self.length - 1

      return value
   end

   local node = self:getNode(index)

   if not node then
      return nil
   end

   local next = node.next
   local prev = node.parent

   prev.next = next
   next.parent = prev
   self.length = self.length - 1

   return node.value
end

function LinkedList:toTable()
   local result = {}

   for _, value in self:valueIterator() do
      table.insert(result, value)
   end

   return result
end

---@return string
function LinkedList:toString()
   local description = ""
   for index, value in self:valueIterator() do
      local back = ""
      local prevNode = self:getNode(index - 1)

      ---BUG: This part do not work for second elements
      ---Resulting in the one-side relationship between two elements
      ---According to other tests this is actually impossible
      if prevNode and prevNode.next.value == value then
         back = "<"
      end

      description = description .. "{" .. index .. "; " .. value .. "} " .. back .. "-> "
   end

   return description
end

---@private
---@param currentNode ListNode?
---@param nodeIndex integer
---@param item any
---@param itemIndex integer
function LinkedList:recursiveInsert(currentNode, nodeIndex, item, itemIndex)
   if not currentNode then return end

   if nodeIndex + 1 == itemIndex then
      local newNode = Node:new(item)

      newNode.next = currentNode.next
      newNode.parent = currentNode

      currentNode.next = newNode
   end

   self:recursiveInsert(currentNode.next, nodeIndex + 1, item, itemIndex)
end

---@private
---@param index integer
---@return ListNode?
function LinkedList:getNode(index)
   if index > self:len() then
      return nil
   end

   local currentNode = self.rootNode
   local currentIndex = 1

   while currentNode do
      if currentIndex == index then
         break
      end

      currentNode = currentNode.next
      currentIndex = currentIndex + 1
   end

   return currentNode
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
