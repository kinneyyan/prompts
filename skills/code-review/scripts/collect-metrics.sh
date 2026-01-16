#!/bin/bash
# Collect git statistics and code review metrics to /tmp/metrics_code-review.sh

set -e

is_absolute_call() {
  SCRIPT_CALL_PATH="$0"
  
  if command -v realpath >/dev/null 2>&1; then
    SCRIPT_ABS_PATH=$(realpath "$SCRIPT_CALL_PATH")
  else
    local script_dir
    script_dir=$(cd "$(dirname "$SCRIPT_CALL_PATH")" && pwd)
    SCRIPT_ABS_PATH="$script_dir/$(basename "$SCRIPT_CALL_PATH")"
  fi
  if [[ "$SCRIPT_CALL_PATH" == "$SCRIPT_ABS_PATH" ]]; then
    IS_ABSOLUTE_CALL="true"
  else
    IS_ABSOLUTE_CALL="false"
  fi
}

is_absolute_call

if [[ "$IS_ABSOLUTE_CALL" == "false" ]]; then
    echo "Please call this script using an absolute path"
    exit 1
fi

if [ "$#" -ne 4 ]; then
    echo "Error: Four parameters are required"
    exit 1
fi

# Part 1: Receive and collect parameters
CHANGESET_SUMMARY=$1
CODE_REVIEW_SUMMARY=$2
CRITICAL_ISSUES_COUNT=$3
HIGH_PRIORITY_ISSUES_COUNT=$4

# Part 2: Get branch and git user info
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
REPO_URL=$(git config --get remote.origin.url)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CREATED_BY=$(git config user.name)
EMAIL=$(git config user.email)

# Part 3: Get file and line change statistics
read -r tracked_files tracked_additions tracked_deletions <<_EOF_
$( (git diff --numstat 2>/dev/null; git diff --cached --numstat 2>/dev/null) | awk '
{ files += 1; additions += $1; deletions += $2 }
END { print files+0, additions+0, deletions+0 }
')
_EOF_

# Handle untracked files
untracked_files_list=$(git ls-files --others --exclude-standard)
untracked_count=0
untracked_lines=0
if [ -n "$untracked_files_list" ]; then
  untracked_count=$(echo "$untracked_files_list" | wc -l)
  untracked_lines=$(echo "$untracked_files_list" | xargs wc -l 2>/dev/null | tail -n 1 | awk '{print $1}' || echo 0)
fi

# Calculate final totals
TOTAL_FILES_CHANGED=$((tracked_files + untracked_count))
TOTAL_LINES_ADDED=$((tracked_additions + untracked_lines))
TOTAL_LINES_DELETED=$((tracked_deletions))

# Part 4: CR variables (should be provided by analysis)
CRITICAL_ISSUES_COUNT=${CRITICAL_ISSUES_COUNT:-0}
HIGH_PRIORITY_ISSUES_COUNT=${HIGH_PRIORITY_ISSUES_COUNT:-0}

# Part 5: Write all variables to the temp file
cat > /tmp/metrics_code-review.sh <<INNER_EOF
REPO_NAME="${REPO_NAME}"
REPO_URL="${REPO_URL}"
CURRENT_BRANCH="${CURRENT_BRANCH}"
CREATED_BY="${CREATED_BY}"
EMAIL="${EMAIL}"
CHANGESET_SUMMARY="${CHANGESET_SUMMARY}"
CODE_REVIEW_SUMMARY="${CODE_REVIEW_SUMMARY}"
FILES_CHANGED=${TOTAL_FILES_CHANGED}
LINES_ADDED=${TOTAL_LINES_ADDED}
LINES_DELETED=${TOTAL_LINES_DELETED}
CRITICAL_ISSUES_COUNT=${CRITICAL_ISSUES_COUNT}
HIGH_PRIORITY_ISSUES_COUNT=${HIGH_PRIORITY_ISSUES_COUNT}
ESTIMATION_MODEL="hours = (filesChanged * 0.1) + ((linesAdded + linesDeleted) * 0.01) + (criticalIssues * 0.5) + (highPriorityIssues * 0.2)"
ESTIMATED_HOURS=$(echo "scale=2; $TOTAL_FILES_CHANGED * 0.1 + ($TOTAL_LINES_ADDED + $TOTAL_LINES_DELETED) * 0.01 + $CRITICAL_ISSUES_COUNT * 0.5 + $HIGH_PRIORITY_ISSUES_COUNT * 0.2" | bc)
INNER_EOF

echo "✅ All variables collected and stored in /tmp/metrics_code-review.sh"