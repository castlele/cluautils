require("src.tests.base_test_case")
local hashTable = require("src.datastructures.hashmap")


HashMapTestCase = CTestCase


function HashMapTestCase:test_init_method_creates_empty_table()
   local sut = hashTable:new()

   return sut:isEmpty()
end

function HashMapTestCase:test_init_method_with_predefined_elements_places_it_in_the_table()
   local predefinedValues = { greeting = "hello", main = "world"}
   local sut = hashTable:new(predefinedValues)

   return sut:isEmpty() == false
end

function HashMapTestCase:test_put_method_stores_item_in_the_table()
   local key = "greeting"
   local value = "hello"
   local storage = 100
   local sut = hashTable:new(nil, storage)

   sut:put(key, value)

   return sut:isEmpty() == false
end

function HashMapTestCase:test_get_method_in_empty_table()
   local key = "greeting"
   local sut = hashTable:new()

   local result = sut:get(key)

   return result == nil
end

function HashMapTestCase:test_get_method_in_non_empty_table()
   local key = "greeting"
   local value = "hello"
   local predefinedValues = { [key] = value }
   local sut = hashTable:new(predefinedValues)

   local result = sut:get(key)

   return result == value
end

function HashMapTestCase:test_remove_from_empty_table()
   local key = "greeting"
   local sut = hashTable:new()

   local result = sut:remove(key)

   return result == false
end

function HashMapTestCase:test_remove_from_none_empty_table()
   local key = "greeting"
   local value = "hello"
   local predefinedValues = { [key] = value }
   local sut = hashTable:new(predefinedValues)

   local result = sut:remove(key)

   return result and sut:get(key) == nil
end


HashMapTestCase:run_tests()
