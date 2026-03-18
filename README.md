# Skills

Claude Code and Codex skills for software engineering workflows, following the [Agent Skills](https://agentskills.io/) standard.

## Skills

### Issue tracking

| Skill | Description |
|---|---|
| `linear-ticket` | Implement a Linear ticket end-to-end: fetch → branch → execplan → build → commit → PR |

### Git workflow

| Skill | Description |
|---|---|
| `commit` | Stage and commit changes with atomic, well-structured messages |
| `merge-branch` | Squash merge a feature branch into main with an auto-generated commit message |
| `pull-request` | Run quality checks, write a meaningful PR description, and open a draft PR |
| `pr-checklist` | Run lint, format, type check, tests, and repo-specific gates before a PR |

### Harness engineering workflow

Skills for the harness engineering pattern — an agent-first approach where documentation (specs, execution plans) lives in git alongside code and serves as shared context for both humans and agents.

| Skill | Description |
|---|---|
| `init-repo-docs` | Scaffold the full harness engineering doc structure in a repo |
| `product-spec` | Write a product spec defining what to build before implementation starts |
| `execplan` | Create a self-contained execution plan for how to implement a feature |
| `execplan-complete` | Archive a finished plan, update FEATURES.md, extract tech debt |

→ [Harness engineering methodology](docs/harness-engineering-methodology.md)

## Installation

```bash
bin/install.sh
```

The installer scans `skills/`, shows a preview of what will be installed or updated, and copies everything to both `~/.claude/skills/` and `${CODEX_HOME:-~/.codex}/skills/`. Relaunch any running Claude or Codex instances after installing.

## Contributing

MIT licensed — modify, improve, and share freely. Pull requests welcome at [github.com/OmarSkalli/skills](https://github.com/OmarSkalli/skills).
