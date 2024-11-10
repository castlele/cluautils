---@class Range
---@field start number
---@field stop number
---@field step number
local Range = {}


---@param start number
---@param stop number
---@param step number
---@return Range
function Range:new(start, stop, step)
   ---@type Range
   local this = {
      start = start,
      stop = stop,
      step = step,
   }

   setmetatable(this, self)

   self.__index = self

   return this
end


return setmetatable({}, {
   __call = Range.new,
   __index = Range,
})
