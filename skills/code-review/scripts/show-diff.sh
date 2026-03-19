#!/bin/bash
# Show git diff but exclude files defined in IGNORE_FILES from .env

set -e

# Load environment variables from .env file (if exists)
if [ -f "$(dirname "$0")/.env" ]; then
  set -a  # Auto-export loaded variables
  source "$(dirname "$0")/.env"
  set +a
fi

# Build exclude pathspecs for git
EXCLUDES=()
if [ -n "$IGNORE_FILES" ]; then
  for pattern in $IGNORE_FILES; do
    # git pathspec exclude syntax
    EXCLUDES+=(":(exclude)$pattern")
    # Also exclude if it's in a subdirectory
    EXCLUDES+=(":(exclude)**/$pattern")
  done
fi

# Execute git diff with any additional arguments passed to the script,
# followed by the exclusions
git --no-pager diff HEAD "$@" -- . "${EXCLUDES[@]}"
