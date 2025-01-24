local t = require("src.tests")
local os = require("cluautils.os")
local strutils = require("src.string_utils.string_utils")

t.describe("OS module tests", function ()
   t.it("os module has name function", function ()
      local name = os.getName()

      t.expect(type(name) == "string", "os type should be string")
      t.expect(not strutils.isEmpty(name), "os type shouldn't be empty")
   end)
end)
