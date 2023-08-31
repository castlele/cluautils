require("cluautils.string_utils")
JSON = require("JSON")

---@MARK - API

Json = {}

---@enum JsonType
JsonType = {
    ARRAY = "%b[]",
    DICTIONARY = "%b{}"
}

---@param str string
---@param outer_type JsonType?
---@return table?
function Json.decode(str, outer_type)
    local s, e = str:find(outer_type or JsonType.DICTIONARY, nil, false)

    if s == nil then
        return nil
    end

    str = str:sub(s, e)

    local decoded_obj = JSON:decode(str)

    if type(decoded_obj) ~= "table" then
        return nil
    end

    return decoded_obj
end

---@class encode_options
---@field pretty boolean
---@field indent string
---
---@param obj table
---@param options encode_options
---@return string?
function Json.encode(obj, options)
    local encoded_obj = JSON:encode(obj, nil, options)

    if encoded_obj == "[]" then
        options = options or {}

        if options.pretty then return "{\n}" else return "{}" end
    end

    return encoded_obj
end

return Json
