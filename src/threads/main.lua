local t = require("thread")

local threadCode = [[
local i = 0
local max = ...
local f = assert(io.open("logs.log", "w"))

while true do
   print()
   f:write("Index: " .. i .. "\n")

   i = i + 1

   if i > max then
      break
   end
end

f:close()
]]
local threadFilePath = "counter.lua"

local thread = t.new(threadCode, "joinable")

t.start(thread, 10)

local i = 0

while true do
   print("Main thread: " .. i)
   i = i + 1

   if i > 20 then
      break
   end
end

t.wait(thread)
