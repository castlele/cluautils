require("src.tests.base_test_case")
require("src.string_utils.string_utils")

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

---@MARK - trim methods tests

function StringTestCase:test_left_trim()
    local str = "     hello"

    local result = str:triml()

    return result == "hello"
end

function StringTestCase:test_right_trim()
    local str = "hello      "

    local result = str:trimr()

    return result == "hello"
end

function StringTestCase:test_trim()
    local str = "       hello      "

    local result = str:trim()

    return result == "hello"
end

StringTestCase:run_tests()
