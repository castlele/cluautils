---@alias T any
---@class Pair<T>
---@field left T
---@field right T
local Pair = {}

---@param left T
---@param right T
---@return Pair<T>
function Pair:new(left, right)
   local this = {
      left = left,
      right = right,
   }

   setmetatable(this, self)

   self.__index = self

   return this
end

return setmetatable({}, {
   __call = Pair.new,
   __index = Pair,
})
