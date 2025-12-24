#!/bin/bash

# ==============================================================================
# Script Name: setup_cline.sh
# Description: Download a file based on directory identifier and save it to a predefined local directory.
#              Create directory if it doesn't exist, overwrite file if it exists.
#
# Usage:       ./setup_cline.sh <fileURL> <directoryIdentifier>
#
# Parameters:
#   <fileURL>            - Complete URL of the static file to download.
#   <directoryIdentifier> - Identifier for target directory, allowed values: hooks, rules, workflows.
#
# Examples:
#   ./setup_cline.sh https://example.com/my-hook.js hooks
#   ./setup_cline.sh https://github.com/user/repo/raw/main/config.json rules
#
# Author:      Kinney Yan
# Version:     1.0
# ==============================================================================

# --- Step 1: Parameter Validation ---

# Check if two parameters are provided
if [ "$#" -ne 2 ]; then
    echo "❌ Error: Incorrect number of parameters." >&2
    echo "Usage: $0 <fileURL> <directoryIdentifier>" >&2
    echo "Available directory identifiers: hooks, rules, workflows" >&2
    exit 1
fi

FILE_URL="$1"
DIR_IDENTIFIER="$2"

# --- Step 2: Parse Directory Identifier ---

# Use case statement to map identifier to specific directory path
# Use $HOME variable instead of ~ symbol for better cross-platform and script compatibility
case "$DIR_IDENTIFIER" in
    hooks)
        TARGET_DIR="$HOME/Documents/Cline/Hooks"
        ;;
    rules)
        TARGET_DIR="$HOME/Documents/Cline/Rules"
        ;;
    workflows)
        TARGET_DIR="$HOME/Documents/Cline/Workflows"
        ;;
    *)
        echo "❌ Error: Invalid directory identifier '$DIR_IDENTIFIER'." >&2
        echo "Please use one of the following valid identifiers: hooks, rules, workflows" >&2
        exit 1
        ;;
esac

# --- Step 3: Prepare Target Environment ---

# If directory doesn't exist, create it (including all required parent directories)
# -p option ensures no error even if directory already exists
echo "ℹ️  Info: Preparing target directory..."
if ! mkdir -p "$TARGET_DIR"; then
    echo "❌ Error: Failed to create directory '$TARGET_DIR'. Please check permissions." >&2
    exit 1
fi

# Extract filename from URL for saving
# basename command effectively strips the path portion
FILENAME=$(basename "$FILE_URL")
OUTPUT_PATH="$TARGET_DIR/$FILENAME"

# --- Step 4: Perform Download and Validate ---

echo "ℹ️  Info: Downloading file from '$FILE_URL'..."
echo "ℹ️  Info: File will be saved as '$OUTPUT_PATH'"

# Use curl to download file
# -L: Follow HTTP redirects
# -f: (fail) Fail silently on server errors (HTTP 4xx/5xx), no HTML error page output
# -sS: (silent, show-errors) Silent mode, but show error messages
# -o: Write output to specified file instead of standard output
if curl --fail -L -sS -o "$OUTPUT_PATH" "$FILE_URL"; then
    # If curl command executes successfully (exit code 0)
    echo "✅ Success: File downloaded and saved to '$OUTPUT_PATH'"
else
    # If curl command fails
    CURL_EXIT_CODE=$?
    echo "❌ Error: File download failed. Please check URL and network connection." >&2
    
    # Clean up possibly created empty or partial files
    if [ -f "$OUTPUT_PATH" ]; then
        echo "ℹ️  Info: Cleaning up incomplete file '$OUTPUT_PATH'..."
        rm "$OUTPUT_PATH"
    fi
    
    # Exit with curl's exit code for easier error type identification by caller
    exit $CURL_EXIT_CODE
fi

exit 0
