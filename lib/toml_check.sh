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
    
    local file="$1" ext=""

    # Check if there is a file
    if [[ ! -f "$file" ]]; then
	return "$TOML_NO_FILE"
    fi

    # Check if it is a `.toml`
    ext="${file##*.}"
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
    toml_check_arg_count "$#" 3 || {
        toml_error "toml_check_key: Invalid argument count $#/3"
        return "$TOML_INVALID_ARGS"
    }

    local file="$1" table="$2" key="$3"
    
    if ! toml_check_file "$file"; then
        return "$TOML_NO_FILE"
    fi

    if ! toml_check_table "$file" "$table"; then
	echo "maybe here??"
        return "$TOML_NO_TABLE"
    fi

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

            found = 1
            exit
        }

        END {
            if (!found) exit 1
        }
    ' "$file" && return "$TOML_SUCCESS"

      
    return "$TOML_NO_KEY"
}

# toml_check_valid <file>
# a stronger file check also makes sure the toml inside is not malformed.
toml_check_valid() {
    echo "toml_check_valid: not implemented will always fail"
    return 1
}

