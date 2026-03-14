#!/usr/bin/env bash
# Used to test the toml check

TEST_CHECK_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source  "$TEST_CHECK_DIR"/test_helpers.sh
source ../lib/toml_check.sh
source ../lib/toml_err.sh 

test_check_file() {
    local str="" status=""

    echo "Testing file exists"
    toml_check_file test.toml
    status="$?"
    assert_true "$status" "check file failed with a code $status, should have passed"
    
    echo "Testing file does not exists"
    toml_check_file test1.toml
    status="$?"
    assert_eq "$status" "$TOML_NO_FILE" "toml_check_file should have exited with 5 but exited with $status"
    
    echo "Testing check file to many args"
    toml_check_file test.toml hello w a d 2>/dev/null
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check file should fail with to many args."
    
    echo "Testing check file to few args"
    toml_check_file 2>/dev/null
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check file should fail with to few args."

    echo "Testing non toml file extension"
    toml_check_file file.txt
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_false "$status" "Non toml files should fail; $str : $status"  

    echo -e "\e[1;32m[TEST]:\e[0m all File checks passed.!!!"
}

test_check_table() {
    local str="" status=""

    echo "Testing existing table..."
    toml_check_table test.toml project
    status="$?"
    assert_true "$status" "failed to fetch table from file status: $status"
    
    echo "Testing non existing table..."
    toml_check_table test.toml foo
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_NO_TABLE" "$str : $status "
    
    echo "Testing check table to many args"
    toml_check_table test.toml hello w a d qwert 2>/dev/null
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check table should fail with to many args."
    
    echo "Testing check table to few args"
    toml_check_table 2>/dev/null
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check table should fail with to few args."

    echo "Testing missing file..."
    toml_check_table test1.toml project
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_NO_FILE" "Should fail with $TOML_NO_FILE,  $str : $status"
    
    echo -e "\e[1;32m[TEST]:\e[0m all table checks passed.!!!"  
}

test_check_key() {
    local str="" status=""
    
    toml_check_key test.toml project repo
    status="$?"
    str=$(toml_err_to_str "$status")
    assert_true "$status" "$str : $status"
    
    echo "Testing invalid key"
    toml_check_key test.toml project hippo
    status="$?"
    str=$(toml_err_to_str "$status")
    assert_false "$status" "$str : $status"

    echo "Testing check key to many args"
    toml_check_file test.toml hello w a d qwert 2>/dev/null
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check key should fail with to many args."
    
    echo "Testing check key to few args"
    toml_check_key 2>/dev/null
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check key should fail with to few args."

    echo -e "\e[1;32m[TEST]:\e[0m all check key test passed.!!!"
}


echo -e "\e[1;36m[TEST]:\e[0m Running test for toml_check.sh"
test_check_file
test_check_table
test_check_key
echo -e "\e[1;32m[TEST]:\e[0m All toml_check.sh test passed!!!"
