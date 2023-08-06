require("tests.c_test_case")
require("utils.shared")

CUtilsTestCase = CTestCase

---@MARK - is_object method tests

function CUtilsTestCase:test_is_string_object()
    local str = "hello world"

    local result = CUtils.is_object(str)

    return result == false
end

function CUtilsTestCase:test_is_integer_object()
    local int = 100

    local result = CUtils.is_object(int)

    return result == false
end

function CUtilsTestCase:test_is_table_object()
    local t = {1, 2, 3, 4}

    local result = CUtils.is_object(t)

    return result == false
end

function CUtilsTestCase:test_is_object_object()
    local obj = CTestCase:new()

    local result = CUtils.is_object(obj)

    return result
end

---@MARK - is_string_nil_or_empty method tests

function CUtilsTestCase:test_string_nil_is_string_nil_or_empty()
    local str = nil

    local result = CUtils.is_string_nil_or_empty(str)

    return result
end

function CUtilsTestCase:test_string_empty_is_string_nil_or_empty()
    local str = ""

    local result = CUtils.is_string_nil_or_empty(str)

    return result
end

function CUtilsTestCase:test_string_not_empty_is_string_nil_or_empty()
    local str = "hello"

    local result = CUtils.is_string_nil_or_empty(str)

    return result == false
end

CUtilsTestCase:run_tests()
