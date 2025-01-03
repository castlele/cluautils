local M = {}

---@param self table
---@param value any
---@return boolean
function M.contains(self, value)
   if M.is_empty(self) then
      return false
   end

   for _, _value in pairs(self) do
      if _value == value then
         return true
      end
   end

   return false
end

---@param self table
---@return boolean
function M.is_empty(self)
   return #self == 0
end

---@param value any
---@param self table
---@return integer?
function M.get_index(self, value)
   local index = 1

   for _, _value in pairs(self) do
      if _value == value then
         return index
      end

      index = index + 1
   end

   return nil
end

---@param self table
---@param other_table table
---@return boolean
function M.is_equal(self, other_table)
   if #self ~= #other_table then
      return false
   end

   for key, value in pairs(self) do
      if other_table[key] ~= value then
         return false
      end
   end

   return true
end

---@param self table
---@param other_table table
---@param element_condition? fun(any):boolean
---@return table
function M.concat_tables(self, other_table, element_condition)
   local always_true_fun = function()
      return true
   end
   element_condition = element_condition or always_true_fun

   local final_result = {}

   for _, value in pairs(self) do
      if element_condition(value) then
         table.insert(final_result, value)
      end
   end

   for _, value in pairs(other_table) do
      if element_condition(value) then
         table.insert(final_result, value)
      end
   end

   return final_result
end

---@generic T
---@param self table
---@param callback fun(element: T):boolean
---@return table
function M.filter(self, callback)
   local result = {}

   for _, value in pairs(self) do
      if callback(value) then
         table.insert(result, value)
      end
   end

   return result
end

---@generic T, U
---@param self table
---@param callback fun(item: T): U
---@return table
function M.map(self, callback)
   local result = {}

   for _, value in pairs(self) do
      table.insert(result, callback(value))
   end

   return result
end

---@generic K, V, U
---@param self table
---@param callback fun(key: K, value: V): U
---@return table
function M.mapkv(self, callback)
   local t = {}

   for key, value in pairs(self) do
      table.insert(t, callback(key, value))
   end

   return t
end

---@generic T
---@param size integer
---@param defaultValue T
---@return table<T>
function M.alloc(size, defaultValue)
   local t = {}

   for i = 1, size do
      t[i] = defaultValue
   end

   return t
end

---@param self table
---@return string
function M.toString(self)
   local json = require("cluautils.json")

   return json.encode(self, {
      pretty = true,
      indent = "    ",
   })
end

return M
