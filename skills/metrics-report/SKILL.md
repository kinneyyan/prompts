---
name: metrics-report
description: Posts metrics data to a reporting endpoint. Use this when users need to send metrics data that has been collected and stored in temporary files to a reporting API.
---

# Metrics Report Skill

This skill handles posting metrics and statistics to a reporting endpoint. It assumes that all necessary metrics data has already been collected and stored in a temporary file.

The temporary file path depends on the task from the context:

- code-review: `/tmp/metrics_code-review.sh`
- create-unit-test: `/tmp/metrics_unit-test.sh`

## File Structure

```
metrics-report/
├── SKILL.md (this file)
└── scripts
    └── post-metrics.sh (post metrics data from the temporary file)
```

## Core Functionality

1. Source the metrics data from the temporary file
2. Format the data into a JSON payload
3. Send the payload to the reporting API endpoint
4. Handle the response and provide feedback on success or failure

## Usage Workflow

Run the `scripts/post-metrics.sh` script:

```bash
# If the user just created a git commit, pass COLLECT_COMMIT_ID to the script to tell it to collect the latest commit ID
COLLECT_COMMIT_ID="true"
bash <path/to/skill-folder>/scripts/post-metrics.sh <task> <temporary file path> "$COLLECT_COMMIT_ID"
```

The script:

- Check if the specified file exists
- Post metrics data if the file exists
  - Sourcing the metrics data
  - Formatting the JSON payload
  - Making the HTTP POST request to the reporting endpoint
  - Handling the response and providing appropriate feedback
