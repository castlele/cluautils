require("src.file_manager.file_manager")
local t = require("src.tests")
local localThreadPackage = package.loadlib("./src/threads/bin/thread.so", "_luaopen_cluautils_thread")
local thread

if not localThreadPackage then
   thread = require("cluautils.thread")
else
   thread = localThreadPackage()
end

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

   t.it("Joinable threads can be ran with string code", function ()
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
      local isSuccess, msg = thread.wait(sut)

      t.expect(isSuccess, "Thread failed with message: '" .. (msg or "") .. "'")
      assertOutput()
   end)

   t.it("Joinable threads can be ran with file code", function ()
      local code = "./tests/res/pthread_counter.lua"
      local sut = thread.create(code)

      thread.start(sut)
      local isSuccess, msg = thread.wait(sut)

      t.expect(isSuccess, "Thread failed with message: '" .. (msg or "") .. "'")
      assertOutput()
   end)

   t.it("Arguments can be passed to thread's code", function ()
      local code = "./tests/res/pthread_counter_with_param.lua"
      local sut = thread.create(code)

      thread.start(sut, 10)
      local isSuccess, msg = thread.wait(sut)

      t.expect(isSuccess, "Thread failed with message: '" .. (msg or "") .. "'")
      assertOutput(10)
   end)

   t.it("Nil, number, boolean, string can be passed to thread", function ()
      local code = [[
      local arg = {...}
      assert(arg[1] == nil, "First argument isn't nil.")
      assert(arg[2] == 22, "Second argument isn't a number.")
      assert(arg[3] == false, "Third argument isn't a boolean.")
      assert(arg[4] == "hello, world", "Fourth argument isn't a string.")
      ]]
      local sut = thread.create(code)

      t.expect(thread.start(sut, nil, 22, false, "hello, world"), "Thread start failed")
      -- TODO: add result checking with wait method
      t.expect(thread.wait(sut), "Thread wait failed")
   end)

   t.it("Wait method can get failed code exception", function ()
      local code = "assert(false, 'This is an exception')"
      local sut = thread.create(code)

      thread.start(sut)
      local result, msg = thread.wait(sut)

      t.expect(not result, "Thread code was successful")
      t.expect(msg, "Error message is nil")
   end)

   t.it("Thread can't be run multiple times", function ()
      local code = "print('Hello, Javie')"
      local sut = thread.create(code)

      local firstResult = thread.start(sut)
      local secondResult = thread.start(sut)
      thread.wait(sut)

      t.expect(firstResult, "First start is successful")
      t.expect(not secondResult, "Second start isn't an error")
   end)
end)
