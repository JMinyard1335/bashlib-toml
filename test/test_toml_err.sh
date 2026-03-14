#!/usr/bin/env bash

# DETERMINES THE LOCATION OF THIS FILE DO NOT REMOVE.
TEST_TOML_ERROR_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# pull in the files needed for testing.
source ../lib/toml_err.sh
source "$TEST_TOML_ERROR_DIR"/test_helpers.sh

test_err_to_str() {
    local str=""
    
    str="$(toml_err_to_str 0)"
    assert_str_eq "$str" "$TOML_SUCCESS_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 1)"
    assert_str_eq "$str" "$TOML_ERROR_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 2)"
    assert_str_eq "$str" "$TOML_NO_TABLE_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 3)"
    assert_str_eq "$str" "$TOML_NO_KEY_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 4)"
    assert_str_eq "$str" "$TOML_WRITE_FAILED_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 5)"
    assert_str_eq "$str" "$TOML_NO_FILE_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 6)"
    assert_str_eq "$str" "$TOML_INVALID_ARGS_STR" "fetched the wrong error message."
    str="$(toml_err_to_str 7)"
    assert_str_eq "$str" "$TOML_READ_FAILED_STR" "fetched the wrong error message."

}


echo -e "\e[1;36m[TEST]:\e[0m Running test for toml_err.sh"
test_err_to_str
echo -e "\e[1;32m[TEST]:\e[0m All toml_err.sh test passed!!!"
