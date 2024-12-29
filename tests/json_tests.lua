require("src.tests.base_test_case")
local sut = require("src.json.json")

JsonTestCase = CTestCase

---@MARK - Decoder tests

function JsonTestCase:test_decode_empty_string()
    local str = ""

    local decoded_object = sut.decode(str)

    return decoded_object == nil
end

function JsonTestCase:test_decode_string()
    local str = "hello, world"

    local decoded_object = sut.decode(str)

    return decoded_object == nil
end

function JsonTestCase:test_decode_comment_string()
    local str = "// hello, world"

    local decoded_object = sut.decode(str)

    return decoded_object == nil
end

function JsonTestCase:test_decode_comment_string_out_of_object_scope()
    local str = [[
// hello, world

{
    "hello": "world"
}
]]

    local decoded_object = sut.decode(str)

    return decoded_object ~= nil and decoded_object["hello"] == "world"
end

function JsonTestCase:test_decode_array()
    local str = [[
[
    {
        "string": "hello, world",
        "number": 100
    }
]
]]

    local decoded_object = sut.decode(str, JsonType.ARRAY)

    return decoded_object ~= nil and decoded_object[1]["string"] == "hello, world"
end

function JsonTestCase:test_decode_json_with_innter_array()
    local str = [[
{
    "array": [1, 2, 3, 4, 5]
}
    ]]

    local decoded_object = sut.decode(str)

    return decoded_object ~= nil and #decoded_object.array == 5
end

---@MARK - Encoder tests

function JsonTestCase:test_encode_empty_object()
    local obj = {}

    local encoded_object = sut.encode(obj)

    return encoded_object == "{}"
end

function JsonTestCase:test_encode_object_with_nil_fields()
    local obj = {str = "hello, world", num = nil}
    local expected_string = '{"str":"hello, world"}'

    local encoded_object = sut.encode(obj)

    return encoded_object == expected_string
end

function JsonTestCase:test_encode_object_without_nil_fields()
    local obj = {str = "hello, world", num = 1}
    local expected_string = '{"num":1,"str":"hello, world"}'

    local encoded_object = sut.encode(obj)

    return encoded_object == expected_string
end

JsonTestCase:run_tests()
