---
name: pull-request
description: Create a pull request after implementation is complete. Use when the user or an agent is ready to open a PR for review. Runs code-review, analyzes changes, writes a meaningful PR description focused on motivation and context, and submits via GitHub CLI. Always use this skill when creating PRs — never run gh pr create directly.
---

# Pull Request

Create a well-structured pull request after implementation is complete.

Default posture: open the PR as **ready for review**, not draft, assign it to the current user, and only use draft status when there is an explicit unfinished blocker or intentional reason to hold review.

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

### Step 2: Run Code Review Checklist

Run the `code-review` skill and capture the full results.

- If blocking checks (❌) fail — stop, report failures, do not open PR
- If warnings (⚠️) exist — note them, include them in the PR description, and still proceed unless the warnings mean the work is intentionally unfinished
- If all checks pass or warn — proceed

Use draft status only when there is a concrete reason, for example:

- a known blocker still needs follow-up before review
- the author explicitly wants early visibility before the implementation is complete
- the checklist warnings represent unfinished work rather than reviewable trade-offs

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

## Review Checklist

{Paste the code-review summary here}

## Notes for Reviewer

{Anything the reviewer should pay particular attention to, known trade-offs, follow-up work planned}
```

**Writing guidelines:**

- Imperative title: "Add user authentication" not "Added user authentication"
- Title prefix if repo uses conventional commits: `feat:`, `fix:`, `ref:`, etc.
- No checkbox test plans — the PR checklist section covers this
- Be honest about trade-offs and known gaps

### Step 6: Create the PR

Prefer a body-file or heredoc-safe approach. Example:

```bash
gh pr create \
  --title "{title}" \
  --body-file - <<'EOF'
{description}
EOF
```

If the PR should intentionally remain draft, add `--draft`. Otherwise create it as ready for review immediately.

If the PR relates to an issue:

```bash
# GitHub issues
# Include "Fixes #123" at the top of the body

# Linear
# Include "Fixes LINEAR-ABC-123" at the top of the body
```

### Step 7: Post-Creation

After the PR is created:

```bash
# Assign the PR to the current user
gh pr edit --add-assignee @me
```

If the PR was created as draft and the work is now actually complete, mark it ready:

```bash
gh pr ready
```

Then confirm the final PR state:

```bash
gh pr view --json url,isDraft
```

Report back:

- PR URL
- Whether it was opened as ready or draft
- Any ⚠️ warnings from the checklist to flag for the reviewer
- Suggested next steps (reviewers, labels, linked ticket state)

## Tips

**Description over diff:**

- Reviewers read the description first — make it count
- "Why" is almost always more valuable than "what"
- If you can't explain the motivation, the design may need more thought

**Ready by default:**

- If the implementation is complete and the checks passed, open the PR ready for review
- Draft is a deliberate signal, not the default

**Keep scope tight:**

- One execplan → one PR
- If the diff is huge, consider splitting before opening

**Use `gh api` for edits after creation when needed:**

```bash
# gh pr edit is sometimes limited — use the API if necessary
gh api repos/{owner}/{repo}/pulls/{number} \
  --method PATCH \
  --field title="New title" \
  --field body="New body"
```
