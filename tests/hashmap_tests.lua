local t = require("src.tests")
local HashMap = require("src.datastructures.hashmap")

t.describe("Hash Map tests", function ()
   t.it("test_init_method_creates_empty_table", function ()
      local sut = HashMap()

      t.expect(sut:isEmpty())
   end)

   t.it("test_init_method_with_predefined_elements_places_it_in_the_table", function ()
      local predefinedValues = { greeting = "hello", main = "world"}
      local sut = HashMap(predefinedValues)

      t.expect(not sut:isEmpty())
   end)

   t.it("test_put_method_stores_item_in_the_table", function ()
      local key = "greeting"
      local value = "hello"
      local storage = 100
      local sut = HashMap:new(nil, storage)

      sut:put(key, value)

      t.expect(not sut:isEmpty())
   end)

   t.it("test_get_method_in_empty_table", function ()
      local key = "greeting"
      local sut = HashMap:new()

      local result = sut:get(key)

      t.expect(result == nil)
   end)

   t.it("test_get_method_in_non_empty_table", function ()
      local key = "greeting"
      local value = "hello"
      local predefinedValues = { [key] = value }
      local sut = HashMap:new(predefinedValues)

      local result = sut:get(key)

      t.expect(result == value)
   end)

   t.it("test_remove_from_empty_table", function ()
      local key = "greeting"
      local sut = HashMap:new()

      local result = sut:remove(key)

      t.expect(result == false)
   end)

   t.it("test_remove_from_none_empty_table", function ()
      local key = "greeting"
      local value = "hello"
      local predefinedValues = { [key] = value }
      local sut = HashMap:new(predefinedValues)

      local result = sut:remove(key)

      t.expect(result and sut:get(key) == nil)
   end)

   t.it("Hash map can resolve conflicts", function ()
      local key1 = "cat"
      local value1 = "Javie"
      local key2 = "dog"
      local value2 = "Shanty"
      local predefinedValues = {
         [key1] = value1,
         [key2] = value2,
      }
      local sut = HashMap(predefinedValues)

      local result1 = sut:get(key1)
      local result2 = sut:get(key2)

      t.expect(result1 == value1)
      t.expect(result2 == value2)
   end)

   t.it("Hash map can resolve conflicts multiple times", function ()
      local key1 = "cat"
      local value1 = "Javie"
      local key2 = "dog"
      local value2 = "Shanty"
      local key3 = "bat"
      local value3 = "Batman"
      local predefinedValues = {
         [key1] = value1,
         [key2] = value2,
         [key3] = value3,
      }
      local sut = HashMap(predefinedValues)

      local result1 = sut:get(key1)
      local result2 = sut:get(key2)
      local result3 = sut:get(key3)

      t.expect(result1 == value1)
      t.expect(result2 == value2)
      t.expect(result3 == value3)
   end)
end)
