local Collection = require("src.collections.collection_interface")
local t = require("src.tests")

t.describe("Collection Interface Tests", function ()
   t.it("Collection interface got default methods", function ()
      ---@type CollectionInterface
      local sut = Collection:extend()

      ---@diagnostic disable-next-line
      t.expect(sut.isEmpty, "Collection doesn't have isEmpty method")
      ---@diagnostic disable-next-line
      t.expect(sut.len, "Collection doesn't have len method")
      ---@diagnostic disable-next-line
      t.expect(sut.toTable, "Collection doesn't have toTable method")
   end)

   t.it("Collection's toString method returns it's address and name", function ()
      local sut = Collection:extend()
      local addr = require("cluautils.memory").get(sut)
      local expected = "CollectionInterface:" .. addr

      local result = sut:toString()

      t.expect(
         expected == result,
         "'toString' result isn't equal to object's memory address. "
         .. "Expected: " .. expected .. ". "
         .. "Got: " .. result
      )
   end)

   t.it("All collections methods throws by default", function ()
      local sut = Collection:extend()

      t.expect(not pcall(sut.init, sut))
      t.expect(not pcall(sut.isEmpty, sut))
      t.expect(not pcall(sut.len, sut))
      t.expect(not pcall(sut.toTable, sut))
   end)
end)

