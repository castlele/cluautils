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
