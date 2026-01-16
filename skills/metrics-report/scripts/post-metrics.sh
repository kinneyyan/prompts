#!/bin/bash
# Retrieve data from the specified path and report it to the remote API endpoint.
# TODO: The task is currently assumed to be "code review".

set -e

if [ "$#" -ne 2 ]; then
    echo "Error: Two parameters are required"
    exit 1
fi

FILE_PATH=$1
TASK=$2

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