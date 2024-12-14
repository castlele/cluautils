local t = require("src.tests")
local memory = assert(package.loadlib("./src/memory/bin/cmemory.so", "_luaopen_cluautils_memory"))()

t.describe("Memory module tests", function ()
   t.it("Memory module gets address of the table", function ()
      local address = memory.get(t)

      
   end)
end)
