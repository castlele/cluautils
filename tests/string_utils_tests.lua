local t = require("src.tests")
local sut = require("src.string_utils.string_utils")

---@param t1 table
---@param t2 table
---@return boolean
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

t.describe("String utils tests", function()
   t.it("test_string_empty_isEmpty", function()
      local str = ""

      local result = sut.isEmpty(str)

      return result
   end)

   t.it("test_string_not_empty_isEmpty", function()
      local str = "hello"

      local result = sut.isEmpty(str)

      return result == false
   end)

   t.it("test_left_trim", function()
      local str = "     hello"

      local result = sut.triml(str)

      return result == "hello"
   end)

   t.it("test_right_trim", function()
      local str = "hello      "

      local result = sut.trimr(str)

      return result == "hello"
   end)

   t.it("test_trim", function()
      local str = "       hello      "

      local result = sut.trim(str)

      return result == "hello"
   end)

   t.it("test_split_empty_string", function()
      local string_to_split = ""
      local separator = "\n"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { string_to_split })
   end)

   t.it("test_split_with_empty_separator", function()
      local string_to_split = "Hello"
      local separator = ""

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { string_to_split })
   end)

   t.it("test_split_word_with_character", function()
      local string_to_split = "Hello"
      local separator = "e"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "H", "llo" })
   end)

   t.it("test_split_word_with_character_multiple_times", function()
      local string_to_split = "Hello"
      local separator = "l"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "He", "o" })
   end)

   t.it("test_split_word_with_character_at_the_end_of_the_word", function()
      local string_to_split = "Hello"
      local separator = "o"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "Hell" })
   end)

   t.it("test_split_word_with_character_at_the_start_of_the_word", function()
      local string_to_split = "Hello"
      local separator = "H"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "ello" })
   end)

   t.it("test_split_two_words_by_space", function()
      local string_to_split = "Hello world"
      local separator = " "

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "Hello", "world" })
   end)

   t.it("test_split_three_words_by_space", function()
      local string_to_split = "Hello hello hello"
      local separator = " "

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "Hello", "hello", "hello" })
   end)

   t.it("test_split_two_words_by_new_line", function()
      local string_to_split = "Hello\nhello"
      local separator = "\n"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "Hello", "hello" })
   end)

   t.it("test_split_two_words_in_multiline_string", function()
      local string_to_split = [[
Hello
hello]]
      local separator = "\n"

      local splitted = sut.split(string_to_split, separator)

      return compare(splitted, { "Hello", "hello" })
   end)

   t.it("test_split_json", function()
      local string_to_split = [[
{
    "hello": "world",
    "number": 1
}
]]
      local separator = "\n"

      local splitted = sut.split(string_to_split, separator)

      return compare(
         splitted,
         { "{", '    "hello": "world",', '    "number": 1', "}" }
      )
   end)

   t.it("is_string_nil_or_empty", function()
      t.expect(sut.isNilOrEmpty(nil), "Nil string is not nil")
      t.expect(sut.isNilOrEmpty(""), "Empty string is not empty")
      t.expect(not sut.isNilOrEmpty("hello"), "None empty string is empty")
   end)
end)
