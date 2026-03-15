#!/usr/bin/env bash

if [[  -v TOML_READ_SOURCED ]]; then return 0; fi
TOML_READ_SOURCED=1

TOML_READ_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$TOML_READ_DIR/../toml_lib.bash"

# toml_read_file <file>
# reads a toml file and sends it to stdout to be captured.
# does not clean out comments or change format.
toml_read_file() {
    local file="$1" status=""
    toml_check_file "$file"
    status="$?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_FILE"
    fi

    # Read out the full file
    cat "$file"   
    return 0
}

# toml_read_table <file> <table>
# reads out the given table and all its entries to stdout
toml_read_table () {
    # Check the number of arguments.
    toml_check_arg_count "$#" 2 || {
        toml_error "toml_read_table: Invalid argument count $#/3"
        return "$TOML_INVALID_ARGS"
    }
    
    # declare vars
    local file="$1" table="$2" status=""

    # Check file
    toml_check_file "$file"
    status="$?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_FILE"
    fi

    # Check table
    toml_check_table "$file" "$table"
    status="$?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_TABLE"
    fi

    # Readout the whole table to stdout for capture
    awk -v table="$table" '
        BEGIN {
            in_table = 0
            found = 0
        }

        # entering any table header
        /^[[:space:]]*\[/ {
            if (in_table) exit 0
            in_table = 0
        }

        # target table header
        $0 ~ "^[[:space:]]*\\[" table "\\][[:space:]]*$" {
            in_table = 1
            found = 1
            next
        }

        # while in table, skip blank lines and pure comments
        in_table && /^[[:space:]]*$/ { next }
        in_table && /^[[:space:]]*#/ { next }

        # print key/value pairs
        in_table && /^[[:space:]]*[^#][^=]*=[[:space:]]*/ {
            line = $0

            # split key from value
            key = line
            sub(/=.*/, "", key)
            sub(/^[[:space:]]+/, "", key)
            sub(/[[:space:]]+$/, "", key)

            value = line
            sub(/^[^=]+=[[:space:]]*/, "", value)
            sub(/[[:space:]]+#.*$/, "", value)
            sub(/^[[:space:]]+/, "", value)
            sub(/[[:space:]]+$/, "", value)

            if (value ~ /^".*"$/) {
                sub(/^"/, "", value)
                sub(/"$/, "", value)
            }

            printf "%s, \047%s\047\n", key, value
        }

        END {
            if (!found) exit 1
        }
    ' "$file"

    status="$?"
    if [ "$status" -eq 0 ]; then
        return "$TOML_SUCCESS"
    fi

    return "$TOML_NO_TABLE"
}

# toml_read_key <file> <table> <key>
# reads the desired key value pair into stdout for capture
toml_read_key() {
    # Check the args
    toml_check_arg_count "$#" 3 || {
        toml_error "toml_read_key: Invalid argument count $#/3"
        return "$TOML_INVALID_ARGS"
    }
   
    # declare vars
    local file="$1" table="$2" key="$3" status=""
    
    # Check file
    toml_check_file "$file"
    status="$?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_FILE"
    fi
    
    # Check table
    toml_check_table "$file" "$table"
    status="$?"
    if [ "$status" -ne "$TOML_SUCCESS" ]; then
	toml_error "Invalid toml file"
	return "$TOML_NO_TABLE"
    fi

    # Read key from the table to stdout for capture
    awk -v table="$table" -v key="$key" '
        BEGIN {
            in_table = 0
            found = 0
        }

        # Detect table headers
        /^[[:space:]]*\[/ {
            in_table = 0
        }

        $0 ~ "^[[:space:]]*\\[" table "\\][[:space:]]*$" {
            in_table = 1
            next
        }

        # While inside the target table, find key = value
        in_table && $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
            line = $0

            # remove "key ="
            sub(/^[[:space:]]*[^=]+=[[:space:]]*/, "", line)

            # trim trailing comment
            sub(/[[:space:]]+#.*$/, "", line)

            # trim surrounding whitespace
            sub(/^[[:space:]]+/, "", line)
            sub(/[[:space:]]+$/, "", line)

            # strip surrounding double quotes if present
            if (line ~ /^".*"$/) {
                sub(/^"/, "", line)
                sub(/"$/, "", line)
            }

	    print key ", \047" line "\047"
            found = 1
            exit
        }

        END {
            if (!found) exit 1
        }
	' "$file" && return "$TOML_SUCCESS"

    return "$TOML_READ_FAILED"
}

