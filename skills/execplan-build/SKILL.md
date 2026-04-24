---
name: execplan-build
description: Execute one milestone of an execplan — creates a stacked branch, implements the milestone steps, runs simplify and code-review, updates Progress, commits, and opens a PR. Works with any execplan, independent of Linear.
---

# Execplan Build

Execute one milestone of an execplan at a time. Each invocation handles exactly one milestone, opening a focused PR for review before the next milestone begins.

## Inputs

- **Milestone number** N (or `next` to auto-detect from `## Progress`)
- **Feature slug** — used to locate the execplan at `docs/exec-plans/active/<feature-slug>.md`
- **Branch prefix** — the base name for milestone branches (e.g. `os-eng-123-add-dark-mode`)

## Branch Strategy

Milestones use stacked branches so each builds on the previous:

```
main
  └── os-eng-123-add-dark-mode-m1   ← PR targets main
        └── os-eng-123-add-dark-mode-m2   ← PR targets m1
              └── os-eng-123-add-dark-mode-m3   ← PR targets m2
```

This keeps each PR diff small and focused on only that milestone's changes.

---

## Workflow

### Step 1: Locate the execplan and resolve milestone number

Find the execplan at `docs/exec-plans/active/<feature-slug>.md`. Read it in full.

If milestone number is `next`, inspect `## Progress` to find the first incomplete milestone (no `[x]` checkbox).

Extract the milestone's **Goal** and **Work** from `## Plan of Work` and its concrete steps from `## Concrete Steps`.

### Step 2: Determine the branch to create and its parent

Branch naming:
- Format: `<branch-prefix>-m<N>`
- Example: `os-eng-123-add-dark-mode-m2`

Parent branch (what to branch off):
- **M1**: branch off `main`
- **M2+**: branch off the previous milestone's branch (`<branch-prefix>-m<N-1>`)

```bash
# For M1:
git checkout main && git pull --ff-only
git checkout -b os-eng-123-add-dark-mode-m1

# For M2+:
git checkout os-eng-123-add-dark-mode-m1
git checkout -b os-eng-123-add-dark-mode-m2
```

If the branch already exists, ask the user whether to reuse it (resuming work) or pick a different name.

### Step 3: Execute the milestone

Work through only the steps for this milestone from `## Concrete Steps` in the execplan:

1. Implement the changes
2. Run the `simplify` skill to review changed code for quality, reuse, and efficiency; fix any issues before proceeding
3. Run the `code-review` skill to run lint, format, type check, and tests; fix any failures before proceeding
4. Update the `## Progress` section in the execplan with a timestamp:
   ```markdown
   - [x] (2026-03-19 14:30Z) Milestone 2 completed
   ```
5. If `.husky/pre-commit` exists, run it and ensure it passes
6. Log decisions to `## Decision Log` and surprises to `## Surprises & Discoveries` as they occur

Do not implement any other milestone's work. If you discover something that affects the plan, document it in Surprises and surface it to the user — do not silently expand scope.

### Step 4: Finalize execplan (last milestone only)

If this is the last milestone, run the `execplan-complete` skill to archive the plan, update FEATURES.md, and extract tech debt before committing.

### Step 5: Commit

Run the `commit-auto` skill:
- Atomic commits grouped by logical changes within this milestone
- Imperative mood, no AI attribution
- The execplan progress update (and any execplan-complete changes) should be included in the commit

### Step 6: Open the PR

Run the `pull-request` skill with these additions:

- **Base branch**: the parent milestone branch (or `main` for M1)
- **PR title**: `<branch-prefix> M<N>: <Milestone Name>`

Before opening the PR, confirm the current branch:
```bash
git branch --show-current
```

### Step 7: Tell the user what to do next

```
PR opened: <pr-url>

After this PR is reviewed and merged, build the next milestone with:
  /execplan-build <feature-slug> M<N+1> <branch-prefix>
```

If this was the last milestone, say so explicitly.

---

## Error Handling

- **Execplan not found**: Stop — the plan phase must complete first.
- **Milestone not found**: Stop and list available milestones from the execplan.
- **Parent branch not found locally**: Pull from remote or ask the user to confirm the previous milestone's branch name.
- **Branch already exists**: Ask whether to reuse it (resume) or create a new name.
- **Pre-commit hook fails**: Fix the underlying issue before proceeding — never skip hooks.
- **PR creation fails**: Report the `gh` error and suggest the user check `gh auth status`.
- **Scope creep discovered**: Document in Surprises, surface to user, do not implement beyond the current milestone.
