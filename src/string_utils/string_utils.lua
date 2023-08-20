require("cluautils.table_utils")

---@MARK - Constants

local start_line_pattern = "^(.-)"
local end_line_pattern = "(.*)$"

---@MARK - API

---@return boolean
function string:is_empty()
    return #self == 0
end

function string:trimr()
    return string.gsub(self, "%s+$", "")
end

function string:triml()
    return string.gsub(self, "^%s+", "")
end

function string:trim()
    return self:trimr():triml()
end

---@param sep string
---@return table
function string:split(sep)
    if #self == 0 or #sep == 0 then
        return {self}
    end

    local matched = self:match(start_line_pattern .. sep)

    if matched == nil then
        return {self}
    end

    local result = {}

    if matched ~= "" then
        table.insert(result, matched)
    end

    return table.concat_tables(result, self:match(sep .. end_line_pattern):split(sep), function (splitted_string)
        return not splitted_string:is_empty()
    end)
end

