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

   t.it("Copy of the class object is an instance of it", function ()
      local sut = CObject()
      local copy = sut

      t.expect(sut:isInstance(copy), "Original object isn't an instance of its copy")
      t.expect(copy:isInstance(sut), "Copy of the object's instance isn't an instance of its origin instance")
   end)

   t.it("Different instance of the class object isn't an instance of it", function ()
      local instance1 = CObject()
      local instance2 = CObject()

      t.expect(not instance1:isInstance(instance2), "Instance 1 is instance of instance 2")
      t.expect(not instance2:isInstance(instance1), "Instance 2 is instance of instance 1")
   end)
end)
