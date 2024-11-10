require("src.table_utils.table_utils")
local Iterator = require("src.iterator")
local t = require("src.tests")

t.describe("Iterator tests", function ()
   t.it("Iterator can be created from range", function ()
      local expectedList = { 1, 2, 3, 4, 5 }
      local sut = Iterator.range(1, 5)

      local result = sut:toList()

      t.expect(table.is_equal(expectedList, result))
   end)

   t.it("Iterator can return next value", function ()
      local expectedList = { 1, 2, 3, 4, 5 }
      local sut = Iterator.range(1, 5)

      local index = 0
      local current = sut:next()

      repeat
         index = index + 1
         local expected = expectedList[index]

         t.expect(
            current == expected,
            "Epected: " .. expected .. " but got: " .. current
         )

         current = sut:next()
      until current == nil

      t.expect(index == #expectedList, "Iterator:next() returned nil at first try")
   end)
end)
