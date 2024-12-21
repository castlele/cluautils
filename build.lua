---@diagnostic disable-next-line
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
   ]],
   oopTest = "./run_tests.sh \"oop*\"",
   collectionInterfaceTest = "./run_tests.sh \"collection_interface*\"",
   hashMapTest = "./run_tests.sh \"hashmap*\""
}
