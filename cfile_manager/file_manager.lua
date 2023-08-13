require("utils.cutils")

FM = FM or {}

---@param file? file*
---@param mode? readmode
---@return table
function FM.get_lines_from_file(file, mode)
    if file == nil then
        return {}
    end

    local result = {}

    for line in file:lines(mode or "*l") do
        table.insert(result, line)
    end

    return result
end

---@MARK - File system manipulations

FileType = {
    DIR = "d",    -- directory
    FILE = "f",   -- regular file
    CHAR = "c",   -- character special
    LINK = "l",   -- symbolic link
    FIFO = "p",   -- FIFO
    SOCKET = "s", -- socket
}

IOMODE = {
    READ = "r",
    WRITE = "w",
    OVERRIDE = "w+"
}

---Writes to file with writer function
---@param file_path string
---@param mode? openmode
---@param writer fun():string
function FM.write_to_file(file_path, mode, writer)
    local file = io.open(file_path, mode or IOMODE.WRITE)

    if file == nil then
        return
    end

    file:write(writer())

    io.close(file)
end

---Removes file at a given path
---@param file_path string
function FM.delete_file(file_path)
    os.remove(file_path)
end

---Checks if file exists at the path
---@param file_path string
---@param mode?    openmode
---@return boolean
function FM.is_file_exists(file_path, mode)
    local file = io.open(file_path, mode or IOMODE.READ)

    if file == nil then
        return false
    else
        io.close(file)

        return true
    end
end

---@class find
---@field dir_path string
---@field file_type FileType
---@field name_pattern string
---@field max_depth string|integer
---
---@enum FileType
---local FileType = {
---    DIR = "d",    -- directory
---    FILE = "f",   -- regular file
---    CHAR = "c",   -- character special
---    LINK = "l",   -- symbolic link
---    FIFO = "p",   -- FIFO
---    SOCKET = "s", -- socket
---}
---
--- Find terminal command implementation
---
---@param param_table find
---@return table
function FM.get_dir_content(param_table)
    setmetatable(param_table, { __index = {
        dir_path = ".",
        file_type = nil,
        name_pattern = "*",
        max_depth = nil,
    }})

    local dir_path = param_table.dir_path
    local file_type = param_table.file_type
    local name_pattern = param_table.name_pattern
    local max_depth = param_table.max_depth

    local sep = " "
    local find_cmd = 'find "' .. dir_path .. '"'
    local file_param = ""
    local name_param = ""
    local max_depth_param = ""

    if not CUtils.is_string_nil_or_empty(file_type) then
        file_param = '-type ' .. file_type
    end

    if not CUtils.is_string_nil_or_empty(name_pattern) then
        name_param = '-name "' .. name_pattern .. '"'
    end

    if type(max_depth) == "string" then
        if CUtils.is_string_nil_or_empty(tostring(max_depth)) then
            max_depth_param = '-maxdepth ' .. max_depth
        end
    elseif type(max_depth) == "number" and max_depth >= 0 then
        max_depth_param = '-maxdepth ' .. tostring(max_depth)
    end

    local full_cmd = find_cmd .. sep .. file_param .. sep .. name_param .. sep  .. max_depth_param

    return FM.get_lines_from_file(io.popen(full_cmd, IOMODE.READ), "*l")
end

---@param file_path string
---@return boolean false if error occured or file already exists else true
function FM.create_file(file_path)
    if FM.is_file_exists(file_path) then
        return false
    end

    local file = io.open(file_path, IOMODE.WRITE)

    if type(file) == "string" or file == nil then
        return false
    end

    file:close()

    return true
end

return FM
