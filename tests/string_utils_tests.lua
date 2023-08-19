require("src.tests.base_test_case")
require("src.string_utils.string_utils")

StringTestCase = CTestCase

---@MARK - Helpers

local function compare(t1, t2)
    if #t1 ~= #t2 then
        return false
    end

    for index, value in pairs(t1) do
        if value ~= t2[index] then
            return false
        end
    end

    return true
end

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

---@MARK - split method tests

function StringTestCase:test_split_empty_string()
    local string_to_split = ""
    local separator = "\n"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {string_to_split})
end

function StringTestCase:test_split_with_empty_separator()
    local string_to_split = "Hello"
    local separator = ""

    local splitted = string_to_split:split(separator)

    return compare(splitted, {string_to_split})
end

function StringTestCase:test_split_word_with_character()
    local string_to_split = "Hello"
    local separator = "e"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"H", "llo"})
end

function StringTestCase:test_split_word_with_character_multiple_times()
    local string_to_split = "Hello"
    local separator = "l"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"He", "o"})
end

function StringTestCase:test_split_word_with_character_at_the_end_of_the_word()
    local string_to_split = "Hello"
    local separator = "o"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"Hell"})
end

function StringTestCase:test_split_word_with_character_at_the_start_of_the_word()
    local string_to_split = "Hello"
    local separator = "H"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"ello"})
end

function StringTestCase:test_split_two_words_by_space()
    local string_to_split = "Hello world"
    local separator = " "

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"Hello", "world"})
end

function StringTestCase:test_split_three_words_by_space()
    local string_to_split = "Hello hello hello"
    local separator = " "

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"Hello", "hello", "hello"})
end

function StringTestCase:test_split_two_words_by_new_line()
    local string_to_split = "Hello\nhello"
    local separator = "\n"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"Hello", "hello"})
end

function StringTestCase:test_split_two_words_in_multiline_string()
    local string_to_split = [[
Hello
hello]]
    local separator = "\n"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"Hello", "hello"})
end

function StringTestCase:test_split_json()
    local string_to_split = [[
{
    "hello": "world",
    "number": 1
}
]]
    local separator = "\n"

    local splitted = string_to_split:split(separator)

    return compare(splitted, {"{", '    "hello": "world",', '    "number": 1', "}"})
end


StringTestCase:run_tests()
