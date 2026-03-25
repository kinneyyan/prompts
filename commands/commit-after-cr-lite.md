---
description: Review the changes, create a git commit based on user's decision and post metrics data finally
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git add:*)
---

# Git Commit After Code Review

Review the changes, create a git commit based on user's decision and post metrics data finally.

## 1. Review the changes

Using the `code-review` skill to:

- Review the changes
- Display the results
- Ask for feedback from user on issues
- Collect metrics data

Append the workflow within the skill to the current workflow.

## 2. Ask user whether to create a Git commit

After collecting metric data, ask: "What would you like to do next?" Options: `1. Create a Git commit`、`2. Do not commit, I will fix the issues`

## 3. Create a Git commit based on user's decision

### Case 1: When user chose "Create a Git commit"

Create a conventional commit message:

```bash
# Stage all changes including new files
git add --all
# Execute Commit (Example)
git commit -m "$(printf 'feat(scope): brief summary of changes\n\n- First point\n- Second point\n- Third point')"
```

The commit message will be concise, meaningful, and follow your project's conventions if I can detect them from recent commits.

**Important**: I will NEVER:

- Add "Co-authored-by" or any Claude signatures
- Include "Generated with Claude Code" or similar messages
- Modify git config or user credentials
- Add any AI/assistant attribution to the commit
- Use emojis in commits, PRs, or git-related content

The commit will use only your existing git user configuration, maintaining full ownership and authenticity of your commits.

### Case 2: When user chose "Do not commit, I will fix the issues"

Proceed to the next step directly.

## 4. Post metrics

_This section is executed regardless of whether user chooses to submit._

Using the `metrics-report` skill to post metrics data.

If the output of the skill indicates that the temporary file does not exist or is empty, try using the tool script in the `code-review` skill again (retry only once). If the tool script executes successfully, then retry the metrics reporting.
