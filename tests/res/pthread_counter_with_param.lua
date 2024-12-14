local f = assert(io.open("logs.log", "w"))
local i = 1
local max = tonumber(...)

while true do
   f:write("Index: " .. i .. "\n")

   i = i + 1

   if i > max then
      break
   end
end

f:close()
