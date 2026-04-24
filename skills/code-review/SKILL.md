---
name: code-review
description: Run pre-PR checks before opening a pull request for review. Use when the user or an agent is ready to open a PR and wants to verify quality gates pass. Runs universal checks (lint, format, tests, type check) and repo-specific checks defined in docs/REVIEW-CHECKLIST.md.
---

# Code Review

Run all quality checks before opening a pull request.

## Overview

This skill combines universal checks with repo-specific checks defined in `docs/REVIEW-CHECKLIST.md`. It runs what can be automated, prompts for what requires judgment, and blocks the PR if critical checks fail.

## Workflow

### Step 1: Read Repo-Specific Checklist

Check if `docs/REVIEW-CHECKLIST.md` exists:

```bash
cat docs/REVIEW-CHECKLIST.md
```

If it doesn't exist, proceed with universal checks only and suggest initializing it with the `init-repo-docs` skill.

### Step 2: Run Universal Checks

Run these regardless of repo configuration. Adapt commands to the project's package manager and toolchain (check `package.json`, `Makefile`, `pyproject.toml`, etc.):

**Format & Lint:**
```bash
# Examples — use whatever the repo defines
npm run lint
npm run format:check
```

**Type Check:**
```bash
npm run typecheck
```

**Tests:**
```bash
npm test
```

**Test Coverage:**
```bash
npm run test:coverage
# Check output meets threshold defined in repo config
```

For each command:
- Run it and capture output
- Report ✅ pass or ❌ fail with relevant output
- On failure: stop and ask the user/agent to fix before continuing

### Step 3: Run Repo-Specific Checks

Read each item from `docs/REVIEW-CHECKLIST.md`:

- If the item includes a command — run it and report result
- If the item requires human judgment — prompt with the question and wait for confirmation
- If the item is N/A for this PR — allow the agent to skip with a reason

### Step 4: Check Related Docs Updated

Verify that documentation affected by this PR has been updated:

- [ ] `AGENTS.md` updated if new entry points, commands, or structure changed
- [ ] `ARCHITECTURE.md` updated if system structure changed
- [ ] `FEATURES.md` updated if a user-facing feature was added (or will be updated via `execplan-complete`)
- [ ] `docs/REVIEW-CHECKLIST.md` updated if new check categories are needed for this feature

### Step 5: Report Summary

Present a final summary:

```
## Code Review Checklist Results

### Universal Checks
✅ Lint — passed
✅ Format — passed
✅ Type check — passed
✅ Tests — 42 passing, 0 failing
⚠️  Coverage — 74% (threshold: 80%) — see note below

### Repo-Specific Checks
✅ Database migrations included
✅ API docs updated
⏭️  Observability — skipped (no new instrumentation needed for this change)

### Docs
✅ AGENTS.md updated
⏭️  ARCHITECTURE.md — no structural changes

### Result: ⚠️ Ready with notes
```

**Blocking failures (❌):** Do not open PR — fix and re-run.
**Warnings (⚠️):** Flag for reviewer attention but don't block.
**Skipped (⏭️):** Documented reason, reviewer can validate.

### Step 6: Return Results

Return the full checklist summary for use by the `pull-request` skill, or present it to the user if run standalone.

## Tips

**Keep checks fast:**
- Long-running checks (e.g. full E2E suite) should be optional or CI-only
- The goal is a quick confidence pass, not replacing CI

**Repo-specific file is the source of truth:**
- Universal checks can be overridden if the repo uses different tooling
- If a universal check doesn't apply, document why in `docs/REVIEW-CHECKLIST.md`

**Failures are information:**
- Don't skip failures — surface them clearly
- A PR with known failures should be an explicit decision, not an oversight
