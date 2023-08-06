require("tests/cbase_test_case")
require("cfile_manager.file_manager")

FileManagementTestCase = CTestCase

function FileManagementTestCase:test_get_all_files_in_dir()
    local filesByHelper = FM.get_dir_content { file_type = FileType.FILE }
    local cmd = "find . -type f"

    local filesByCmd = FM.get_lines_from_file(io.popen(cmd, IOMODE.READ))

    return #filesByHelper == #filesByCmd
end

function FileManagementTestCase:test_get_files_by_extension_in_dir()
    local filesByHelper = FM.get_dir_content {
        file_type = FileType.FILE,
        name_pattern = "*.vim"
    }
    local cmd = 'find . -type f -name "*.vim"'

    local filesByCmd = FM.get_lines_from_file(io.popen(cmd, IOMODE.READ))

    return #filesByHelper == #filesByCmd
end

function FileManagementTestCase:test_get_files_with_depth_in_dir()
    local filesByHelper = FM.get_dir_content {
        max_depth = 1
    }
    local cmd = 'find "."  -name "*" -maxdepth 1'

    local filesByCmd = FM.get_lines_from_file(io.popen(cmd, IOMODE.READ))

    return #filesByHelper == #filesByCmd
end

function FileManagementTestCase:test_is_file_exists_true()
    local existing_file = FM.get_dir_content {
        file_type = FileType.FILE,
        maxdepth = 1
    }[1]

    return FM.is_file_exists(existing_file)
end

function FileManagementTestCase:test_is_file_exists_false()
    local none_existing_file = "~/somerandomfile.txt"

    return FM.is_file_exists(none_existing_file) == false
end

FileManagementTestCase:run_tests()
