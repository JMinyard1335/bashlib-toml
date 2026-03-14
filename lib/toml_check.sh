#!/usr/bin/env bash
# Used to check various aspects
# of the toml file (file, table, value)

# SOURCE GUARD DO NOT REMOVE
# SOURCE GUARD DO NOT REMOVE
if [[ -v TOML_CHECK_SOURCED ]]; then return 0; fi
TOML_CHECK_SOURCED=1

# refrences where this script is located,
# useful in sourcing other files from the tools lib.
TOML_CHECK_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Bring in the rest of the library
source "$TOML_CHECK_DIR/toml_lib.sh"

# toml_check_file <file>
# Checks to see if there is a toml file at the given path.
# file must be a `.toml` file or this should fail.
toml_check_file() {
    toml_check_arg_count "$#" 1 || {
	toml_error "toml_check_file: Invalid argument count $#/1" ; return "$TOML_INVALID_ARGS";
    }
    
    local file="$1"

    # Check if there is a file
    if [[ ! -f "$file" ]]; then
	return "$TOML_NO_FILE"
    fi

    # Check if it is a `.toml`
    local ext="${file##*.}"
    if [[ ! "$ext" == toml ]]; then
	return "$TOML_ERROR"
    fi
    
    return "$TOML_SUCCESS"
}


# toml_check_table <file> <table>
# Checks the given toml file for the desired table
# Returns:
#	0, if success
#	2, if no table
#	5, if no file
#	6, invalid args
toml_check_table() {
    # Validate the number of args
    toml_check_arg_count "$#" 2 || {
	toml_error "toml_check_table: Invalid argument count $#/2" ; return "$TOML_INVALID_ARGS";
    }
    
    local file="$1" table="$2"
    
    if ! toml_check_file "$file"; then
	return "$TOML_NO_FILE"
    fi

    # Check for the table now.
    grep -Fxq "[$table]" "$file" && return "$TOML_SUCCESS"

    return "$TOML_NO_TABLE"
}

# toml_check_key <file> <table> <key>
toml_check_key() {
    echo "check key called"
    toml_check_arg_count "$#" 3 || {
        toml_error "toml_check_key: Invalid argument count $#/3"
        return "$TOML_INVALID_ARGS"
    }

    local file="$1" table="$2" key="$3"
    echo "vars declared"
    
    if ! toml_check_file "$file"; then
        return "$TOML_NO_FILE"
    fi

    echo "file found"
    
    if ! toml_check_table "$file" "$table"; then
	echo "maybe here??"
        return "$TOML_NO_TABLE"
    fi

    echo "table exists"
    
    awk -v table="$table" -v key="$key" '
        function trim(s) {
            sub(/^[[:space:]]+/, "", s)
            sub(/[[:space:]]+$/, "", s)
            return s
        }

        BEGIN {
            in_table = 0
        }

        /^[[:space:]]*($|#)/ {
            next
        }

        $0 == "[" table "]" {
            in_table = 1
            next
        }

        /^[[:space:]]*\[/ {
            if (in_table) exit 1
            next
        }

        in_table && index($0, "=") {
            lhs = $0
            sub(/=.*/, "", lhs)
            lhs = trim(lhs)

            if (lhs == key) exit 0
        }

        END {
            exit 1
        }   
    ' "$file" && return "$TOML_SUCCESS"

    
    echo "awk failed"
    return "$TOML_NO_KEY"
}

# toml_check_valid <file>
# a stronger file check also makes sure the toml inside is not malformed.
toml_check_valid() {
    return 0
}

