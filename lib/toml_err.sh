#!/usr/bin/env bash
# File that manages errors and return values
# for the bash toml tool. This tool will
# output different return codes and this
# file simply houses those codes and there
# messages. A function can be used to capture
# the error messages from stdout.

## Source Guard
if [[ -v TOML_ERR_SOURCED ]]; then return 0; fi
TOML_ERR_SOURCED=1

TOML_ERROR_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Defines return codes
TOML_SUCCESS=0
TOML_ERROR=1
TOML_NO_TABLE=2
TOML_NO_KEY=3
TOML_WRITE_FAILED=4
TOML_NO_FILE=5
TOML_INVALID_ARGS=6
TOML_READ_FAILED=7


# maps return codes to a message.
declare -A toml_err_str=(
    [0]="Success"
    [1]="Error"
    [2]="No table found"
    [3]="No Key found"
    [4]="Write Failed"
    [5]="File Not found"
    [6]="Invalid args"
    [7]="File read error"
)

# toml_err_to_str <return code>
# This will output the error message to stdout
# Capture this output to use is in your project.
#	local str=$(toml_err_to_str $?)
# place something like thais after calling a toml <command>.
#
# Since bash return codes must be [0,255], this function will check
# the number given if the error is not in the toml_err_str array
# this function will set the rc to -1 and print an error.
# This function returns 0, 1 based on success/failure not to
# be confused with the error codes for the toml tool
toml_err_to_str() {
    local rc="$1"

    # Check if that error code is valid.
    if [[ ! -v toml_err_str["$rc"] ]]; then
	rc=-1
    fi
    
    if [[ "$rc" == -1 ]]; then
	echo "Invalid return code detected."
	return 1
    fi

    echo "${toml_err_str[$rc]}"
    return 0
}
