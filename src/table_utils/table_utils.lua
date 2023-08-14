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
