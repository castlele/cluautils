---@param cmd string
---@return string
local function runTestsCommand(cmd)
   local runner = "./run_tests.sh \"%s\""
   return string.format(runner, cmd)
end

---@return string
local function getCurrentFileName()
   local filePath = vim.fn.expand("%")
   local pathComponents = vim.fn.split(filePath, "/")
   return pathComponents[#pathComponents]
end

---@diagnostic disable-next-line
conf = {
   install = "sudo luarocks make",
   remove = "sudo luarocks remove cluautils",
   currentTest = runTestsCommand(getCurrentFileName()),
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
   tableTest = runTestsCommand("table_utils*"),
   hashmapTest = runTestsCommand("*hashmap*"),
   linkedlistTest = runTestsCommand("linkedlist*"),
}
