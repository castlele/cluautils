---@param value any
---@return boolean
function table:contains(value)
    if table.is_empty(self) then
        return false
    end

    for _, _value in pairs(self) do
        if _value == value then
            return true
        end
    end

    return false
end

---@return boolean
function table:is_empty()
    return #self == 0
end

---@param value any
---@return integer?
function table:get_index(value)
    local index = 1

    for _, _value in pairs(self) do
        if _value == value then
            return index
        end

        index = index + 1
    end

    return nil
end

---@param other_table table
---@return boolean
function table:is_equal(other_table)
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

---@param other_table table
---@param element_condition? fun(any):boolean
---@return table
function table:concat_tables(other_table, element_condition)
    local always_true_fun = function () return true end
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
---@param callback fun(element: T):boolean
---@return table
function table:filter(callback)
    local result = {}

    for _, value in pairs(self) do
        if callback(value) then
            table.insert(result, value)
        end
    end

    return result
end

---@generic T, U
---@param callback fun(item: T): U
---@return table
function table:map(callback)
    local result = {}

    for _, value in pairs(self) do
        table.insert(result, callback(value))
    end

    return result
end

---@generic K, V, U
---@param callback fun(key: K, value: V): U
---@return table
function table:mapkv(callback)
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
function table.alloc(size, defaultValue)
   local t = {}

   for i = 1, size do
      t[i] = defaultValue
   end

   return t
end

---@param t table
---@param comparator (fun(lhs: T, rhs: T): boolean)?
---@return table
function table.min_sort(t, comparator)
   local comp = comparator or function (lhs, rhs) return lhs > rhs end
   local res = t

   for i = 1, #res, 1 do
      local min = i

      for j = i + 1, #res, 1 do
         if comp(res[min], res[j]) then
            min = j
         end
      end

      res[min], res[i] = res[i], res[min]
   end

   return res
end
