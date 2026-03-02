---
name: pull-request
description: Create a pull request after implementation is complete. Use when the user or an agent is ready to open a PR for review. Runs pr-checklist, analyzes changes, writes a meaningful PR description focused on motivation and context, and submits via GitHub CLI. Always use this skill when creating PRs — never run gh pr create directly.
---

# Pull Request

Create a well-structured pull request after implementation is complete.

## Workflow

### Step 1: Verify Branch State

```bash
# Confirm not on main/master
git branch --show-current

# Confirm all changes are committed
git status

# Check how far ahead of base branch
git log origin/main..HEAD --oneline
```

If there are uncommitted changes, run the `commit` skill first.
If on main/master, stop and ask the user which branch to use.

### Step 2: Run PR Checklist

Run the `pr-checklist` skill and capture the full results.

- If blocking checks (❌) fail — stop, report failures, do not open PR
- If warnings (⚠️) exist — note them, include in PR description
- If all checks pass or warn — proceed

### Step 3: Analyze Changes

```bash
# Full diff from base branch
git diff origin/main..HEAD

# Commit history
git log origin/main..HEAD --oneline

# Read the active execplan if one exists
cat docs/exec-plans/active/{feature}.md
```

Focus on understanding **why** these changes were made, not just what changed.

### Step 4: Check for PR Template

```bash
cat .github/pull_request_template.md
```

If a template exists, use it as the structure. Otherwise use the template below.

### Step 5: Write PR Description

Write a description that emphasizes **motivation and context**, not a summary of the diff. The reviewer can read the code — explain why it was written this way.

**PR description template:**

```markdown
## What

{1-3 sentence summary of what this PR does, from the user's perspective}

## Why

{The motivation. What problem does this solve? Why now? Why this approach?}
Link to spec: docs/product-specs/{feature}.md (if applicable)
Link to plan: docs/exec-plans/active/{feature}.md (if applicable)

## How

{Only if the approach is non-obvious. Skip if the code is self-explanatory.}

## PR Checklist

{Paste the pr-checklist summary here}

## Notes for Reviewer

{Anything the reviewer should pay particular attention to, known trade-offs, follow-up work planned}
```

**Writing guidelines:**
- Imperative title: "Add user authentication" not "Added user authentication"
- Title prefix if repo uses conventional commits: `feat:`, `fix:`, `ref:`, etc.
- No checkbox test plans — the PR checklist section covers this
- Be honest about trade-offs and known gaps

### Step 6: Create the PR

```bash
gh pr create \
  --title "{title}" \
  --body "$(cat <<'EOF'
{description}
EOF
)" \
  --draft
```

**Always create as draft first** — lets the reviewer know it's ready for eyes without implying it's been fully self-reviewed. The author (or agent) can mark ready when confident.

If the PR relates to an issue:
```bash
# GitHub issues
gh pr create --title "..." --body "Fixes #123\n\n{description}"

# Linear
# Include "Fixes LINEAR-ABC-123" in the body
```

### Step 7: Post-Creation

```bash
# Confirm PR was created
gh pr view --web
```

Report back:
- PR URL
- Any ⚠️ warnings from the checklist to flag for the reviewer
- Suggested next steps (add reviewers, labels, link to project board)

## Tips

**Description over diff:**
- Reviewers read the description first — make it count
- "Why" is almost always more valuable than "what"
- If you can't explain the motivation, the design may need more thought

**Draft PRs:**
- Default to draft — it's easier to mark ready than to un-merge a hasty PR
- Useful signal for async teams and agent workflows

**Keep scope tight:**
- One execplan → one PR
- If the diff is huge, consider splitting before opening

**Use `gh api` for edits after creation:**
```bash
# gh pr edit is unreliable — use the API instead
gh api repos/{owner}/{repo}/pulls/{number} \
  --method PATCH \
  --field title="New title" \
  --field body="New body"
```
