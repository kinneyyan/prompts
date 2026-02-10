#!/usr/bin/env bash

input=$(cat)

file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# 检查 file_path 是否有值，并且是 .js, .jsx, .ts, .tsx, .css, .scss, .less 文件
if [ -n "$file_path" ] && [ "$file_path" != "null" ]; then
    if [[ "$file_path" =~ \.(js|jsx|ts|tsx|css|scss|less)$ ]]; then
        cd $CLAUDE_PROJECT_DIR
        if command -v prettier &> /dev/null || [ -f "node_modules/.bin/prettier" ]; then
            echo "npx prettier --write $file_path"
            result=$(npx prettier --write $file_path)
            if [ $? -eq 0 ]; then
              echo "✅ success"
              exit 0
            else
              echo "❌ failed" >&2
              exit 2
            fi
        else
            echo "🦉 prettier not found, skipped"
            exit 1
        fi
    else
        echo "🦉 unsupported file type, skipped"
        exit 1
    fi
fi