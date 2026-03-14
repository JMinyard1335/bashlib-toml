#!/usr/bin/env bash
# Used to test the toml check

TEST_CHECK_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source  "$TEST_CHECK_DIR"/test_helpers.sh
source ../lib/toml_check.sh
source ../lib/toml_err.sh 

echo "Running Toml Check Tests..."

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
    toml_check_file test.toml hello w a d
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check file should fail with to many args."
    
    echo "Testing check file to many args"
    toml_check_file
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_INVALID_ARGS" "check file should fail with to few args."

    echo "Testing non toml file extension"
    toml_check_file file.txt
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_false "$status" "Non toml files should fail; $str : $status"
    
    echo -e "\e[32mAll check file test passed successfully\e[0m"
}

test_check_table() {
    local str="" status=""
    echo "Starting check table tests..."    

    echo "Testing existing table..."
    toml_check_table test.toml project
    status="$?"
    assert_true "$status" "failed to fetch table from file status: $status"
    
    echo "Testing non existing table..."
    toml_check_table test.toml foo
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_NO_TABLE" "$str : $status "
    
    echo "Testing missing file..."
    toml_check_table test1.toml project
    status="$?"
    str="$(toml_err_to_str "$status")"
    assert_eq "$status" "$TOML_NO_FILE" "Should fail with $TOML_NO_FILE,  $str : $status"
    
    echo -e "\e[32mAll check table test passed successfully\e[0m"
}


test_check_key() {
    local str="" status=""
    echo "Starting check key tests..."

    echo "Testing valid key"
    toml_check_key test.toml project repo
    status="$?"
    str=toml_err_to_str "$status"
    assert_true "$status" "$str : $status"
    
    echo "Testing invalid key"
    
}

test_check_file
test_check_table
test_check_key
