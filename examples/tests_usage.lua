local t = require("src.tests")

t.describe("Example test cases", function()
   t.it("Successful test case", function()
      t.expect(true)
   end)

   t.it("Failing test case", function()
      t.expect(false)
   end)
end)
