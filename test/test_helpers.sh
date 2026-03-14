#!/usr/bin/env bash
# Testing framework for bash scripts

TEST_SUCCESS=0
TEST_FAIL=1
INVALID_ARGS=2

# assert <clause1> <clause2> <operator?> <message?>
# assert is the general puropse assert call
# and all other assert function in this file
# could be reconstructed with this function
# in fact most if not all of them are implemented
# using this function.
#
# Arguments:
#	clause1: The first value
#	clause2: The second value
#	operator: the equality operator
#	message: An optionl message to be printed before exit
#
# exits 0, 1 based on the test result
# or 2 if the args are invalid
assert() {
    if [[ "$#" -lt 2 || "$#" -gt 4 ]]; then
        return "$INVALID_ARGS"
    fi

    local c1="$1" c2="$2" op="-eq" msg=""

    if [[ "$#" -eq 3 ]]; then
        case "$3" in
            -eq|-ne|-lt|-le|-gt|-ge|=|!=) op="$3" ;;
            *) msg="$3" ;;
        esac
    elif [[ "$#" -eq 4 ]]; then
        case "$3" in
            -eq|-ne|-lt|-le|-gt|-ge|=|!=) op="$3" ;;
            *)
                printf '\e[31m[Failed]:\e[0m invalid operator: %s\n' "$3"
                exit "$INVALID_ARGS"
                ;;
        esac
        msg="$4"
    fi

    if test "$c1" "$op" "$c2"; then
        return "$TEST_SUCCESS"
    fi

    [[ -n "$msg" ]] && printf '\e[31m[Failed]:\e[0m %s\n' "$msg"
    exit "$TEST_FAIL"
}

# assert_eq <value1> <value2> <message?>
assert_eq() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 3 ]]; then
        assert "$1" "$2" "=" "$3"
    else
        assert "$1" "$2" "="
    fi
}

# assert_lt <value1> <value2> <message?>
assert_lt() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 3 ]]; then
        assert "$1" "$2" -lt "$3"
    else
        assert "$1" "$2" -lt
    fi
}

# assert_le <value1> <value2> <message?>
assert_le() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 3 ]]; then
        assert "$1" "$2" -le "$3"
    else
        assert "$1" "$2" -le
    fi
}

# assert_gt <value1> <value2> <message?>
assert_gt() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 3 ]]; then
        assert "$1" "$2" -gt "$3"
    else
        assert "$1" "$2" -gt
    fi
}

# assert_ge <value1> <value2> <message?>
assert_ge() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 3 ]]; then
        assert "$1" "$2" -ge "$3"
    else
        assert "$1" "$2" -ge
    fi
}

# assert_true <return code> <message?>
assert_true() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 2 ]]; then
        assert "$1" 0 -eq "$2"
    else
        assert "$1" 0 -eq
    fi
}

# assert_false <return code> <message?>
assert_false() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    if [[ "$#" -eq 2 ]]; then
        assert "$1" 0 -ne "$2"
    else
        assert "$1" 0 -ne
    fi
}


## String Assertions --------------------
# assert_str_eq <str1> <str2>
assert_str_eq() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        exit "$INVALID_ARGS"
    fi
    
    if [[ "$#" -eq 3 ]]; then
        assert "$1" "$2" "=" "$3"
    else
        assert "$1" "$2" "="
    fi
}


## File Assertions -----------------------

assert_exists() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -e "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_file() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -f "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_symlink() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -L "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_socket() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -S "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_pipe() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -p "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_writeable() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -w "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_readable() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -r "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_executable() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -x "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}

assert_directory() {
    if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
        exit "$INVALID_ARGS"
    fi

    [[ -d "$1" ]]
    if [[ "$#" -eq 2 ]]; then
        assert "$?" 0 -eq "$2"
    else
        assert "$?" 0 -eq
    fi
}
