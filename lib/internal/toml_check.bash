#!/usr/bin/env bash
# Used to check various aspects
# of the toml file (file, table, value)


## Source Guard --------------------------------------------------------------------------
## DO NOT REMOVE! UNDER PAIN OF DEATH!
# This is used to keep from ending up in a source loop
# if this file has been sourced we simply return out of
# the script.
if [[ -v _toml_check_sourced ]]; then return 0; fi
_toml_checked_sourced=1
## ---------------------------------------------------------------------------------------


# refrences where this script is located,
# useful in sourcing other files from the tools lib.
toml_check_lib_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Bring in the rest of the library
source "${toml_check_lib_dir}/toml_err.bash"
source "${toml_check_lib_dir}/toml_helpers.bash"


# toml_check_file <file>
# Checks to see if there is a toml file at the given path.
# file must be a `.toml` file or this should fail.
# Returns
#	0, if success
#	1, if error
#	5, File error
#	6, Invalid args
toml_check_file() {
    local file="$1" ext=""
    toml_check_arg_count "$#" 1 || {
	toml_error "toml_check_file: Invalid argument count $#/1" ; return "$TOML_INVALID_ARGS";
    }
   
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
# Checks the given toml file for the desired key.
# The key must be in the desired table.
# Returns:
#	0, if success
#	2, if no table
#	5, if no file
#	6, invalid args
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

# toml_check_key_all <file> <key>
# Checks the entire toml file for the key.
# Returns:
#       0, if success
#       3, if no key
#       5, if no file
#       6, invalid args
toml_check_key_all() {
    toml_check_arg_count "$#" 2 || {
        toml_error "toml_check_key_all: Invalid argument count $#/2"
        return "$TOML_INVALID_ARGS"
    }

    local file="$1" key="$2"

    if ! toml_check_file "$file"; then
        return "$TOML_NO_FILE"
    fi

    grep -Eq "^[[:space:]]*${key}[[:space:]]*=" "$file" && return "$TOML_SUCCESS"

    return "$TOML_NO_KEY"
}
