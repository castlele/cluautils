local t = require("src.tests")
local CObject = require("src.cobject")

---@param obj CObject
---@diagnostic disable
local function expectDefaultMethods(obj)
      t.expect(obj.init, "No 'init' method on the object")
      t.expect(obj.new, "No 'new' method on the object")
      t.expect(obj.extend, "No 'extend' method on the object")
      t.expect(obj.isInstance, "No 'isInstance' method on the object")
end

t.describe("OOP tests", function()
   t.it("Default available methods on CObject type", function()
      local sut = CObject()

      expectDefaultMethods(sut)
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

   t.it("Ancestors of CObject inherit all its methods", function ()
      local obj = CObject()
      local sut = obj:extend()

      expectDefaultMethods(sut)
   end)
end)
