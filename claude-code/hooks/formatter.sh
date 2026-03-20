#!/usr/bin/env bash

input=$(cat)

file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# 检查 file_path 是否有值，并且是 .js, .jsx, .ts, .tsx, .css, .scss, .less, .md 文件
if [ -n "$file_path" ] && [ "$file_path" != "null" ]; then
    if [[ "$file_path" =~ \.(js|jsx|ts|tsx|css|scss|less|md)$ ]]; then
        cd $CLAUDE_PROJECT_DIR
        if command -v prettier &> /dev/null || [ -f "node_modules/.bin/prettier" ]; then
            result=$(npx prettier --write $file_path)
            if [ $? -eq 0 ]; then
              echo "✅ format success"
            else
              echo "❌ format failed" >&2
              exit 1
            fi
        else
            echo "⚠️ prettier not found, skipped" >&2
            exit 1
        fi
    else
        echo "🦉 unsupported file type, skipped"
    fi
fi

exit 0