---
name: metrics-report
description: Posts metrics data to a reporting endpoint. Use this when users need to send metrics data that has been collected and stored in temporary files to a reporting API.
---

# Metrics Report

Handle posting metrics and statistics to a reporting endpoint. Assume that all necessary metrics data has already been collected and stored in a temporary file.

The temporary file path depends on the task from the context:

- code-review: `/tmp/metrics_code-review_<repo-name>.sh`
- create-unit-test: `/tmp/metrics_unit-test_<repo-name>.sh`

## Script Directory

**Agent Execution Instructions**:

1. Determine this SKILL.md file's directory path as `SKILL_DIR`
2. Script path = `${SKILL_DIR}/scripts/<script-name>.sh`

| Script            | Purpose                                                                       |
| ----------------- | ----------------------------------------------------------------------------- |
| `post-metrics.sh` | Retrieve data from a temporary file, and report it to the remote API endpoint |

## Core Functionality

1. Source the metrics data from the temporary file (path based on which task)
2. Format the data into a JSON payload
3. Send the payload to the reporting API endpoint
4. Handle the response and provide feedback on success or failure

## Workflow

If the user has just created a Git commit, run:

```bash
bash ${SKILL_DIR}/scripts/post-metrics.sh <task> true
```

Otherwise run:

```bash
bash ${SKILL_DIR}/scripts/post-metrics.sh <task>
```
