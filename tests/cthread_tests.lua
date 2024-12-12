require("src.file_manager.file_manager")
local t = require("src.tests")
local thread = assert(package.loadlib("./src/threads/bin/thread.so", "_luaopen_thread"))()

t.describe("Thread Module Tests", function ()
   ---@param maxValue integer?
   local function assertOutput(maxValue)
      maxValue = maxValue or 22
      local fileName = "logs.log"
      local file = assert(io.open(fileName, "r"))
      local lines = FM.get_lines_from_file(file, nil)

      FM.delete_file(fileName)

      t.expect(#lines == maxValue, "Got wrong amount of lines. Expected: " .. maxValue .. "; got: " .. #lines)
   end

--    t.it("Joinable threads can be ran with string code", function ()
--       local code = [[
-- local f = assert(io.open("logs.log", "w"))
-- local i = 1
--
-- while true do
--    f:write("Index: " .. i .. "\n")
--
--    i = i + 1
--
--    if i > 22 then
--       break
--    end
-- end
--
-- f:close()
--       ]]
--       local sut = thread.create(code)
--
--       thread.start(sut)
--       thread.wait(sut)
--
--       assertOutput()
   -- end)

   -- t.it("Joinable threads can be ran with file code", function ()
   --    local code = "./tests/res/pthread_counter.lua"
   --    local sut = thread.create(code)
   --
   --    thread.start(sut)
   --    thread.wait(sut)
   --
   --    assertOutput()
   -- end)

   t.it("Arguments can be passed to thread's code", function ()
      local code = "./tests/res/pthread_counter_with_param.lua"
      local sut = thread.create(code)

      thread.start(sut, 10)
      thread.wait(sut)

      assertOutput(10)
   end)
end)
