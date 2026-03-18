#!/usr/bin/env bash
# Used to find and source external dependencies
#
# The point of this file is to make it easy to
# source other external bashlib tools.

# Sources the style libraries.
# Check the return code to see if anything was sourced
source_style() {
    if ! which style; then
	return 1
    fi
    [[ -d "$HOME/.local/lib/style" ]] && { source "$HOME/.local/lib/style/bashlib_style.bash" || return 1; }
    [[ -d "/usr/local/lib/style" ]] && ( source "/usr/local/lib/style/bashlib_style.bash" || return 1; )
    return 0
}
