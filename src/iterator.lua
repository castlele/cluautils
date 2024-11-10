local Range = require("src.range")

---@class Iterator
local Iterator = {}
Iterator.__index = Iterator


local function wrap(gen, param, state)
   return setmetatable({
      gen = gen,
      param = param,
      state = state,
   }, Iterator)
end


---@param range Range
---@return number?, number?
local range_gen = function(range, state)
   local currentState = state + range.step

   if state >= range.stop then
      return nil
   end

   return currentState, currentState
end

local call_if_not_empty = function(fun, state, ...)
   if state == nil then
      return nil
   end
   return state, fun(...)
end


---@param start number
---@param stop number
---@param step number?
---@return Iterator
function Iterator.range(start, stop, step)
   local range = Range(start, stop, step or 1)

   return wrap(range_gen, range, start - (step or 1))
end


---@return any?
function Iterator:next()
   local state = self.gen(self.param, self.state)

   self.state = state

   return state
end

---@param callback fun(item: any)
function Iterator:forEach(callback)
   local state = self.state

   repeat
      state = call_if_not_empty(callback, self.gen(self.param, state))
   until state == nil
end

---@return table
function Iterator:toList()
   local list = {}

   self:forEach(function(item)
      table.insert(list, item)
   end)

   return list
end


return Iterator
