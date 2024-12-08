require("src.string_utils.string_utils")
local t = require("src.tests")
local thread = assert(package.loadlib("./src/threads/bin/thread.so", "_luaopen_thread"))()

t.describe("Thread Module Tests", function ()
   local function assertOutput()
      local f = assert(io.open("logs.log", "r"))
      local lines = string.split(f:read("*a"), "\n")

      f:close()

      t.expect(#lines == 22, "Got wrong amount of lines. Expected: " .. 22 .. "; got: " .. #lines)
   end

   t.it("Joinable threads can be created", function ()
      local code = [[
local f = assert(io.open("logs.log", "w"))

while true do
   print(i)
   f:write("Index: " .. i .. "\n")

   i = i + 1

   if i > 22 then
      break
   end
end

f:close()
      ]]
      local sut = thread.create(code)

      thread.start(sut)
      thread.wait(sut)

      assertOutput()
   end)
end)
