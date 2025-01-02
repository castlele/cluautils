local M = {}

local start_line_pattern = "^(.-)"
local end_line_pattern = "(.*)$"

---@param str string
---@return boolean
function M.isEmpty(str)
   return #str == 0
end

---@param str string
---@return string
function M.trimr(str)
   local result = string.gsub(str, "%s+$", "")

   return result
end

---@param str string
---@return string
function M.triml(str)
   local result = string.gsub(str, "^%s+", "")
   return result
end

---@param str string
---@return string
function M.trim(str)
   return M.triml(M.trimr(str))
end

---@param str string
---@param sep string
---@return table
function M.split(str, sep)
   if #str == 0 or #sep == 0 then
      return { str }
   end

   local matched = str:match(start_line_pattern .. sep)

   if matched == nil then
      return { str }
   end

   local result = {}

   if matched ~= "" then
      table.insert(result, matched)
   end

   for _, splittedStr in ipairs(M.split(str:match(sep .. end_line_pattern), sep)) do
      if not M.isEmpty(splittedStr) then
         table.insert(result, splittedStr)
      end
   end

   return result
end

---@param str string
---@return boolean
function M.isNilOrEmpty(str)
   if not str then
      return true
   end

   return M.isEmpty(str)
end

return M
