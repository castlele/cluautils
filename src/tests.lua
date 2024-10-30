---@class Tests
---@field describe fun(label: string, func: function)
---@field it fun(name: string, func: function)
---@field expect fun(condition: boolean, message: string?)
local tests = {}


tests.describe = function(label, func)
end

tests.it = function(name, func)
end

tests.expect = function(condition, message)
end


return tests
