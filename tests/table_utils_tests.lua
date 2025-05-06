require("src.tests.base_test_case")
local tableutils = require("src.table_utils.table_utils")

TableUtilsTestCase = CTestCase

---@MARK - contains method tests

function TableUtilsTestCase:test_table_contains_empty()
   local t = {}
   local value = "hello"

   local result = tableutils.contains(t, value)

   return result == false
end

function TableUtilsTestCase:test_table_contains_string()
   local t = { "hello", "world" }
   local value = "hello"

   local result = tableutils.contains(t, value)

   return result
end

function TableUtilsTestCase:test_table_contains_integer()
   local t = { 1, 2, 3, 4, 5 }
   local value = 5

   local result = tableutils.contains(t, value)

   return result
end

function TableUtilsTestCase:test_table_does_not_contain_string()
   local t = { "hello", "world" }
   local value = "castlelecs"

   local result = tableutils.contains(t, value)

   return result == false
end

function TableUtilsTestCase:test_table_does_not_contain_integer()
   local t = { 1, 2, 3, 4, 5 }
   local value = 0

   local result = tableutils.contains(t, value)

   return result == false
end

---@MARK - is_empty method tests

function TableUtilsTestCase:test_table_is_empty_true()
   local t = {}

   local result = tableutils.is_empty(t)

   return result
end

function TableUtilsTestCase:test_table_is_empty_false()
   local t = { 1, 2, 3 }

   local result = tableutils.is_empty(t)

   return result == false
end

---@MARK - get_index method tests

function TableUtilsTestCase:test_table_index_of_non_existing_value()
   local t = { 1, 2, 3, 4, 5 }

   local result = tableutils.get_index(t, 6)

   return result == nil
end

function TableUtilsTestCase:test_table_index_of_existing_value()
   local t = { 1, 2, 3, 4, 5 }

   local result = tableutils.get_index(t, 5)

   return result == #t
end

---@MARK - is_equal method tests

function TableUtilsTestCase:test_equatability_of_empty_tables()
   local t1 = {}
   local t2 = {}

   local result = tableutils.is_equal(t1, t2)

   return result == true
end

function TableUtilsTestCase:test_equatability_of_different_tables()
   local t1 = { 1, 2, 3 }
   local t2 = { 3, 2, 1 }

   local result = tableutils.is_equal(t1, t2)

   return result == false
end

function TableUtilsTestCase:test_equatability_of_equal_tables()
   local t1 = { 1, 2, 3 }
   local t2 = { 1, 2, 3 }

   local result = tableutils.is_equal(t1, t2)

   return result == true
end

---@MARK - concat_tables method tests

function TableUtilsTestCase:test_concat_tables_empty_tables()
   local t1 = {}
   local t2 = {}

   local result = tableutils.concat_tables(t1, t2)

   return tableutils.is_equal(result, {})
end

function TableUtilsTestCase:test_concat_tables_empty_and_none_empty()
   local t1 = {}
   local t2 = { 1, 2, 3 }

   local result = tableutils.concat_tables(t1, t2)

   return tableutils.is_equal(result, { 1, 2, 3 })
end

function TableUtilsTestCase:test_concat_tables_none_empty_and_empty()
   local t1 = { 1, 2, 3 }
   local t2 = {}

   local result = tableutils.concat_tables(t1, t2)

   return tableutils.is_equal(result, { 1, 2, 3 })
end

function TableUtilsTestCase:test_concat_tables_none_empty_tables()
   local t1 = { 1, 2, 3 }
   local t2 = { 4, 5, 6 }

   local result = tableutils.concat_tables(t1, t2)

   return tableutils.is_equal(result, { 1, 2, 3, 4, 5, 6 })
end

function TableUtilsTestCase:test_concat_tables_with_condition()
   local t1 = { 1, 2, 3 }
   local t2 = { 4, 5, 6 }
   local even_num_filter = function(num)
      return num % 2 == 0
   end

   local result = tableutils.concat_tables(t1, t2, even_num_filter)

   return tableutils.is_equal(result, { 2, 4, 6 })
end

---@MARK - map tests

function TableUtilsTestCase:test_map_empty_table()
   local testable_table = {}

   local result_table = tableutils.map(testable_table, function(value)
      return value
   end)

   return tableutils.is_equal(result_table, {})
end

function TableUtilsTestCase:test_map_with_empty_callback()
   local testable_table = { 1, 2, 3, 4 }

   local result_table = tableutils.map(testable_table, function(value)
      return value
   end)

   return tableutils.is_equal(result_table, testable_table)
end

function TableUtilsTestCase:test_map_elements_doubled()
   local testable_table = { 1, 2, 3, 4 }

   local result_table = tableutils.map(testable_table, function(value)
      return value * 2
   end)

   return tableutils.is_equal(result_table, { 2, 4, 6, 8 })
end

function TableUtilsTestCase:test_map_by_key_value_pairs()
   local testable_table = { greeting = "hello", name = "world" }

   local result = tableutils.mapkv(testable_table, function(key, value)
      return key .. value
   end)

   return #result == 2
      and tableutils.contains(result, "greetinghello")
      and tableutils.contains(result, "nameworld")
end

---@MARK - filter tests

function TableUtilsTestCase:test_filter_empty_table()
   local testable_table = {}

   local filtered_table = tableutils.filter(testable_table, function(_)
      return true
   end)

   return tableutils.is_equal(filtered_table, {})
end

function TableUtilsTestCase:test_filter_table_with_no_callback()
   local testable_table = { 1, 2, 3, 4 }

   local filtered_table = tableutils.filter(testable_table, function(_)
      return true
   end)

   return tableutils.is_equal(filtered_table, testable_table)
end

function TableUtilsTestCase:test_filter_table_for_even_numbers()
   local testable_table = { 1, 2, 3, 4 }

   local filtered_table = tableutils.filter(testable_table, function(el)
      return el % 2 == 0
   end)

   return tableutils.is_equal(filtered_table, { 2, 4 })
end

function TableUtilsTestCase:test_allocation_with_default_value()
   local size = 50
   local testable_table

   testable_table = tableutils.alloc(size, 0)

   return #testable_table == size
end

TableUtilsTestCase:run_tests()

local t = require("src.tests")

t.describe("Table utils tests", function()
   t.it("empty table concatenation", function()
      local result = tableutils.concat({}, {})

      t.expect(tableutils.is_empty(result))
   end)

   t.it("dicts concatenation", function()
      local lhs = {
         greeting = "Hello",
      }
      local rhs = {
         name = "World",
      }

      local result = tableutils.concat(lhs, rhs)

      t.expect(result.greeting == lhs.greeting)
      t.expect(result.name == rhs.name)
   end)

   t.it("lists concatenation", function()
      local lhs = {
         "Hello",
      }
      local rhs = {
         "Yoo",
         "World",
      }

      local result = tableutils.concat(lhs, rhs)

      t.expect(result[1] == lhs[1])
      t.expect(result[2] == rhs[2])
   end)

   t.it("concatenation list with dict", function()
      local lhs = {
         "Hello",
         "World",
      }
      local rhs = {
         greeting = "Hello",
         name = "World",
      }

      local result = tableutils.concat(lhs, rhs)

      t.expect(result[1] == lhs[1])
      t.expect(result[2] == lhs[2])
      t.expect(result.greeting == rhs.greeting)
      t.expect(result.name == rhs.name)
   end)

   t.it("Merge sort do nothing on empty table", function()
      local list = {}

      tableutils.mergeSort(list)

      t.expect(tableutils.is_empty(list))
   end)

   t.it("Merge sort do nothing with single element", function()
      local list = { 1 }

      tableutils.mergeSort(list)

      t.expect(
         #list == 1,
         string.format("Invalid table len: expected 1, got %d", #list)
      )
   end)

   t.it("Merge sort do nothing with sorted elements", function ()
      local expected = { 1, 2, 3 }
      local list = { 1, 2, 3 }

      tableutils.mergeSort(list)

      t.expectTableEqual(expected, list)
   end)

   t.it("Merge sort sorts two unordered elements", function ()
      local expected = { 1, 2 }
      local list = { 2, 1 }

      tableutils.mergeSort(list)

      t.expectTableEqual(expected, list)
   end)

   t.it("Merge sort sorts any number of unordered elements", function ()
      local list = tableutils.makeRange(1000, -1000, -1)
      local expected = list
      table.sort(expected)

      tableutils.mergeSort(list)

      t.expectTableEqual(expected, list)
   end)

   t.it("Range from positive to negative numbers", function ()
      local expected = { 3, 2, 1, 0, -1, -2, -3}

      local result = tableutils.makeRange(3, -3, -1)

      t.expectTableEqual(expected, result)
   end)

   t.it("Binary search returns nothing on empty table", function ()
      local result = tableutils.binarySearch({}, 1)

      t.expect(result == nil)
   end)

   t.it("Binary search returns nothing on non-existing element", function ()
      local result = tableutils.binarySearch({ 1, 2, 3 }, 4)

      t.expect(result == nil)
   end)

   t.it("Binary search returns index of existing element", function ()
      local result = tableutils.binarySearch({ 1, 2, 3, 4, 5 }, 3)

      t.expect(result == 3)
   end)

   t.it("Binary search returns index of existing element in even list", function ()
      local result = tableutils.binarySearch({ 1, 2, 4, 5 }, 4)
      t.expect(result == 3)
   end)
end)
