#!/usr/bin/env

TOML_LIB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$TOML_LIB_DIR"/internal/toml_check.bash		# Used to check contents of toml file and if the file exists.
source "$TOML_LIB_DIR"/internal/toml_read.bash			# Used to read values from a toml file to stdout for capture.
source "$TOML_LIB_DIR"/internal/toml_write.bash		# Used to write key value pairs to a toml file.
source "$TOML_LIB_DIR"/internal/toml_err.bash			# Used to define and print toml errors
source "$TOML_LIB_DIR"/internal/toml_helpers.bash		# Additional helpers
