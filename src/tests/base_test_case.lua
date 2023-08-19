local error_color = "\27[31m"
local success_color = '\27[32m'
local clear_color = "\27[0m"

CTestCase = {}

function CTestCase:new(o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self

      return o
end

---@param test_name string
---@return boolean
function CTestCase:_is_private(test_name)
    local is_private = test_name:find("_", 1, true) == 1
    local is_init = test_name == "new"
    local is_assert = test_name:find("assert*", 1, false) ~= nil
    local is_run_tests = test_name:find("run_tests", 1, true) ~= nil
    local is_test_case = test_name:find("test*", 1, false) ~= nil

    return is_private or is_init or is_assert or is_run_tests or not is_test_case
end

---Method runs before every test case
function CTestCase:set_up()
    -- Should be overriden in subclasses
end

---Method runs after every test case
function CTestCase:tear_down()
    -- Should be overriden in subclasses
end

function CTestCase:run_tests()
    local table = getmetatable(self) or self

    for test_name, test_case in pairs(table) do
        if not self:_is_private(test_name) then
            print("Running test case: {" .. test_name .. "}")
            self:set_up()

            local result = test_case()
            local message = ""
            local color = ""


            if result == nil or result then
                message = "%sTest case: {" .. test_name .. "} has passed successfully%s"
                color = success_color
            else
                message = "%sTest case: {" .. test_name .. "} has failed%s"
                color = error_color
            end

            self:tear_down()
            print(message:format(color, clear_color))
        end
    end
end
