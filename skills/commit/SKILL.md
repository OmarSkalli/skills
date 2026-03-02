---
name: commit
description: Create git commits for changes made during the session. Use when the user asks to commit changes, make commits, or save work to git. Ensures proper commit planning, user-authored messages without AI attribution, and atomic commits grouped by logical changes.
---

# Commit Changes

Create git commits for the changes made during this session.

## Workflow

1. **Analyze changes:**
   - Review conversation history for context
   - Run `git status` and `git diff` to understand modifications
   - Decide if changes should be one commit or split logically

2. **Check for sensitive or unintended files:**
   - Flag any files that look like secrets, credentials, or build artifacts (e.g. `.env`, `*.key`, `dist/`)
   - If untracked files should never be committed, suggest adding them to `.gitignore` before proceeding
   - Do not stage these files until resolved

4. **Present plan to user:**
   - List files for each commit
   - Show proposed commit messages (imperative mood, focus on "why")
   - Explain reasoning for grouping/splitting
   - Ask: "I plan to create [N] commit(s) with these changes. Shall I proceed?"

5. **Execute upon confirmation:**
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
