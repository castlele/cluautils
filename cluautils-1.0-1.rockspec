package = "cluautils"
version = "1.0-1"
source = {
   url = "git+ssh://git@github.com/castlele/cluautils.git",
    tag = "1.0.0"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "MIT"
}
dependencies = {
    "lua >= 5.4",
    "json-lua >= 0.1"
}
build = {
   type = "builtin",
   modules = {
      ["cfile_manager.file_manager"] = "cfile_manager/file_manager.lua",
      ["utils.shared"] = "utils/shared.lua",
      ["utils.string_utils"] = "utils/string_utils.lua",
      ["utils.table_utils"] = "utils/table_utils.lua"
   },
   copy_directories = {
      "tests"
   }
}
