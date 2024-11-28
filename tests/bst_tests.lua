local t = require("src.tests")
local BST = require("src.datastructures.bst")

t.describe("BST creation and basic operations", function ()
   t.it("BST can be created with no values", function ()
      local sut = BST()

      t.expect(sut:isEmpty())
   end)

   t.it("BST can be create with default values", function ()
      local list = { 1, 2, 3, 4, 5 }
      local sut = BST(list)

      t.expect(not sut:isEmpty(), "BST is empty")
      t.expect(sut:len() == #list, "BST's len is wrong, expected: " .. #list .. ", got: " .. sut:len())
   end)

   t.it("BST will be empty if initialized with an empty list", function ()
      local list = {}
      local sut = BST(list)

      t.expect(sut:isEmpty(), "BST isn't empty")
      t.expect(sut:len() == #list, "BST's len is wrong, expected: " .. #list .. ", got: " .. sut:len())
   end)

   t.it("BST can be traversed inorder", function ()
      local list = { 4, 5, 2, 6, 1, 3 }
      local compFun = function (lhs, rhs)
         return lhs < rhs
      end
      local sut = BST(list)
      local inOrderedList = {}

      for value in sut:traverseInOrder() do
         table.insert(inOrderedList, value)
      end

      t.expectTableEqual(table.sort(list, compFun), inOrderedList)
   end)
end)
