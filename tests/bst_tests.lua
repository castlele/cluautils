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

      t.expect(not sut:isEmpty())
   end)
end)
