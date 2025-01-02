---@param cmd string
---@return string
local function runTestsCommand(cmd)
   local runner = "./run_tests.sh \"%s\""
   return string.format(runner, cmd)
end

---@diagnostic disable-next-line
conf = {
   install = "sudo luarocks make",
   remove = "sudo luarocks remove cluautils",
   allTest = runTestsCommand("*"),
   threadTest = [[
      bear -- make build
      make test_thread
   ]] .. runTestsCommand("cthread*"),
   memoryTest = [[
      bear -- make build
   ]] .. runTestsCommand("cmemory*"),
   oopTest = runTestsCommand("oop"),
   stringTest = runTestsCommand("string_utils*"),
   jsonTest = runTestsCommand("json*"),
   fmTest = runTestsCommand("file_manager*"),
}
