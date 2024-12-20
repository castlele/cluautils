conf = {
   install = "luarocks make",
   threadTests = [[
      make build
      make test_thread
      ./run_tests.sh "cthread*"
   ]],
}
