#!/usr/bin/env bash
# Collection of helper functions for
# the toml tool. these helpers should
# be here becaused they are used throughout
# the project to cut down or repetation.


TOML_HELPER_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"


# Output helpers ----------------------------------------------
# These are all redirected to stderr so that commands that
# need to capture stdout will not end up capturing
# generic debugging info.

toml_log() { # generic output 
    printf "${CYAN}[Toml]:${RESET} %s\n" "$*" >&2
}

toml_success() { # Success output
    printf "${GREEN}[Toml]:${RESET} %s\n" "$*" >&2
}

toml_error() { # error output
    printf "${RED}[Toml]:${RESET} %s\n" "$*" >&2
}

toml_warn() { # warning output
    printf "${YELLOW}[Toml]:${RESET} %s\n" "$*" >&2
}
# --------------------------------------------------------------

# toml_check_arg_count $# <number>
# Takes in the argument count and the
# number of args you are expecting
# Returns
#	0: True
#	1: False
#	6: invalid args
toml_check_arg_count() {
    [ "$#" -eq 2 ] || {
	echo "invalid use of 'toml_check_arg_count'"
	echo "Usage: toml_check_arg_count <arg count> <desired arg count>"
	return 6
    }
    
    local count="$1" desired="$2"
    
    if [ ! "$count" -eq "$desired" ]; then
	return 1
    fi    
    return 0
}
