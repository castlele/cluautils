---@class LinkedList
---@field private rootNode ListNode?
local linkedList = {}

---@class ListNode
---@field value any
---@field next ListNode?
---@field parent ListNode?
local node = {}


---@param t table?
---@return ListNode?
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
         root = node:new(value)
         prev = root
      else
         current = node:new(value)
         current.parent = prev
         prev.next = current
         prev = current
      end
   end

   return root
end


---@param default table?
---@return LinkedList
function linkedList:new(default)
   ---@type LinkedList
   local this = {
      rootNode = wrapIntoNodeChain(default),
   }

   setmetatable(this, self)

   self.__index = self

   return this
end

---@return integer
function linkedList:len()
   local len = 0
   local currentNode = self.rootNode

   while currentNode do
      len = len + 1
      currentNode = currentNode.next
   end

   return len
end

function linkedList:isEmpty()
   return self.rootNode == nil
end


---@param value any
---@param next ListNode?
---@return ListNode
function node:new(value, next)
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


return setmetatable(linkedList, {
   __call = linkedList.new,
   __len = function (self) linkedList.len(self) end,
})
