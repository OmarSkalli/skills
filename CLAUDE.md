# Skills Repo — Claude Guidelines

## Where skills live

All skills are in `skills/<skill-name>/SKILL.md`. This is the source of truth — **do not create or edit skills under `~/.claude/skills/`**.

## Creating a new skill

1. Create a directory under `skills/`:
   ```
   skills/my-skill/
   └── SKILL.md
   ```
2. Write `SKILL.md` with the required YAML frontmatter (`name`, `description`) and instructions in the body.
3. No packaging step is needed — the `.skill` file format is not used here.

## Updating the README

After creating or editing a skill, update the table in `README.md` under the appropriate section to reflect the change. Keep descriptions short and consistent with the skill's `description` frontmatter field.

## Installing skills

After creating or editing a skill, run the installer to sync to `~/.claude/skills/`:

```bash
bin/install.sh
```

Relaunch any running Claude or Codex instances after installing.

## Skill structure

```
skills/<skill-name>/
├── SKILL.md          # Required — frontmatter + instructions
├── scripts/          # Optional — executable scripts
├── references/       # Optional — reference docs loaded into context
└── assets/           # Optional — templates, images, boilerplate
```

The `skill-creator` skill (available in `~/.claude/skills/`) has detailed guidance on writing effective skills if needed.
