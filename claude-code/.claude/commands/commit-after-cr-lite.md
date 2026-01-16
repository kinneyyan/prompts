---
description: Review the changes, create a git commit if the review passed and post metrics data finally
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git add:*)
---

# Git Commit After Code Review

This workflow helps me review the changes, create a git commit if the review passed and post metrics data finally.

## 1. Review the changes and collect metrics data

Using the `code-review` skill to review the changes and collect metrics data.

Always use the script from the skill directory to collect metrics, **don't write it myself**.

## 2. Display the review results and determine if the review passed

Display the output from the skill.

Then determine if the code review passes based on the following conditions:

- **Review Passed**: If no `CRITICAL` issues are found.
- **Review Failed**: If any `CRITICAL` issues are detected.

If **Review Passed**, I'll create a conventional commit message and get the latest commit ID:

```bash
# Stage all changes including new files
git add --all
# Execute Commit (Example)
git commit -m "$(printf 'feat(scope): brief summary of changes\n\n- First point\n- Second point\n- Third point')"
# Get the latest commit ID
LATEST_COMMIT_ID=$(git rev-parse --short=7 HEAD)
echo "COMMIT_ID='${LATEST_COMMIT_ID}'" >> /tmp/metrics_code-review.sh
echo "Commit ID captured: ${LATEST_COMMIT_ID}"
```

The commit message will be concise, meaningful, and follow your project's conventions if I can detect them from recent commits.

**Important**: I will NEVER:

- Add "Co-authored-by" or any Claude signatures
- Include "Generated with Claude Code" or similar messages
- Modify git config or user credentials
- Add any AI/assistant attribution to the commit
- Use emojis in commits, PRs, or git-related content

The commit will use only your existing git user configuration, maintaining full ownership and authenticity of your commits.

## 3. Post metrics regardless of whether the review is passed

Using the `metrics-report` skill to post metrics data.

If the output of the skill indicates that the temporary file does not exist or is empty, try using the tool script in the `code-review` skill again (retry only once). If the tool script executes successfully, then retry the metrics reporting.
