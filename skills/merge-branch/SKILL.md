---
name: merge-branch
description: Squash merge a feature branch into main (or another target branch). Use when the user wants to merge their current branch's commits into main as a single squash commit. Automatically generates the commit message from the branch's commit history.
---

# Merge Branch

Squash merge the current feature branch into a target branch (default: `main`).

## Workflow

1. **Gather context:**
   - Run `git branch --show-current` to confirm the current branch
   - Run `git log main..HEAD --oneline` to list commits being squashed
   - If already on `main` (or the target branch), abort and inform the user

2. **Confirm target branch:**
   - Default target is `main`
   - Ask: "I'll squash merge `<branch>` into `main`. Confirm, or specify a different target branch."
   - Wait for confirmation before proceeding

3. **Generate squash commit message:**
   - Read all commit messages via `git log main..HEAD --format="%s%n%b"`
   - Synthesize a single commit message that captures the overall intent:
     - **Subject line**: imperative mood, ≤72 chars, describes what the branch accomplishes as a whole
     - **Body** (optional): bullet points summarizing notable sub-changes if the branch is large
   - Present the proposed message to the user: "Here's the proposed commit message: ..."
   - Ask: "Shall I proceed with this message, or would you like to edit it?"

4. **Execute upon confirmation:**
   ```bash
   git checkout <target-branch>
   git merge --squash <feature-branch>
   git commit -m "<generated message>"
   ```
   - Stay on `<target-branch>` after the merge
   - Show result with `git log --oneline -n 3`

## Critical Constraints

**NEVER:**
- Push to remote
- Delete the feature branch
- Use `--no-verify` or skip hooks
- Include Co-author or Claude attribution in the commit message

**Always:**
- Stay on the target branch after merging
- Write the commit message as if the user wrote it (imperative mood, no AI attribution)
- Abort if the current branch is already the target branch

## Notes

- The squash commit lands on `<target-branch>`; the feature branch is left untouched
- If the merge has conflicts, report them clearly and check out back to the feature branch — do not attempt to resolve automatically
