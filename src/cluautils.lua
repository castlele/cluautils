require("src.string_utils.string_utils")

CUtils = CUtils or {}

---@param object any
function CUtils.is_object(object)
    local metatable = getmetatable(object)

    if object == nil or metatable == nil or type(object) == "string" then
        return false
    end

    for key, _ in pairs(metatable) do
        if key == "__index" then
            return true
        end
    end

    return false
end

---@param str string
---@return boolean
function CUtils.is_string_nil_or_empty(str)
    return str == nil or str:is_empty()
end

return CUtils
