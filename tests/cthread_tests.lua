local t = package.loadlib("../src/threads/bin/thread.so", "luaopen_thread")
print(t)
require("src.tests")
