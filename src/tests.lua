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
local currentResults = {}


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

   for _, value in pairs(currentResults) do
      if not value then
         print(colorString(colorTable.RED, "Test cases failed: " .. wrapWith(label, "'")))
         return
      end
   end
   print(colorString(colorTable.YELLOW, "Test cases succeeded: " .. wrapWith(label, "'")))
end

tests.it = function(name, func)
   local isSuccess = xpcall(func, function (msg)
      if msg then
         print(msg)
      end
   end)

   if isSuccess then
      print(colorString(colorTable.GREEN, "Test " .. wrapWith(name, "'") .. " passed"))
      currentResults[name] = true
   else
      print(colorString(colorTable.RED, "Test " .. wrapWith(name, "'") .. " failed"))
      currentResults[name] = false
   end
end

tests.expect = function(condition, message)
   if not condition then
      error(message)
   end
end

tests.expectTableEqual = function (expected, actual)
   if type(expected) ~= "table" then
      error("Expected argument is not a table. It's type is " .. wrapWith(type(expected), "'"))
   end

   if type(actual) ~= "table" then
      error("Actual argument is not a table. It's type is " .. wrapWith(type(actual), "'"))
   end

   if #expected ~= #actual then
      local wrappedLenExpected = wrapWith(tostring(#expected), "'")
      local wrappedLenActual = wrapWith(tostring(#actual), "'")

      error(
         "Lenght of the lists isn't equal to each other. Expected: "
         .. wrappedLenExpected
         .. "; Got: "
         .. wrappedLenActual
      )
   end

   for key, value in pairs(expected) do
      if actual[key] ~= value then
         local wrappedKey = wrapWith(key, "'")
         local wrappedExpected = wrapWith(value, "'")
         local wrappedActual = wrapWith(actual[key], "'")

         error(
            "Wrong value for key: "
            .. wrappedKey
            .. ". Expected: "
            .. wrappedExpected
            .. "; Got: "
            .. wrappedActual
         )
      end
   end
end


return tests
