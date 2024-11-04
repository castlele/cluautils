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
      local index = 0
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
      t.expect(false)
   end)
end)
