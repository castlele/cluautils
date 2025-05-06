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

---@deprecated Use table.concat() instead
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

---@param lhs table
---@param rhs table
---@return table
function M.concat(lhs, rhs)
   local result = lhs

   for k, v in pairs(rhs) do
      result[k] = v
   end

   return result
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

---@param start number
---@param stop number
---@param step number
---@return table<number>
function M.makeRange(start, stop, step)
   local t = {}

   for i = start, stop, step do
      table.insert(t, i)
   end

   return t
end

---@param t table<T>
---@param element T
---@return integer?
function M.binarySearch(t, element)
   if #t == 0 then
      return nil
   end

   local lhs = 1
   local rhs = #t

   if element <= t[lhs] or element >= t[rhs] then
      return nil
   end

   while lhs <= rhs do
      local mid = math.floor(lhs + (rhs - lhs) / 2)

      if element == t[mid] then
         return mid
      end

      if element >= t[mid] then
         lhs = mid + 1
      else
         rhs = mid - 1
      end
   end

   return nil
end

---@param t table<T>
---@param compare (fun(T, T): boolean)?
function M.mergeSort(t, compare)
   local c = compare or function(a, b)
      return a < b
   end

   ---@param l integer
   ---@param r integer
   ---@return table<T>
   local function sub(l, r)
      local res = {}

      for i = l, r do
         table.insert(res, t[i])
      end

      return res
   end

   ---@param l integer
   ---@param m integer
   ---@param r integer
   local function merge(l, m, r)
      local L = sub(l, m)
      local R = sub(m + 1, r)

      local n1 = m - l + 1
      local n2 = r - m

      local i = 1
      local j = 1
      local k = 1

      while i <= n1 and j <= n2 do
         if c(L[i], R[j]) then
            t[k] = L[i]
            i = i + 1
         else
            t[k] = R[j]
            j = j + 1
         end

         k = k + 1
      end

      while i <= n1 do
         t[k] = L[i]
         i = i + 1
         k = k + 1
      end

      while j <= n2 do
         t[k] = R[j]
         j = j + 1
         k = k + 1
      end
   end

   ---@param l integer
   ---@param r integer
   local function sort(l, r)
      if l >= r then
         return
      end

      local m = math.floor(l + (r - l) / 2)

      sort(l, m)
      sort(m + 1, r)
      merge(l, m, r)
   end

   sort(1, #t)
end

return M
