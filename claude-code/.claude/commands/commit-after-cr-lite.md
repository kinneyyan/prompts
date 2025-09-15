# Git Commit After Code Review

I'll analyze your changes and perform a code review. If the review passes, I will create a meaningful commit message.

**Pre-Commit Quality Checks:**
Before committing, I'll verify:

- Linter passes (if lint command exists)
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
3. Execute code review using 3-tier severity system:

#### 🚨 CRITICAL (Must fix)

- Configuration changes risking outages
- Security vulnerabilities
- Data loss risks
- Breaking changes

#### ⚠️ HIGH PRIORITY (Should fix)

- Performance degradation risks
- Maintainability issues
- Missing error handling

#### 💡 SUGGESTIONS (Consider)

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
