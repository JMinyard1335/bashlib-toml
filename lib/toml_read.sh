#!/usr/bin/env bash

if [[  -v TOML_READ_SOURCED ]]; then return 0; fi
TOML_READ_SOURCED=1

TOML_READ_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$TOML_READ_DIR"/toml_lib.sh

# toml_read_file <file>
# reads a toml file and sends it to stdout to be captured.
toml_read_file() {
    return 0
}

# toml_read_table <file> <table>
# reads out the given table and all its entries to stdout
toml_read_table () {
        return 0
}

# toml_read_key <file> <table> <key>
# reads the desired key value pair into stdout
toml_read_key() {
        return 0
}
