package = "cluautils"
version = "1.2-1"
source = {
   url = "git+ssh://git@github.com/castlele/cluautils.git",
    tag = "1.2.0"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "MIT"
}
dependencies = {
    "lua ~> 5.1",
    "json-lua >= 0.1"
}
build = {
   type = "builtin",
   modules = {
      ["cluautils.tests.base_test_case"] = "src/tests/base_test_case.lua",
      ["cluautils.file_manager"] = "src/file_manager/file_manager.lua",
      ["cluautils"] = "src/cluautils.lua",
      ["cluautils.string_utils"] = "src/string_utils/string_utils.lua",
      ["cluautils.table_utils"] = "src/table_utils/table_utils.lua",
   },
   copy_directories = {
      "tests"
   }
}
