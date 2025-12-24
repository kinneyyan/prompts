#!/bin/bash

# ==============================================================================
# Script Name: setup_claude.sh
# Description: Download a file based on directory identifier and save it to Claude's configuration directory.
#              Create directory if it doesn't exist, overwrite file if it exists.
#
# Usage:       ./setup_claude.sh <fileURL> <directoryIdentifier>
#
# Parameters:
#   <fileURL>            - Complete URL of the static file to download.
#   <directoryIdentifier> - Identifier for target directory, allowed values: agents, commands, hooks.
#
# Examples:
#   ./setup_claude.sh https://example.com/my-agent.py agents
#   ./setup_claude.sh https://example.com/my-command.sh commands
#
# Author:      Kinney Yan
# Version:     1.0
# ==============================================================================

# --- Step 1: Parameter Validation ---

# Check if two parameters are provided
if [ "$#" -ne 2 ]; then
    echo "❌ Error: Incorrect number of parameters." >&2
    echo "Usage: $0 <fileURL> <directoryIdentifier>" >&2
    echo "Available directory identifiers: agents, commands, hooks" >&2
    exit 1
fi

FILE_URL="$1"
DIR_IDENTIFIER="$2"

# --- Step 2: Parse Directory Identifier ---

# Note: The mapping has been updated according to new requirements
case "$DIR_IDENTIFIER" in
    agents)
        TARGET_DIR="$HOME/.claude/agents"
        ;;
    commands)
        TARGET_DIR="$HOME/.claude/commands"
        ;;
    hooks)
        TARGET_DIR="$HOME/.claude/hooks"
        ;;
    *)
        echo "❌ Error: Invalid directory identifier '$DIR_IDENTIFIER'." >&2
        echo "Please use one of the following valid identifiers: agents, commands, hooks" >&2
        exit 1
        ;;
esac

# --- Step 3: Prepare Target Environment ---

echo "ℹ️  Info: Preparing target directory..."
if ! mkdir -p "$TARGET_DIR"; then
    echo "❌ Error: Failed to create directory '$TARGET_DIR'. Please check permissions." >&2
    exit 1
fi

FILENAME=$(basename "$FILE_URL")
OUTPUT_PATH="$TARGET_DIR/$FILENAME"

# --- Step 4: Perform Download and Validate ---

echo "ℹ️  Info: Downloading file from '$FILE_URL'..."
echo "ℹ️  Info: File will be saved as '$OUTPUT_PATH'"

if curl --fail -L -sS -o "$OUTPUT_PATH" "$FILE_URL"; then
    echo "✅ Success: File downloaded and saved to '$OUTPUT_PATH'"
else
    CURL_EXIT_CODE=$?
    echo "❌ Error: File download failed. Please check URL and network connection." >&2
    
    if [ -f "$OUTPUT_PATH" ]; then
        echo "ℹ️  Info: Cleaning up incomplete file '$OUTPUT_PATH'..."
        rm "$OUTPUT_PATH"
    fi
    
    exit $CURL_EXIT_CODE
fi

exit 0
