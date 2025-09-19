# Git Commit After Code Review [with report]

I'll analyze your changes and perform a code review. If the review passes, I will create a meaningful commit message. Regardless of the review result, I will report the data at the end of the process.

**Pre-Commit Quality Checks:**
Before committing, I'll verify:

- No obvious errors in changed files
- Code review passes (using project architecture & spec references)

First, let me check if this is a git repository and what's changed:

```bash
# Verify we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not a git repository"
    echo "This command requires git version control"
    exit 1
fi

# Check if we have changes to commit
if ! git diff --cached --quiet || ! git diff --quiet; then
    echo "Changes detected:"
    git status --short
else
    echo "No changes to commit"
    exit 0
fi

# Show detailed changes
git diff --cached --stat
git diff --stat
```

Now I'll analyze the changes to determine:

1. What files were modified
2. The nature of changes (feature, fix, refactor, etc.)
3. The scope/component affected

If the analysis or commit encounters errors:

- I'll explain what went wrong
- Suggest how to resolve it
- Ensure no partial commits occur

```bash
# If nothing is staged, I'll stage modified files (not untracked)
if git diff --cached --quiet; then
    echo "No files staged. Staging modified files..."
    git add -u
fi

# Show what will be committed
git diff --cached --name-status
```

Based on the analysis, I'll perform a code review:

1. Understand the architecture from @memory-bank/project-brief.md and @README.md
2. Understand the coding conventions from @memory-bank/code-spec.md
3. Execute code review using 3-tier severity system (`$CRITICAL_ISSUES_COUNT`, `$HIGH_PRIORITY_ISSUES_COUNT` are prepared for the final data report):

   - 🚨 CRITICAL (Must fix) - Found: $CRITICAL_ISSUES_COUNT

     - Configuration changes risking outages
     - Security vulnerabilities
     - Data loss risks
     - Breaking changes

   - ⚠️ HIGH PRIORITY (Should fix) - Found: $HIGH_PRIORITY_ISSUES_COUNT

     - Performance degradation risks
     - Maintainability issues
     - Missing error handling

   - 💡 SUGGESTIONS (Consider)

     - Code style improvements
     - Optimization opportunities
     - Additional test coverage

Then determine if the code review passes based on the following conditions:

- **Review Passed**: If no `CRITICAL` issues are found.
- **Review Failed**: If any `CRITICAL` issues are detected.

If **Review Passed**, I'll create a conventional commit message:

- **Type**: feat|fix|docs|style|refactor|test|chore
- **Scope**: component or area affected (optional)
- **Subject**: clear description in present tense
- **Body**: why the change was made (if needed)

```bash
# I'll create the commit with the analyzed message
# Example: git commit -m "fix(auth): resolve login timeout issue"
```

The commit message will be concise, meaningful, and follow your project's conventions if I can detect them from recent commits.

**Important**: I will NEVER:

- Add "Co-authored-by" or any Claude signatures
- Include "Generated with Claude Code" or similar messages
- Modify git config or user credentials
- Add any AI/assistant attribution to the commit
- Use emojis in commits, PRs, or git-related content

The commit will use only your existing git user configuration, maintaining full ownership and authenticity of your commits.

Finally, **regardless of whether the code review passes**, I will start collecting and reporting data:

If not committed, I will collect statistics on all current changes (staged, unstaged, and untracked) to prepare the report:

```bash
# Get the number of changed files and lines (include untracked files)
bash << 'EOF'
quick_git_stats() {
    # 综合统计所有变更
    {
        # 已追踪文件的变更
        git diff --numstat 2>/dev/null
        # 已暂存文件的变更
        git diff --cached --numstat 2>/dev/null
    } | awk '
    {
        if (NF >= 2) {
            additions += $1
            deletions += $2
            files++
        }
    }
    END {
        print "FILES_CHANGED=" files+0
        print "LINES_ADDED=" additions+0
        print "LINES_DELETED=" deletions+0
    }' > /tmp/git_stats.sh

    # 执行临时文件中的变量赋值
    source /tmp/git_stats.sh
    rm -f /tmp/git_stats.sh

    # 单独处理未追踪文件
    untracked_count=$(git ls-files --others --exclude-standard | wc -l)
    untracked_lines=$(git ls-files --others --exclude-standard | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}' || echo 0)

    # 更新最终统计
    FILES_CHANGED=$((FILES_CHANGED + untracked_count))
    LINES_ADDED=$((LINES_ADDED + untracked_lines))
}
quick_git_stats
EOF
```

Else If submitted, I will gather statistics from the last commit for the report:

```bash
# Get the number of files and lines changed in the last commit
bash << 'EOF'
LAST_COMMIT_STATS=$(git diff-tree --shortstat HEAD~1 HEAD 2>/dev/null)
FILES_CHANGED=$(echo "$LAST_COMMIT_STATS" | grep -o '[0-9]* files\?' | grep -o '[0-9]*')
LINES_ADDED=$(echo "$LAST_COMMIT_STATS" | grep -o '[0-9]* insertions\?' | grep -o '[0-9]*')
LINES_DELETED=$(echo "$LAST_COMMIT_STATS" | grep -o '[0-9]* deletions\?' | grep -o '[0-9]*')
FILES_CHANGED=${FILES_CHANGED:-0}
LINES_ADDED=${LINES_ADDED:-0}
LINES_DELETED=${LINES_DELETED:-0}
EOF
```

Then, I will collect all the information and post the code review report:

```bash
# Format and post report with real variables.
bash << 'EOF'
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
REPO_URL=$(git config --get remote.origin.url)
CREATED_BY=$(git config user.name)
ESTIMATION_MODEL="hours = (filesChanged * 0.1) + ((linesAdded + linesDeleted) * 0.01) + (criticalIssues * 0.5) + (highPriorityIssues * 0.2)"
ESTIMATED_HOURS=$(echo "$FILES_CHANGED * 0.1 + ($LINES_ADDED + $LINES_DELETED) * 0.01 + $CRITICAL_ISSUES_COUNT * 0.5 + $HIGH_PRIORITY_ISSUES_COUNT * 0.2" | bc)

REPORT_JSON='{
  "taskName": "AI-Generated Task Name based on diff",
  "repoName": "'"$REPO_NAME"'",
  "repoUrl": "'"$REPO_URL"'",
  "createdBy": "'"$CREATED_BY"'",
  "filesChanged": "'"$FILES_CHANGED"'",
  "linesAdded": "'"$LINES_ADDED"'",
  "linesDeleted": "'"$LINES_DELETED"'",
  "criticalIssues": "'"$CRITICAL_ISSUES_COUNT"'",
  "highPriorityIssues": "'"$HIGH_PRIORITY_ISSUES_COUNT"'",
  "estimatedHours": "'"$ESTIMATED_HOURS"'",
  "estimationModel": "'"$ESTIMATION_MODEL"'"
}'

RESPONSE=$(curl --max-time 3 -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -d "$REPORT_JSON" https://api-gateway-dev.ab-inbev.cn/budtech-fe-tool-server/api/v1/report/codereview)

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if echo "$BODY" | grep -q '"code":200'; then
  echo "Successfully reported code review metrics."
else
  echo "Error: Failed to report metrics. HTTP Status: $HTTP_CODE, Response: $BODY"
fi
EOF
```
