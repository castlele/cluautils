require("tests.c_test_case")
require("utils.table_utils")

TableUtilsTestCase = CTestCase

---@MARK - contains method tests

function TableUtilsTestCase:table_contains_empty()
    local t = {}
    local value = "hello"

    local result = table.contains(t, value)

    return result == false
end

function TableUtilsTestCase:table_contains_string()
    local t = {"hello", "world"}
    local value = "hello"

    local result = table.contains(t, value)

    return result
end

function TableUtilsTestCase:table_contains_integer()
    local t = {1, 2, 3, 4, 5}
    local value = 5

    local result = table.contains(t, value)

    return result
end

function TableUtilsTestCase:table_does_not_contain_string()
    local t = {"hello", "world"}
    local value = "castlelecs"

    local result = table.contains(t, value)

    return result == false
end

function TableUtilsTestCase:table_does_not_contain_integer()
    local t = {1, 2, 3, 4, 5}
    local value = 0

    local result = table.contains(t, value)

    return result == false
end

---@MARK - is_empty method tests

function TableUtilsTestCase:table_is_empty_true()
    local t = {}

    local result = table.is_empty(t)

    return result
end

function TableUtilsTestCase:table_is_empty_false()
    local t = {1, 2, 3}

    local result = table.is_empty(t)

    return result == false
end

TableUtilsTestCase:run_tests()
