---
name: code-review
description: Reviews the changes, identifies critical and high-priority issues, generates review summaries, and collects metrics data for local use. Use this when users need to code review or analyzing code changes for quality issues.
---

# Code Review and Metric Collection

Review the changes and save the metrics data to a local temporary file.

## Script Directory

**Agent Execution Instructions**:

1. Determine this SKILL.md file's directory path as `SKILL_DIR`
2. Script path = `${SKILL_DIR}/scripts/<script-name>.sh`

| Script               | Purpose                                                                  |
| -------------------- | ------------------------------------------------------------------------ |
| `collect-metrics.sh` | Collect git statistics and code review metrics to a local temporary file |
| `show-diff.sh`       | Show git diff with exclusions                                            |

## Workflow

Copy this checklist and check off items as you complete them:

```
- [ ] Step 1: Git Repo verification & Changes confirmation
- [ ] Step 2: Code Review
  - [ ] 2.1 Load guidelines
  - [ ] 2.2 Analyze changes
  - [ ] 2.3 Output Result
- [ ] Step 3: User feedback & Validation
- [ ] Step 4: Collect metrics ⚠️ REQUIRED
```

### Step 1: Git Repo verification & Changes confirmation

Ensure if is in a git repository directory and existing changes to review (staged, unstaged, and untracked files):

```bash
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not a git repository. This command requires git version control."
    exit 1
fi
echo "Success: Git repository verified."

if [ -z "$(git status --porcelain)" ]; then
    echo "No changes detected. Working tree is clean."
    exit 1
else
    echo "Changes detected."
fi
```

### Step 2: Code Review

**2.1 Load guidelines**

Load `references/guidelines.md`, treat it as the canonical set of rules to follow.

**2.2 Analyze changes**

1. Get staged, unstaged, and untracked changes using Bash:
   ```bash
   git status HEAD --short && bash ${SKILL_DIR}/scripts/show-diff.sh`
   ```
2. Analyze code changes to identify issues and store details (FilePath, Line, Suggestion) for subsequent output.
3. Set initial counts: `CRITICAL_ISSUES_COUNT`, `HIGH_PRIORITY_ISSUES_COUNT`.

**2.3 Output Result**

Show categorized issues to the user, exactly follow one of the two templates:

#### Template A (any findings)

```markdown
## Code review Skill Output

### 🚨 CRITICAL (Must fix)

#### <brief description of CRITICAL issue>

- FilePath: <path> line <line>
- Suggested fix: <brief description of suggested fix>

... (repeat for each CRITICAL issue) ...

---

### ⚠️ HIGH PRIORITY (Should fix)

#### <brief description of HIGH PRIORITY issue>

- FilePath: <path> line <line>
- Suggested fix: <brief description of suggested fix>

... (repeat for each HIGH PRIORITY issue) ...

---

### 💡 SUGGESTIONS (Consider)

#### <brief description of SUGGESTIONS issue>

- FilePath: <path> line <line>
- Suggested fix: <brief description of suggested fix>

... (repeat for each SUGGESTIONS issue) ...
```

#### Template B (no issues)

```markdown
## Code review Skill Output

🎉 Great! No issues found.
```

### Step 3: User feedback & Validation

1. If any issues found, ask the user: "Do you have any objections to the review results?" And two options are provided: `1. Yes, I have objections`、`2. No, proceed to the next step`
2. If the user choose "Yes":
   1. Provide a numbered list of all CRITICAL and HIGH PRIORITY issues.
   2. Ask the user: "Please select the numbers of the issues you disagree with and briefly explain why (e.g., '1-this is a test file, 3-intentional technical debt')"
   3. Parse the user's response to identify which specific CRITICAL and HIGH PRIORITY issues were rejected.
   4. Extract the user's reason for each rejected item.
   5. Calculate `REJECTED_CRITICAL_COUNT` and `REJECTED_HIGH_COUNT`.
   6. Format the rejected details into a single-line string `REJECTION_DETAILS` (Format: `[Level]Issue brief=>User reason;[Level]Issue brief=>User reason`).
3. If no issues found or no objections:
   - `REJECTED_CRITICAL_COUNT=0`
   - `REJECTED_HIGH_COUNT=0`
   - `REJECTION_DETAILS=""`

### Step 4: Collect metrics ⚠️ REQUIRED

```bash
CHANGESET_SUMMARY="<Brief summary of changes (single-line only, within 100 words)>"
CODE_REVIEW_SUMMARY="<Detailed review summary (single-line only)>"
bash ${SKILL_DIR}/scripts/collect-metrics.sh \
  "$CHANGESET_SUMMARY" \
  "$CODE_REVIEW_SUMMARY" \
  "$CRITICAL_ISSUES_COUNT" \
  "$HIGH_PRIORITY_ISSUES_COUNT" \
  "$REJECTED_CRITICAL_COUNT" \
  "$REJECTED_HIGH_COUNT" \
  "$REJECTION_DETAILS"
```

## Notes

- Always analyze actual code changes before categorizing issues
- Be specific and actionable in issue descriptions
- Follow the exact output format for consistency
- Respect existing project conventions and patterns
- Never modify git configuration or user credentials
- Maintain full ownership and authenticity of reviews
