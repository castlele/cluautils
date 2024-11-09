require("cluautils.table_utils")
local t = require("src.tests")
local LinkedList = require("src.datastructures.linkedlist")

t.describe("Linked list tests", function ()

   t.it("Default init of the linked list has no values", function ()
      local sut = LinkedList()

      t.expect(sut:isEmpty())
   end)

   t.it("Init with default values places it in the linked list", function ()
      local sut = LinkedList({1, 2, 3, 4})

      t.expect(not sut:isEmpty())
   end)

   t.it("Lenght of the linked list", function ()
      local list = { 1, 2, 3, 4, 5 }
      local sut = LinkedList(list)

      local len = sut:len()

      t.expect(len == #list)
   end)

   t.it("Linked list can be iterated", function ()
      local list = { 1, 2, 3, 4, 5 }
      local sut = LinkedList(list)

      for index, value in sut:valueIterator() do
         t.expect(value == list[index])
      end
   end)

   t.it("Linked list can insert element at index zero if there are no elements", function ()
      local index = 1
      local element = 10
      local sut = LinkedList()

      sut:insert(element, index)

      t.expect(sut:len() == 1)
   end)

   t.it("Linked list insert element as last if expected index is larger than list's size", function ()
      local list = { 1, 2, 4, 5 }
      local index = 10
      local element = 20
      local sut = LinkedList(list)

      sut:insert(element, index)

      for i, value in sut:valueIterator() do
         if i == #list + 1 then
            t.expect(value == element)
            return
         end
      end
      t.expect(false)
   end)

   t.it("Linked list can insert elements at the middle of the list", function ()
      local list = { 1, 2, 4, 5 }
      local index = 3
      local element = 3
      local sut = LinkedList(list)

      sut:insert(element, index)

      for i, value in sut:valueIterator() do
         if i == index then
            t.expect(value == element)
            return
         end
      end
      t.expect(false)
   end)

   t.it("Linked list can insert elements at the tail of the list", function()
      local list = { 1, 2, 4, 5 }
      local index = 3
      local element = 3
      local sut = LinkedList(list)

      sut:insert(element, index)

      for i, value in sut:valueIterator() do
         if i == index then
            t.expect(value == element)
            return
         end
      end
      t.expect(false, "No item found: " .. element)
   end)

   t.it("Append puts element at the tail of the linked list", function ()
      local list = { 1, 2, 3, 4 }
      local index = #list + 1
      local element = 5
      local sut = LinkedList(list)

      sut:append(element)

      for i, value in sut:valueIterator() do
         if i == index then
            t.expect(value == element)
            return
         end
      end
      t.expect(false, "No item found: " .. element)
   end)

   t.it("Get element by index returns nil if list is empty", function ()
      local index = 10
      local sut = LinkedList()

      local result = sut:get(index)

      t.expect(result == nil)
   end)

   t.it("Get element by index returns value of the node with this index", function ()
      local list = { 2, 4, 6, 8 }
      local index = 3
      local element = list[index]
      local sut = LinkedList(list)

      local result = sut:get(index)

      t.expect(result == element)
   end)

   t.it("Linked list do nothing on removing from empty list with index", function ()
      local index = 10
      local sut = LinkedList()

      local result = sut:remove(index)

      t.expect(result == nil)
   end)

   t.it("Linked list can remove single element", function ()
      local list = { 10 }
      local index = 1
      local element = list[index]
      local sut = LinkedList(list)

      local result = sut:remove(index)

      t.expect(result == element and sut:isEmpty() and sut:len() == 0)
   end)

   t.it("Linked list can remove root element", function ()
      local list = { 20, 10 }
      local index = 1
      local element = list[index]
      local sut = LinkedList(list)

      local result = sut:remove(index)

      t.expect(result == element and sut:len() == #list - 1)
   end)

   t.it("Linked list can remove tail element", function ()
      local list = { 20, 10 }
      local index = 2
      local element = list[index]
      local sut = LinkedList(list)

      local result = sut:remove(index)

      t.expect(result == element and sut:len() == #list - 1)
   end)

   t.it("Linked list can remove elements from the middle of the list", function ()
      local list = { 10, 20, 30, 40, 50 }
      local index = 3
      local element = list[index]
      local sut = LinkedList(list)

      local result = sut:remove(index)

      t.expect(result == element and sut:len() == #list - 1)
   end)

   t.it("Convertion to table from empty linked list results in empty table", function ()
      local sut = LinkedList()

      local result = sut:toTable()

      t.expect(table.is_empty(result))
   end)

   t.it("Convertion to table from NONE empty linked list results in table representation", function ()
      local list = { 1, 2, 3, 4, 5, 6 }
      local sut = LinkedList(list)

      local result = sut:toTable()

      t.expect(table.is_equal(result, list))
   end)

   t.it("First returns nil if linked list is empty", function ()
      local predicate = function (item) return item == 10 end
      local list = {}
      local expectedItem = nil
      local sut = LinkedList(list)

      local result = sut:first(predicate)

      t.expect(result == expectedItem)
   end)

   t.it("Linked list returns nil if no value in the list matching the predicate", function ()
      local predicate = function (item) return item == 10 end
      local list = { 20, 30, 40, 50, 60 }
      local expectedItem = nil
      local sut = LinkedList(list)

      local result = sut:first(predicate)

      t.expect(result == expectedItem)
   end)

   t.it("Linked list returns a first value matching the predicate", function ()
      local predicate = function (item) return item == 10 end
      local list = {20, 30, 10, 40, 50, 100 }
      local expectedItem = list[3]
      local sut = LinkedList(list)

      local result = sut:first(predicate)

      t.expect(result == expectedItem)
   end)
end)

t.describe("Linked list functional programming tests", function ()
   t.it("Functional methods of linked list can be chained together", function ()
      local filteringFunc = function (item) return item % 2 == 0 end
      local mapFunc = function (item) return tostring(item) end
      local list = { 1, 2, 3, 4, 5, 6 }
      local expectedList = table.map(table.filter(list, filteringFunc), mapFunc)
      local sut = LinkedList(list)

      local result = sut
         :filter(filteringFunc)
         :map(mapFunc)
         :toTable()

      t.expect(table.is_equal(expectedList, result))
   end)

   t.it("Filtering empty linked list returns empty table", function ()
      local sut = LinkedList()

      local result = sut:filter(function (_) return true end):toTable()

      t.expect(table.is_empty(result))
   end)

   t.it("Empty filtering should return the same list items in the same order", function ()
      local filterCallback = function (_) return true end
      local list = { 1, 2, 3, 4, 5, 6 }
      local sut = LinkedList(list)

      local result = sut:filter(filterCallback):toTable()

      t.expect(table.is_equal(list, result))
   end)

   t.it("Linked list can filter its notes returning table of values", function ()
      local filterCallback = function (item) return item % 2 == 0 end
      local list = { 1, 2, 3, 4, 5, 6 }
      local expectedList = table.filter(list, filterCallback)
      local sut = LinkedList(list)

      local result = sut:filter(filterCallback):toTable()

      t.expect(table.is_equal(expectedList, result))
   end)

   t.it("Map function has no effect on empty list", function ()
      local mapFunc = function (item) return item end
      local sut = LinkedList()

      local result = sut:map(mapFunc):toTable()

      t.expect(table.is_empty(result))
   end)

   t.it("Map function that returns the same item has no effect on original linked list order and elements", function ()
      local mapFunc = function (item) return item end
      local list = { 1, 2, 3, 4, 5 }
      local sut = LinkedList(list)

      local result = sut:map(mapFunc):toTable()

      t.expect(table.is_equal(list, result))
   end)

   t.it("Map function can return new values", function ()
      local mapFunc = function (item) return item * 2 end
      local list = { 1, 2, 3, 4, 5 }
      local expectedList = table.map(list, mapFunc)
      local sut = LinkedList(list)

      local result = sut:map(mapFunc):toTable()

      t.expect(table.is_equal(expectedList, result))
   end)
end)

t.describe("Linked list operations", function ()
   t.it("Test case 1", function ()
      -- ["MyLinkedList", "addAtHead", "addAtTail", "addAtIndex", "get", "deleteAtIndex", "get"]
      -- Input:
      -- [[], [1], [3], [1, 2], [1], [1], [1]]
      -- Output:
      -- [null, null, null, null, 2, null, 3]
      local sut = LinkedList()
      sut:insert(1, 1)
      sut:append(3)
      sut:insert(2, 2)

      local result1 = sut:get(2)
      local result2 = sut:remove(2)
      local result3 = sut:get(2)

      t.expect(result1 == 2, "Invalid element at index 2. Expected: 2, got: " .. result1)
      t.expect(result2 == 2, "Invalid element at index 2. Expected: 2, got: " .. result2)
      t.expect(result3 == 3, "Invalid element at index 2. Expected: 3, got: " .. result3)
   end)

   t.it("Test case 2", function ()
      local sut = LinkedList()

      sut:append(3)
      sut:insert(2, 1)
      sut:insert(1, 1)

      local result1 = sut:get(1)
      local result2 = sut:get(2)
      local result3 = sut:get(3)

      t.expect(result1 == 1, "Expect: 1, got: " .. result1)
      t.expect(result2 == 2, "Expect: 2, got: " .. result2)
      t.expect(result3 == 3, "Expect: 3, got: " .. result3)
   end)
end)
