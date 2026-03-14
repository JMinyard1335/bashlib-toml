#!/usr/bin/env

TOML_LIB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$TOML_LIB_DIR"/toml_check.sh		# Used to check contents of toml file and if the file exists.
source "$TOML_LIB_DIR"/toml_read.sh			# Used to read values from a toml file to stdout for capture.
source "$TOML_LIB_DIR"/toml_write.sh		# Used to write key value pairs to a toml file.
source "$TOML_LIB_DIR"/toml_err.sh			# Used to define and print toml errors
source "$TOML_LIB_DIR"/toml_helpers.sh		# Additional helpers
