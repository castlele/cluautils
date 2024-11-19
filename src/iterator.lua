local Range = require("src.range")

---@class Iterator
local Iterator = {}
Iterator.__index = Iterator


function Iterator.wrap(gen, param, state)
   return setmetatable({
      gen = gen,
      param = param,
      state = state,
   }, Iterator)
end


---@param range Range
---@return number?, number?
local rangeGen = function(range, state)
   local currentState = state + range.step

   if state >= range.stop then
      return nil
   end

   return currentState, currentState
end

---@class MapParam
---@field gen fun(param: any, state: any): any
---@field param any
---@field callback fun(item: any): any
---@param param MapParam
---@param state any
---@return any?, any?
local function mapGen(param, state)
   local currentState, newState = param.gen(param.param, state)

   if not currentState then
      return nil
   end

   return currentState, param.callback(newState)
end

---@class FilterGen
---@field gen fun(param: any, state: any): any
---@field param any
---@field callback fun(item: any): any
---@param param MapParam
---@param state any
---@return any?, any?
local function filterGen(param, state)
   local result = false
   local currentState, newState

   repeat
      currentState, newState = param.gen(param.param, newState or state)

      if not currentState then
         return nil
      end

      result = param.callback(newState)
   until result

   return currentState, newState
end


---@param start number
---@param stop number
---@param step number?
---@return Iterator
function Iterator.range(start, stop, step)
   local range = Range(start, stop, step or 1)

   return Iterator.wrap(rangeGen, range, start - (step or 1))
end

---@param t table
---@param index integer
---@return any?, any?
local function tableGen(t, index)
   local currentIndex = index + 1

   if currentIndex > #t then
      return nil
   end

   local item = t[currentIndex]

   return item, item
end

---@param t table
---@return Iterator
function Iterator.table(t)
   return Iterator.wrap(tableGen, t, 0)
end


---@return any?
function Iterator:next()
   local state, newstate = self.gen(self.param, self.state)

   self.state = state

   return newstate
end

---@param callback fun(item: any): any
---@return Iterator
function Iterator:map(callback)
   ---@type MapParam
   local param = {
      callback = callback,
      param = self.param,
      gen = self.gen,
   }

   return Iterator.wrap(mapGen, param, self.state)
end

---@param callback fun(item: any): boolean
---@return Iterator
function Iterator:filter(callback)
   ---@type FilterGen
   local param = {
      callback = callback,
      param = self.param,
      gen = self.gen,
   }
   return Iterator.wrap(filterGen, param, self.state)
end

---@param callback fun(item: any)
function Iterator:forEach(callback)
   local state = self.state

   repeat
      local currentState, newState = self.gen(self.param, state)
      state = currentState

      if state then
         callback(newState)
      end
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
