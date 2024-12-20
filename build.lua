conf = {
   install = "luarocks make",
   threadTest = [[
      bear -- make build
      make test_thread
      ./run_tests.sh "cthread*"
   ]],
   memoryTest = [[
      bear -- make build
      ./run_tests.sh "cmemory*"
   ]]
}
