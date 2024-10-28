require("src.tests.base_test_case")
local hashTable = require("src.datastructures.hashmap")


HashMapTestCase = CTestCase


function HashMapTestCase:test_init_method_creates_empty_table()
   local sut = hashTable:new()

   return sut:isEmpty()
end

function HashMapTestCase:test_init_method_with_predefined_elements_places_it_in_the_table()
   local predefinedValues = {"hello", "world"}
   local sut = hashTable:new(predefinedValues)

   return sut:isEmpty() == false
end


HashMapTestCase:run_tests()
