local t = require("src.tests")
local localMemoryPackage = package.loadlib("./src/memory/bin/memory.so", "_luaopen_cluautils_memory")
local memory

if not localMemoryPackage then
   memory = require("cluautils.memory")
else
   memory = localMemoryPackage()
end

t.describe("Memory module tests", function ()
   t.it("Memory module gets address of the table", function ()
      local address = memory.get(t)

      t.expect(string.match(address, "0x.*") == address)
   end)

   t.it("Memory of the same object always the same", function ()
      local address1 = memory.get(t)
      local address2 = memory.get(t)

      t.expect(address1 == address2)
   end)
end)
