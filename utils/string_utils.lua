---@return boolean
function string:is_empty()
    return #self == 0
end

function string:trimr()
    return string.gsub(self, "%s+$", "")
end

function string:triml()
    return string.gsub(self, "^%s+", "")
end

function string:trim()
    return self:trimr():triml()
end
