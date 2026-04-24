---
name: commit-auto
description: Create git commits without asking for confirmation. Same as commit but skips the approval step — stages files and commits immediately. Use when you want to commit changes without interactive review.
---

# Commit Changes (Auto)

Create git commits for the changes made during this session without asking for confirmation.

## Workflow

1. **Analyze changes:**
   - Review conversation history for context
   - Run `git status` and `git diff` to understand modifications
   - Decide if changes should be one commit or split logically

2. **Check for sensitive or unintended files:**
   - Flag any files that look like secrets, credentials, or build artifacts (e.g. `.env`, `*.key`, `dist/`)
   - If untracked files should never be committed, suggest adding them to `.gitignore` before proceeding
   - Do not stage these files — stop and flag to the user instead

3. **Execute immediately (no confirmation needed):**
   - `git add` specific files (never `-A` or `.` unless requested)
   - `git commit -m "message"`
   - Show result with `git log --oneline -n [number]`

## Critical Constraints

**NEVER include:**
- Co-author information or Claude attribution
- "Generated with Claude Code" or similar messages
- "Co-Authored-By" lines

**Always:**
- Write commits as if the user wrote them
- Use imperative mood (e.g., "Add feature" not "Added feature")
- Keep commits atomic and focused
- Avoid `--amend` and `push` unless explicitly requested

## Notes

- You have full session context - use it to write meaningful messages
- When uncertain about grouping, prefer multiple focused commits over one large commit
- Skip confirmation entirely — just commit and show the result
