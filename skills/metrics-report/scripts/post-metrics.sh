#!/bin/bash
# Retrieve data from the specified path and report it to the remote API endpoint.
# TODO: The task is currently assumed to be "code review".

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

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Error: At least two parameters are required"
    exit 1
fi

TASK=$1
FILE_PATH=$2
COLLECT_COMMIT_ID=$3

if [ ! -f "$FILE_PATH" ]; then
  echo "Error: the file '$FILE_PATH' does not exist."
  exit 1
fi

echo "Task: '$TASK'"

CHAR_COUNT=$(cat "$FILE_PATH" | wc -c)

if [ "$CHAR_COUNT" -gt 1 ]; then
  echo "The file '$FILE_PATH' exists and is not empty."
else
  echo "The file '$FILE_PATH' exists, but its content is empty."
  exit 1
fi

# Source variables from the temporary file
source $FILE_PATH

if [ "$COLLECT_COMMIT_ID" = "true" ]; then
  COMMIT_ID=$(git rev-parse --short=7 HEAD)
  echo "Commit ID captured: ${COMMIT_ID}"
fi

# Create the JSON payload
REPORT_JSON=$(cat <<END_JSON
{
  "taskName": "$CHANGESET_SUMMARY",
  "repoName": "$REPO_NAME",
  "repoUrl": "$REPO_URL",
  "createdBy": "$CREATED_BY",
  "email": "$EMAIL",
  "filesChanged": "$FILES_CHANGED",
  "linesAdded": "$LINES_ADDED",
  "linesDeleted": "$LINES_DELETED",
  "criticalIssues": "$CRITICAL_ISSUES_COUNT",
  "highPriorityIssues": "$HIGH_PRIORITY_ISSUES_COUNT",
  "codeReviewSummary": "$CODE_REVIEW_SUMMARY",
  "estimationModel": "$ESTIMATION_MODEL",
  "estimatedHours": "$ESTIMATED_HOURS",
  "commitId": "$COMMIT_ID"
}
END_JSON
)

# Send the report to the API endpoint
RESPONSE=$(curl --max-time 3 -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -d "$REPORT_JSON" "$webhook_url" 2>/dev/null)

# Extract HTTP code and body
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# Check if the request was successful
if echo "$BODY" | grep -q '"code":200'; then
  echo "✅ Successfully reported metrics, clear the file $FILE_PATH"
  echo '' > $FILE_PATH
  exit 0
else
  echo "Error: Failed to report metrics. HTTP Status: $HTTP_CODE, Response: $BODY"
  exit 1
fi