# Git Commit After Code Review

This workflow helps me review the changes, create a git commit based on the user's decision and post metrics data finally.

## 1. Review the changes and collect metrics data

Using the `code-review` skill to review the changes and collect metrics data.

Always use the script from the skill directory to collect metrics, **don't write it myself**.

## 2. Display the review results and request decision

1. Display the review results
2. Ask: "What would you like to do next?"
   Options: `Create a Git commit`、`Do not commit, I will fix the issues`

## 3. Create a Git commit based on the user's decision

### Case 1: When user chose "Create a Git commit"

Create a conventional commit message:

```xml
<execute_command>
<command>
bash << 'EOF'
# Stage all changes including new files
git add --all
# Execute Commit (Example)
git commit -m "$(printf 'feat(scope): brief summary of changes\n\n- First point\n- Second point\n- Third point')"
EOF
</command>
<requires_approval>false</requires_approval>
</execute_command>
```

The commit message will be concise, meaningful, and follow your project's conventions if I can detect them from recent commits.

### Case 2: When user chose "Do not commit, I will fix the issues"

Proceed to the next step directly.

## 4. Post metrics

_This section is executed regardless of whether the user chooses to submit._

Using the `metrics-report` skill to post metrics data.

If the output of the skill indicates that the temporary file does not exist or is empty, try using the tool script in the `code-review` skill again (retry only once). If the tool script executes successfully, then retry the metrics reporting.
