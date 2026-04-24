# Skills

Claude Code and Codex skills for software engineering workflows, following the [Agent Skills](https://agentskills.io/) standard.

## Skills

### Issue tracking

| Skill | Description |
|---|---|
| `linear-ticket` | Guide to the staged Linear workflow — directs you to the skills below |
| `linear-plan` | Plan a Linear ticket: write execplan on a plan branch, move to Ready to Build |
| `linear-build` | Build one milestone of a Linear ticket: thin Linear wrapper around execplan-build; updates ticket status, stacked branch, one PR per milestone |
| `linear-spike` | Throwaway exploratory run through the full plan to surface surprises; resets all code, updates the execplan with findings |
| `linear-ticket-yolo` | Implement a Linear ticket end-to-end in one shot: fetch → branch → execplan → build all milestones → commit → PR |

### Design

| Skill | Description |
|---|---|
| `design-review` | Designer's eye QA: audit a live site for visual inconsistency, spacing issues, hierarchy problems, and AI slop patterns — then fix issues in source with atomic commits |

### Git workflow

| Skill | Description |
|---|---|
| `commit` | Stage and commit changes with atomic, well-structured messages |
| `commit-auto` | Same as `commit` but skips confirmation — stages and commits immediately |
| `merge-branch` | Squash merge a feature branch into main with an auto-generated commit message |
| `pull-request` | Run quality checks, write a meaningful PR description, and open a draft PR |
| `code-review` | Run lint, format, type check, tests, and repo-specific gates before a PR |

### Harness engineering workflow

Skills for the harness engineering pattern — an agent-first approach where documentation (specs, execution plans) lives in git alongside code and serves as shared context for both humans and agents.

| Skill | Description |
|---|---|
| `init-repo-docs` | Scaffold the full harness engineering doc structure in a repo |
| `product-spec` | Write a product spec defining what to build before implementation starts |
| `execplan` | Create a self-contained execution plan for how to implement a feature |
| `execplan-build` | Execute one milestone of an execplan — stacked branch, implement, simplify, code-review, commit, open PR |
| `execplan-complete` | Archive a finished plan, update FEATURES.md, extract tech debt |

→ [Harness engineering methodology](docs/harness-engineering-methodology.md)

## Linear workflow

The typical flow for a Linear ticket:

```
/linear-plan ENG-123                 # write execplan → ticket moves to Ready to Build
  /linear-spike ENG-123              # optional: throwaway run to surface surprises
/linear-build ENG-123 [M1]           # branch -m1 off main, build, PR → ticket In Progress
/linear-build ENG-123 [M2]           # branch -m2 off -m1, build, PR
...
/linear-build ENG-123 [Mn]           # last milestone → ticket moves to Code Review
```

For small or well-understood tickets, skip the staged flow:

```
/linear-ticket-yolo ENG-123          # plan + build everything → single PR
```

## Installation

```bash
bin/install.sh
```

The installer scans `skills/`, shows a preview of what will be installed or updated, and copies everything to both `~/.claude/skills/` and `${CODEX_HOME:-~/.codex}/skills/`. Relaunch any running Claude or Codex instances after installing.

## Contributing

MIT licensed — modify, improve, and share freely. Pull requests welcome at [github.com/OmarSkalli/skills](https://github.com/OmarSkalli/skills).
