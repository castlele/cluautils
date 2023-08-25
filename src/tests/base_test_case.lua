local error_color = "\27[31m"
local success_color = '\27[32m'

local function log_message(msg)
    print(msg)
end

local function log_success(msg)
    if vim ~= nil then
        vim.notify(msg, vim.log.levels.INFO, {})
        return
    end

    log_message(success_color .. msg .. success_color)
end

local function log_error(msg)
    if vim ~= nil then
        vim.notify(msg, vim.log.levels.WARN)
        return
    end

    log_message(error_color .. msg .. error_color)
end

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
            log_message("Running test case: {" .. test_name .. "}")
            self:set_up()

            local result = test_case()

            if result == nil or result then
                log_success("Test case: {" .. test_name .. "} has passed successfully")
            else
                log_error("Test case: {" .. test_name .. "} has failed")
            end

            self:tear_down()
        end
    end
end
