local t = require("src.tests")
local BST = require("src.datastructures.bst")

t.describe("BST creation and basic operations", function ()
   t.it("BST can be created with no values", function ()
      local sut = BST()

      t.expect(sut:isEmpty())
   end)
end)
