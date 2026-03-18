---
name: linear-ticket
description: Implement a Linear ticket end-to-end — reads the ticket via the Linear MCP, creates a branch, writes an execplan, asks clarifying questions, executes milestone by milestone, commits, and opens a PR. Use when the user provides a Linear ticket ID (e.g. ENG-123) and wants to ship it.
---

# Linear Ticket

Implement a Linear ticket end-to-end: fetch → branch → plan → build → commit → PR.

## Prerequisites

The **Linear MCP plugin** must be active in the current project. It is typically configured in the project's `.claude/settings.local.json`:

```json
{
  "mcpServers": {
    "linear-server": {
      "type": "http",
      "url": "https://mcp.linear.app/mcp"
    }
  }
}
```

If the plugin is not available, stop and tell the user to configure it before proceeding.

## Workflow

### Step 1: Read the ticket

Call `mcp__linear-server__get_issue` with the ticket ID provided by the user (e.g. `ENG-123`).

Extract:
- **Title** — used for the branch name and execplan feature name
- **Description** — used for the execplan purpose and clarifying questions
- **Labels / Priority** — noted in the execplan context

If the ticket cannot be fetched, stop and report the error.

### Step 2: Create a feature branch

```bash
git checkout main && git pull
git checkout -b os-<ticket-slug>
```

Branch naming:
- Prefix: `os` (initials for Omar Skalli, per execplan convention)
- Slug: kebab-case ticket title, lowercased and trimmed to ~40 chars
- Example: ticket "Add dark mode toggle" → `os-add-dark-mode-toggle`

### Step 3: Ask clarifying questions

Before writing the execplan, surface ambiguities in the ticket description. Ask the user **1–4 focused questions** using AskUserQuestion. Skip questions whose answers are obvious from the ticket or codebase.

Good questions to ask:
- Is there an existing component or pattern to extend?
- Are there edge cases not covered in the description?
- Any dependencies that must be in place first?
- Acceptance criteria beyond what is stated?

### Step 4: Run the `execplan` skill

Invoke the `execplan` skill, pre-filling from the ticket:
- **Feature name**: ticket title
- **Purpose**: ticket description (summarized if long)
- **Related spec**: omit unless the ticket links one

The execplan is written to `docs/exec-plans/active/<feature-slug>.md` following the full 12-section template.

### Step 5: Mark ticket In Progress

Before starting implementation, update the Linear ticket status to **In Progress**:

```
mcp__linear-server__update_issue({ id: "<ticket-id>", stateId: "<in-progress-state-id>" })
```

If the state ID is unknown, use `mcp__linear-server__get_issue` to inspect available states, or skip this step and note it.

### Step 6: Execute the plan

Work through each milestone in the execplan **sequentially**:

1. Implement the milestone
2. Run the `simplify` skill to review changed code for quality, reuse, and efficiency — fix issues before proceeding
3. Update the `## Progress` section in the execplan with a timestamp:
   ```markdown
   - [x] (2026-03-16 14:30Z) Milestone 1 completed
   ```
4. If `.husky/pre-commit` exists, run it and ensure it passes before moving to the next milestone
5. Log any decisions to `## Decision Log` and surprises to `## Surprises & Discoveries` as they occur

### Step 7: Commit

Run the `commit` skill after all milestones are complete.

- Commit automatically using best judgement on grouping and messages — do not ask for confirmation
- Follow the commit skill constraints (no AI attribution, imperative mood, atomic commits)

### Step 8: Open the PR

Run the `pull-request` skill with one addition: include `Fixes <TICKET-ID>` in the PR body to link the Linear ticket.

Example PR body addition:
```
Fixes ENG-123
```

This goes at the top of the PR body, before the `## What` section.

### Step 9: Update the Linear ticket

After the PR is created, add the PR URL to the Linear ticket. Use whichever tool is available:

```
mcp__linear-server__create_comment({
  issueId: "<ticket-id>",
  body: "PR: <pr-url>"
})
```

Or update the ticket's URL field if supported. Report the PR URL and ticket URL back to the user.

## Error Handling

- **Ticket not found**: Stop and report. Ask the user to verify the ID and that the Linear MCP is configured.
- **Branch already exists**: Ask the user whether to check it out, reset it, or use a different name.
- **Pre-commit hook fails**: Fix the underlying issue before proceeding — never skip hooks.
- **PR creation fails**: Report the `gh` error and suggest the user check their GitHub CLI auth (`gh auth status`).
- **Linear state update fails**: Note the failure and continue — don't block implementation over a status update.

## Tips

- Read the full ticket description carefully before writing the execplan — tickets often contain constraints buried in comments or sub-bullets.
- If the ticket references a product spec in `docs/product-specs/`, read it before planning.
- Prefer narrow, focused milestones — 4–6 milestones is usually right for a single ticket.
- After the PR is open, remind the user to mark it ready for review when they're satisfied.
