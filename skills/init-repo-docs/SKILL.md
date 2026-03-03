---
name: init-repo-docs
description: Initialize harness engineering documentation structure in a code repository. Use when the user wants to set up project documentation following the harness engineering pattern (agent-first documentation approach), create documentation scaffolding for a new or existing project, or establish a structured docs/ directory with AGENTS.md, ARCHITECTURE.md, specs, execution plans, and feature tracking.
---

# Repo Docs

Initialize complete harness engineering documentation structure for agent-first development.

## Overview

This skill sets up the full documentation scaffold based on the harness engineering pattern. It creates:

- Entry point docs (AGENTS.md, ARCHITECTURE.md, FEATURES.md, VISION.md)
- Structured docs/ directory (design-docs, product-specs, exec-plans)
- Domain-specific standards (DESIGN.md, QUALITY_SCORE.md, RELIABILITY.md, SECURITY.md — some Full only)

All files are templates with placeholder content ready to be customized.

## Workflow

### Step 1: Confirm Structure

Ask the user:
1. **Repository path** - Where to create the documentation (default: current directory)
2. **Project name** - For templating AGENTS.md and other files
3. **Structure level** - Minimal, Standard, or Full

**Minimal** (for early-stage projects):
- AGENTS.md, VISION.md
- docs/product-specs/, docs/exec-plans/

**Standard** (recommended for most projects):
- AGENTS.md, ARCHITECTURE.md, FEATURES.md, VISION.md
- docs/ with all subdirectories
- docs/DESIGN.md

**Full** (for production systems):
- All standard files
- docs/QUALITY_SCORE.md, docs/RELIABILITY.md, docs/SECURITY.md
- docs/references/ for LLM-formatted third-party docs

### Step 2: Copy Template Files

Copy files from `assets/` directory to target repository:

```bash
# Core entry points
cp assets/AGENTS.md {repo}/AGENTS.md
cp assets/ARCHITECTURE.md {repo}/ARCHITECTURE.md  # Standard+ only
cp assets/FEATURES.md {repo}/FEATURES.md          # Standard+ only
cp assets/VISION.md {repo}/VISION.md

# Docs directory structure
cp -r assets/docs {repo}/docs

# Remove optional files based on structure level
# For Minimal: remove RELIABILITY.md, SECURITY.md, references/
# For Standard: remove RELIABILITY.md, SECURITY.md
```

### Step 3: Customize Templates

Replace placeholders in copied files:

- `{Project Name}` → actual project name
- `{date}` → current date (YYYY-MM-DD format)
- `{author}`, `{owner}` → user's name (ask if needed)

Remove placeholder sections marked with `{...}` that user should fill in later.

### Step 4: Initialize Git (if not already initialized)

If the repository is not yet a git repository:

```bash
cd {repo}
git init
git add .
git commit -m "Initialize harness engineering documentation structure"
```

If already a git repository, stage the new docs for commit:

```bash
git add AGENTS.md ARCHITECTURE.md FEATURES.md VISION.md docs/
git status  # Show what was added
```

### Step 5: Provide Next Steps

Tell the user:

1. **Customize VISION.md** - Define strategic direction and principles
2. **Update AGENTS.md** - Replace {Project Name} and description
3. **Fill in ARCHITECTURE.md** - Document system components (if code exists)
4. **Review docs/design-docs/core-beliefs.md** - Define technical principles

Then suggest:
- Create first product spec with the `product-spec` skill
- Create first execution plan with the `execplan` skill

## Template Files Reference

### Entry Point Documents

**AGENTS.md** (~100 lines)
- Table of contents for AI agents
- Links to all major documentation areas
- Quick start guide

**ARCHITECTURE.md**
- System overview
- Component map
- Package layering
- Domain map with quality tracking

**FEATURES.md**
- Outcome-based index
- Links to specs, designs, and execution plans
- Status tracking (Production, In Development, etc.)

**VISION.md**
- Strategic direction
- Goals (short and long-term)
- Core principles
- Non-goals

### Structured Documentation

**docs/design-docs/**
- `index.md` - Catalogue of all design docs
- `core-beliefs.md` - Technical principles template

**docs/product-specs/**
- `index.md` - Catalogue of all product specs

**docs/exec-plans/**
- `active/` - Work in progress
- `completed/` - Historical execution plans
- `tech-debt.md` - Known technical debt tracker

**docs/PR-CHECKLIST.md**
- Repo-specific checks run by the `pr-checklist` skill before opening PRs
- Customize with project toolchain commands and feature-specific gates

**docs/references/**
- For third-party documentation reformatted for LLM consumption
- Example: `react-llms.txt`, `postgres-llms.txt`

### Domain Standards

**docs/DESIGN.md**
- Design system (colors, typography, spacing if applicable)
- Code patterns and naming conventions
- API design standards
- Error handling patterns

**docs/QUALITY_SCORE.md** (Full structure only)
- Scoring criteria (test coverage, documentation, code quality, reliability, performance)
- Domain-by-domain quality tracking
- Historical tracking table

**docs/RELIABILITY.md** (Full structure only)
- SLOs (availability, latency, error rate)
- Error handling and retry strategies
- Monitoring and alerting
- Incident response

**docs/SECURITY.md** (Full structure only)
- Security principles
- Authentication and authorization
- Data protection and encryption
- Input validation and secrets management

## File Organization

```
{repo}/
├── AGENTS.md              # Start here (for AI agents)
├── ARCHITECTURE.md        # System map
├── FEATURES.md            # Outcome index
├── VISION.md              # Strategic direction
└── docs/
    ├── design-docs/
    │   ├── index.md
    │   └── core-beliefs.md
    ├── product-specs/
    │   └── index.md
    ├── exec-plans/
    │   ├── active/
    │   ├── completed/
    │   └── tech-debt.md
    ├── references/        # Optional
    ├── PR-CHECKLIST.md
    ├── DESIGN.md
    ├── QUALITY_SCORE.md   # Full only
    ├── RELIABILITY.md     # Full only
    └── SECURITY.md        # Full only
```

## Progressive Disclosure

This structure supports progressive disclosure:

1. **Start small** - AGENTS.md (~100 lines) is the entry point
2. **Navigate** - Links point to relevant domain docs
3. **Drill down** - Specs, designs, and plans contain details
4. **Load as needed** - Agents only read what's necessary

## Integration with Other Skills

After initializing structure:

- Use **product-spec skill** to create product specifications in `docs/product-specs/`
- Use **execplan skill** to create execution plans in `docs/exec-plans/active/`
- Use **execplan-complete skill** to move plans to `completed/` and update FEATURES.md

## Notes

- All templates use GitHub-compatible Markdown links: `[file](file.md)`
- Templates use placeholder format: `{PlaceholderName}`
- Dates use ISO 8601 format: `YYYY-MM-DD`
- Status indicators use emojis: ✅ 🚧 📋 💡 ⏸️ ❌

The structure is designed to grow with the project. Start minimal and add complexity as needed.
