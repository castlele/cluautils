---@class Tests
---@field describe fun(label: string, func: function)
---@field it fun(name: string, func: function)
---@field expect fun(condition: boolean, message: string?)
local tests = {}

---@enum ColorTable
local colorTable = {
   RED = 31,
   YELLOW = 33,
   GREEN = 32,
}


---@param color ColorTable
---@param str string
---@return string
local function colorString(color, str)
  return string.format(
      "%s[%sm%s%s[%sm",
      string.char(27),
      color,
      str,
      string.char(27),
      0
   )
end

---@param str string
---@param symbol string
---@return string
local function wrapWith(str, symbol)
   return symbol .. str .. symbol
end


tests.describe = function(label, func)
   print(colorString(colorTable.YELLOW, "Test cases: " .. wrapWith(label, "'")))
   func()
end

tests.it = function(name, func)
   print("Test  " .. wrapWith(name, "'"))

   local isSuccess = xpcall(func, function (msg)
      print(msg)
   end)

   if isSuccess then
      print(colorString(colorTable.GREEN, "Test " .. wrapWith(name, "'") .. " passed"))
   else
      print(colorString(colorTable.RED, "Test " .. wrapWith(name, "'") .. " failed"))
   end
end

tests.expect = function(condition, message)
   if not condition then
      error(message)
   end
end


return tests
