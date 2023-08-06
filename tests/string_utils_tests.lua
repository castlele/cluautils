require("tests.c_test_case")
require("utils.string_utils")

StringTestCase = CTestCase

---@MARK - is_empty method tests

function StringTestCase:test_string_empty_is_empty()
    local str = ""

    local result = str:is_empty()

    return result
end

function StringTestCase:test_string_not_empty_is_empty()
    local str = "hello"

    local result = str:is_empty()

    return result == false
end

StringTestCase:run_tests()
