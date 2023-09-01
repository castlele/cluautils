# cluautils

This is a package with useful functions to use in your lua programs. You can use it with lua version 5.1 and higher.

Currently available APIs:
* [base utils](./src/cluautils)
* [string utils](./src/string_utils/string_utils)
* [table utils](./src/table_utils/table_utils)
* [json encoding/decoding api](./src/json/json.lua)
* [file manager utils](./src/file_manager/file_manager.lua)
* [base test case](./src/tests/base_test_case.lua)

## Installation

Luarocks online installation isn't available yet, couse library is still in development. But you can do it locally:

```sh
git clone git@github.com:castlele/cluautils.git

cd cluautils

luarocks make
```
