#!/usr/bin/env bash

if [[  -v TOML_READ_SOURCED ]]; then return 0; fi
TOML_READ_SOURCED=1

TOML_READ_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$TOML_READ_DIR"/toml_lib.sh

# toml_read_file <file>
# reads a toml file and sends it to stdout to be captured.
toml_read_file() {
    local file="$1" status=""
    toml_check_file "$file"
    status="?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_FILE"
    fi
    
    return 0
}

# toml_read_table <file> <table>
# reads out the given table and all its entries to stdout
toml_read_table () {
    # Check the number of arguments.

    # declare vars
    local file="$1" table="$2" status=""

    # Check file
    toml_check_file "$file"
    status="?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_FILE"
    fi

    # Check table
    toml_check_table "$file" "$table"
    status="?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_TABLE"
    fi

    # Readout the whole table to stdout for capture
    
    return 0
}

# toml_read_key <file> <table> <key>
# reads the desired key value pair into stdout
toml_read_key() {
    # declare vars
    local file="$1" table="$2" status=""
    
    # Check file
    toml_check_file "$file"
    status="?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_FILE"
    fi
    
    # Check table
    toml_check_table "$file" "$table"
    status="?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_TABLE"
    fi

    toml_check_key "$file" "$table" "$key"
    status="$?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_KEY"
    fi
    
    return 0
}
