require("cluautils.string_utils")
JSON = require("JSON")

---@MARK - API

Json = {}

---@param str string
---@return table?
function Json.decode(str)
    str = str:match("%b[]") or str:match("%b{}")

    if str == nil then
        return nil
    end

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
