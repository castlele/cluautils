local t = require("src.tests")
local linkedList = require("src.datastructures.linkedlist")

t.describe("Linked list tests", function ()

   t.it("Default init of the linked list has no values", function ()
      local sut = linkedList()

      t.expect(sut:isEmpty())
   end)

   t.it("Init with default values places it in the linked list", function ()
      local sut = linkedList({1, 2, 3, 4})

      t.expect(not sut:isEmpty())
   end)

   t.it("Lenght of the linked list", function ()
      local list = { 1, 2, 3, 4, 5 }
      local sut = linkedList(list)

      print(sut:len())
      print(#sut)

      t.expect(#sut == #list)
   end)
end)
