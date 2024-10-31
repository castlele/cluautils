---@class LinkedList
---@field private rootNode ListNode?
---@field private tailNode ListNode?
local linkedList = {}

---@class ListNode
---@field value any
---@field next ListNode?
---@field parent ListNode?
local node = {}


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
         root = node:new(value)
         prev = root
      else
         current = node:new(value)
         current.parent = prev
         prev.next = current
         prev = current
      end
   end

   return root, current
end


---@param default table?
---@return LinkedList
function linkedList:new(default)
   local rootNode, tailNode = wrapIntoNodeChain(default)

   ---@type LinkedList
   local this = {
      rootNode = rootNode,
      tailNode = tailNode,
   }

   setmetatable(this, self)

   self.__index = self

   return this
end

---TODO: Optimaze with private property
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


return setmetatable({}, {
   __call = function (_, default) return linkedList:new(default) end,
   __index = linkedList,
})
