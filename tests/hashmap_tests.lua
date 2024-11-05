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
end)
