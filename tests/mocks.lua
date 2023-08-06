MockObject = { str = "", int = 0, tab = {} }

function MockObject:new(o, str, int, tab)
    o = o or {}
    setmetatable(o, self)

    self.__index = self
    self.str = str
    self.int = int
    self.tab = tab

    return o
end
