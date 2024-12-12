local f = assert(io.open("logs.log", "w"))
local i = 1

while true do
   f:write("Index: " .. i .. "\n")

   i = i + 1

   if i > 22 then
      break
   end
end

f:close()
