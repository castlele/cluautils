local i = 0
local f = assert(io.open("logs.log", "w"))

while true do
   print()
   f:write("Index: " .. i .. "\n")

   i = i + 1

   if i > 22 then
      break
   end
end

f:close()
