local t = require("src.tests")
local CObject = require("src.cobject")

t.describe("OOP tests", function()
   t.it("Default available methods on CObject type", function()
      local sut = CObject()

      t.expect(sut.init, "No 'init' method on the object")
      t.expect(sut.new, "No 'new' method on the object")
      t.expect(sut.extend, "No 'extend' method on the object")
      t.expect(sut.isInstance, "No 'isInstance' method on the object")
   end)
end)
