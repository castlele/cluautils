require("src.tests.base_test_case")
require("src.table_utils.table_utils")

TableUtilsTestCase = CTestCase

---@MARK - contains method tests

function TableUtilsTestCase:test_table_contains_empty()
    local t = {}
    local value = "hello"

    local result = table.contains(t, value)

    return result == false
end

function TableUtilsTestCase:test_table_contains_string()
    local t = {"hello", "world"}
    local value = "hello"

    local result = table.contains(t, value)

    return result
end

function TableUtilsTestCase:test_table_contains_integer()
    local t = {1, 2, 3, 4, 5}
    local value = 5

    local result = table.contains(t, value)

    return result
end

function TableUtilsTestCase:test_table_does_not_contain_string()
    local t = {"hello", "world"}
    local value = "castlelecs"

    local result = table.contains(t, value)

    return result == false
end

function TableUtilsTestCase:test_table_does_not_contain_integer()
    local t = {1, 2, 3, 4, 5}
    local value = 0

    local result = table.contains(t, value)

    return result == false
end

---@MARK - is_empty method tests

function TableUtilsTestCase:test_table_is_empty_true()
    local t = {}

    local result = table.is_empty(t)

    return result
end

function TableUtilsTestCase:test_table_is_empty_false()
    local t = {1, 2, 3}

    local result = table.is_empty(t)

    return result == false
end

---@MARK - get_index method tests

function TableUtilsTestCase:test_table_index_of_non_existing_value()
    local t = {1, 2, 3, 4, 5}

    local result = table.get_index(t, 6)

    return result == nil
end

function TableUtilsTestCase:test_table_index_of_existing_value()
    local t = {1, 2, 3, 4, 5}

    local result = table.get_index(t, 5)

    return result == #t
end

---@MARK - is_equal method tests

function TableUtilsTestCase:test_equatability_of_empty_tables()
    local t1 = {}
    local t2 = {}

    local result = table.is_equal(t1, t2)

    return result == true
end

function TableUtilsTestCase:test_equatability_of_different_tables()
    local t1 = {1, 2, 3}
    local t2 = {3, 2, 1}

    local result = table.is_equal(t1, t2)

    return result == false
end

function TableUtilsTestCase:test_equatability_of_equal_tables()
    local t1 = {1, 2, 3}
    local t2 = {1, 2, 3}

    local result = table.is_equal(t1, t2)

    return result == true
end

---@MARK - concat_tables method tests

function TableUtilsTestCase:test_concat_tables_empty_tables()
    local t1 = {}
    local t2 = {}

    local result = table.concat_tables(t1, t2)

    return table.is_equal(result, {})
end

function TableUtilsTestCase:test_concat_tables_empty_and_none_empty()
    local t1 = {}
    local t2 = {1, 2, 3}

    local result = table.concat_tables(t1, t2)

    return table.is_equal(result, {1, 2, 3})
end

function TableUtilsTestCase:test_concat_tables_none_empty_and_empty()
    local t1 = {1, 2, 3}
    local t2 = {}

    local result = table.concat_tables(t1, t2)

    return table.is_equal(result, {1, 2, 3})
end

function TableUtilsTestCase:test_concat_tables_none_empty_tables()
    local t1 = {1, 2, 3}
    local t2 = {4, 5, 6}

    local result = table.concat_tables(t1, t2)

    return table.is_equal(result, {1, 2, 3, 4, 5, 6})
end

function TableUtilsTestCase:test_concat_tables_with_condition()
    local t1 = {1, 2, 3}
    local t2 = {4, 5, 6}
    local even_num_filter = function (num)
        return num % 2 == 0
    end

    local result = table.concat_tables(t1, t2, even_num_filter)

    return table.is_equal(result, {2, 4, 6})
end

---@MARK - map tests

function TableUtilsTestCase:test_map_empty_table()
    local testable_table = {}

    local result_table = table.map(testable_table, function (value) return value end)

    return table.is_equal(result_table, {})
end

function TableUtilsTestCase:test_map_with_empty_callback()
    local testable_table = {1, 2, 3, 4}

    local result_table = table.map(testable_table, function (value) return value end)

    return table.is_equal(result_table, testable_table)
end

function TableUtilsTestCase:test_map_elements_doubled()
    local testable_table = {1, 2, 3, 4}

    local result_table = table.map(testable_table, function (value) return value * 2 end)

    return table.is_equal(result_table, {2, 4, 6, 8})
end

function TableUtilsTestCase:test_map_by_key_value_pairs()
   local testable_table = { greeting = "hello", name = "world" }

   local result = table.mapkv(testable_table, function (key, value) return key .. value end)

   return #result == 2 and table.contains(result, "greetinghello") and table.contains(result, "nameworld")
end

---@MARK - filter tests

 function TableUtilsTestCase:test_filter_empty_table()
    local testable_table = {}

    local filtered_table = table.filter(testable_table, function (_) return true end)

    return table.is_equal(filtered_table, {})
end

function TableUtilsTestCase:test_filter_table_with_no_callback()
    local testable_table = {1, 2, 3, 4}

    local filtered_table = table.filter(testable_table, function (_) return true end)

    return table.is_equal(filtered_table, testable_table)
end

function TableUtilsTestCase:test_filter_table_for_even_numbers()
    local testable_table = {1, 2, 3, 4}

    local filtered_table = table.filter(testable_table, function (el) return el % 2 == 0  end)

    return table.is_equal(filtered_table, {2, 4})
end

function TableUtilsTestCase:test_allocation_with_default_value()
   local size = 50
   local testable_table

   testable_table = table.alloc(size, 0)

   return #testable_table == size
end


TableUtilsTestCase:run_tests()
