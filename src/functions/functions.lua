local M = {}
local exports = {}


---@class Value<T>
---@field value T
local Value = {}

---@param self Value
---@return any
function Value.__call(self)
   return self.value
end


---@class NumberValue: Value<number>
local NumberValue = {}

---@param self NumberValue
---@return number
function NumberValue.__call(self)
   return self.value
end

setmetatable(NumberValue, { __index = Value })


---@class StringValue<string>
---@field value string
local StringValue = {}

---@param self StringValue
---@return string
function StringValue.__call(self)
   return self.value
end

setmetatable(StringValue, { __index = Value })


---@generic T
---@generic U: Value
---@param callback fun(value: T): U
---@return U
function Value:let(callback)
   self.value = callback(self.value)

   return self
end

---@generic T
---@generic U
---@param value T
---@param callback fun(value: T): U
---@return U
function exports.let(value, callback)
   if not value then
      return nil
   end

   local this = {}
   setmetatable(this, {
      __index = Value,
      __call = Value.__call,
   })

   this.value = callback(value)

   return this
end


for name, exportedFunc in pairs(exports) do
   M[name] = exportedFunc
end

return M
