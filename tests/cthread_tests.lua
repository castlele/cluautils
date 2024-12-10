require("src.file_manager.file_manager")
local t = require("src.tests")
local thread = assert(package.loadlib("./src/threads/bin/thread.so", "_luaopen_thread"))()

t.describe("Thread Module Tests", function ()
   local function assertOutput()
      local fileName = "logs.log"
      local file = assert(io.open(fileName, "r"))
      local lines = FM.get_lines_from_file(file, nil)

      FM.delete_file(fileName)

      t.expect(#lines == 22, "Got wrong amount of lines. Expected: " .. 22 .. "; got: " .. #lines)
   end

   t.it("Joinable threads can be created", function ()
      local code = [[
local f = assert(io.open("logs.log", "w"))
local i = 1

while true do
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
