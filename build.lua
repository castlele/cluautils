---@diagnostic disable-next-line
conf = {
   install = "luarocks make",
   allTest = [[
      ./run_tests.sh "*"
   ]],
   threadTest = [[
      bear -- make build
      make test_thread
      ./run_tests.sh "cthread*"
   ]],
   memoryTest = [[
      bear -- make build
      ./run_tests.sh "cmemory*"
   ]],
   oopTest = "./run_tests.sh \"oop*\""
}
