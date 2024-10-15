require("src.tests.base_test_case")
local f = require("src.functions.functions")

FuctionsTestCase = CTestCase

function FuctionsTestCase:test_let_on_optionals_do_nothing()
   ---@type number?
   local optionalValue = nil

   local result = f.let(optionalValue, function (_) return false end)

   return result == nil
end

function FuctionsTestCase:test_let_on_value_executes_callback()
   ---@type number
   local value = 10
   local multiplier = 2
   local expectedValue = value * multiplier
   local callback = function (num)
      return num * multiplier
   end

   local result = f.let(value, callback)()

   return result == expectedValue
end

function FuctionsTestCase:test_let_can_be_chained()
   ---@type number
   local value = 10
   local multiplier = 2
   local expectedValue = value * multiplier * multiplier
   local callback = function (num)
      return num * multiplier
   end

   local result = f.let(value, callback):let(callback)()

   return result == expectedValue
end

FuctionsTestCase:run_tests()
