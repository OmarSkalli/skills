# Harness Engineering Skills

Claude Code skills for agent-first development following the harness engineering pattern.

## Overview

The harness engineering pattern treats documentation as first-class artifacts that live in git alongside code. Plans are written before implementation, updated during execution, and archived when complete — creating an organizational memory that both humans and AI agents can navigate.

Core principles:
- **Progressive disclosure**: Small entry points (AGENTS.md) link to deeper docs
- **Living documents**: Plans updated during execution, not reconstructed after
- **Self-contained**: Everything needed to execute is in the doc
- **Observable outcomes**: Focus on verifiable behavior, not internal details

## Workflow

### Standard Feature Development Flow

```
1. Initialize structure (first time only)
   → Use: init-repo-docs skill

2. Define what to build
   → Use: product-spec skill
   → Output: docs/product-specs/{feature}.md

3. Plan how to build it
   → Use: execplan skill
   → Output: docs/exec-plans/active/{feature}.md

4. Implement (update plan during work)
   → Update: Progress, Decisions, Surprises sections
   → Commits reference the plan

5. Verify and open PR
   → Use: pull-request skill
   → Runs: pr-checklist internally
   → Output: Quality gates verified, PR opened as draft

6. Capture learnings
   → Use: execplan-complete skill
   → Output: Plan archived, FEATURES.md updated, tech debt extracted
```

### Quick Iterations

For smaller changes where the "what" is obvious:
```
execplan → implement → pull-request → execplan-complete
```

### Exploratory Work

For research spikes:
```
execplan (lightweight) → investigate → capture findings → product-spec or design-doc
```

## Skills

### init-repo-docs

Initialize harness engineering documentation structure in a repository.

**Use when**: Starting a new project or adding structured docs to an existing one.

**Creates**:
```
{repo}/
├── AGENTS.md              # Entry point for AI agents
├── ARCHITECTURE.md        # System structure map
├── FEATURES.md            # Outcome-based index
├── VISION.md              # Strategic direction
└── docs/
    ├── design-docs/
    ├── product-specs/
    ├── exec-plans/
    │   ├── active/
    │   ├── completed/
    │   └── tech-debt.md
    ├── PR-CHECKLIST.md    # Repo-specific PR gates
    ├── DESIGN.md
    ├── QUALITY_SCORE.md   # Full only
    ├── RELIABILITY.md     # Full only
    └── SECURITY.md        # Full only
```

**Options**: Minimal / Standard / Full (adds QUALITY_SCORE.md, RELIABILITY.md, SECURITY.md)

---

### product-spec

Create a product specification defining what to build.

**Use when**: Defining a new feature — captures the "what" before the "how".

**Creates**: `docs/product-specs/{feature}.md` with user stories, requirements, and success criteria. Updates the spec index.

---

### execplan

Create an execution plan documenting how to implement a feature.

**Use when**: Ready to implement — creates a self-contained guide for an agent or human to execute.

**Creates**: `docs/exec-plans/active/{feature}.md` with all 12 sections:
1. Purpose / Big Picture
2. Progress (timestamped checkboxes)
3. Surprises & Discoveries
4. Decision Log
5. Outcomes & Retrospective
6. Context and Orientation
7. Plan of Work
8. Concrete Steps
9. Validation and Acceptance
10. Idempotence and Recovery
11. Artifacts and Notes
12. Interfaces and Dependencies

---

### execplan-complete

Finalize and archive an execution plan after implementation.

**Use when**: Feature is complete and PR is merged.

**Does**:
1. Captures Outcomes & Retrospective
2. Moves plan from `active/` to `completed/`
3. Updates `FEATURES.md`
4. Extracts technical debt to `tech-debt.md`

---

### pr-checklist

Run quality checks before opening a pull request.

**Use when**: Verifying gates standalone, or called internally by `pull-request`.

**Does**:
1. Runs universal checks (lint, format, type check, tests, coverage)
2. Reads repo-specific checks from `docs/PR-CHECKLIST.md`
3. Verifies relevant docs are updated
4. Reports ✅ / ⚠️ / ❌ / ⏭️ summary

---

### pull-request

Create a pull request after implementation is complete.

**Use when**: Implementation is done and ready for review. Always use this instead of running `gh pr create` directly.

**Does**:
1. Runs `pr-checklist` internally
2. Analyzes commits and execplan for context
3. Writes PR description focused on motivation, not diff summary
4. Creates PR as draft with checklist results embedded

---

### commit

Create git commits for changes made during a session.

**Use when**: Ready to commit — stages files, proposes atomic commit messages, confirms before executing.

---

## Installation

```bash
# From the skills/ directory
claude-code skills install init-repo-docs/
claude-code skills install product-spec/
claude-code skills install execplan/
claude-code skills install execplan-complete/
claude-code skills install pr-checklist/
claude-code skills install pull-request/
claude-code skills install commit/

# Or install all at once
claude-code skills install */
```

## Contributing

MIT licensed — modify, improve, and share freely. Pull requests welcome at [github.com/OmarSkalli/skills](https://github.com/OmarSkalli/skills).
