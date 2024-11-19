require("src.table_utils.table_utils")
local Iterator = require("src.iterator")
local t = require("src.tests")

---@param iter Iterator
---@param list table
local function assertIteratorEqualToTable(iter, list)
      local index = 0
      local current = iter:next()

      repeat
         index = index + 1
         local expected = list[index]

         t.expect(
            current == expected,
            "Epected: " .. expected .. " but got: " .. current
         )

         current = iter:next()
      until current == nil

      t.expect(index == #list, "Iterator:next() returned nil at first try")
end


t.describe("Iterator tests", function ()
   t.it("Iterator can be created from range", function ()
      local expectedList = { 1, 2, 3, 4, 5 }
      local sut = Iterator.range(1, 5)

      local result = sut:toList()

      t.expect(table.is_equal(expectedList, result))
   end)

   t.it("Iterator can be created from table", function ()
      local list = { 1, 2, 3, 4, 5 }
      local sut = Iterator.table(list)

      assertIteratorEqualToTable(sut, list)
   end)

   t.it("Table generator can be chained with other methods", function ()
      local mapFunction = function (item) return item * 2 end
      local list = { 1, 2, 3, 4, 5 }
      local expectedList = table.map(list, mapFunction)
      local sut = Iterator.table(list)

      local result = sut:map(mapFunction)

      assertIteratorEqualToTable(result, expectedList)
   end)

   t.it("Iterator can return next value", function ()
      local expectedList = { 1, 2, 3, 4, 5 }
      local sut = Iterator.range(1, 5)

      assertIteratorEqualToTable(sut, expectedList)
   end)

   t.it("Map function can return the same value", function ()
      local mapFunction = function (item) return item end
      local expectedList = { 1, 2, 3, 4, 5 }
      local sut = Iterator.range(1, 5)

      local result = sut:map(mapFunction)

      assertIteratorEqualToTable(result, expectedList)
   end)

   t.it("Map function can change value type of the iterator", function ()
      local mapFunction = function (item)
         return "Number: " .. item
      end
      local list = { 1, 2, 3, 4, 5 }
      local expectedList = table.map(list, mapFunction)
      local sut = Iterator.table(list)

      local result = sut:map(mapFunction)

      assertIteratorEqualToTable(result, expectedList)
   end)

   t.it("To list method works in combination with other methods", function ()
      local mapFunction = function (item) return item * 2 end
      local list = { 1, 2, 3, 4, 5 }
      local expectedList = table.map(list, mapFunction)
      local sut = Iterator.range(1, 5)

      local result = sut:map(mapFunction):toList()

      t.expect(table.is_equal(expectedList, result))
   end)

   t.it("Filter method filters items that don't follow the predicate condition", function ()
      local filterFunction = function (item) return item % 2 == 0 end
      local list = { 1, 2, 3, 4, 5 }
      local expectedList = table.filter(list, filterFunction)
      local sut = Iterator.table(list)

      local result = sut:filter(filterFunction)

      assertIteratorEqualToTable(result, expectedList)
   end)

   t.it("Filter method can be chained with other methods", function ()
      local filterFunction = function (item) return item % 2 == 0 end
      local mapFunction = function (item) return "Even number: " .. item end
      local list = { 1, 2, 3, 4, 5 }
      local expectedList = table.map(
         table.filter(list, filterFunction),
         mapFunction
      )
      local sut = Iterator.table(list)

      local result = sut:filter(filterFunction):map(mapFunction)

      assertIteratorEqualToTable(result, expectedList)
   end)

   t.it("Filter method can be chained with other methods while changing typekj", function ()
   end)
end)
