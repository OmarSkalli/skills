---
name: linear-build
description: Build one milestone of a Linear ticket — reads the parent ticket, marks it In Progress (M1), calls execplan-build for the milestone, then moves the ticket to Code Review (last milestone). Use after linear-plan.
---

# Linear Build

Thin Linear wrapper around `execplan-build`. Handles ticket status updates while delegating all milestone execution to `execplan-build`.

## Prerequisites

- The **Linear MCP plugin** must be active (see `linear-plan` for config)
- `linear-plan` must have already run — the execplan must exist on a plan branch
- Each milestone must be built and reviewed in order (M1 before M2, etc.)

---

## Workflow

### Step 1: Read the parent ticket

Call `mcp__linear_server__get_issue` with the ticket ID provided by the user.

Extract:
- **Ticket slug** — used for branch naming (e.g. `eng-123-add-dark-mode`)
- **Title** — for context
- **Description** — to understand the feature being built

### Step 2: Determine which milestone to build

If the user specified a milestone number (e.g. `M2`), use that.

Otherwise, locate the execplan at `docs/exec-plans/active/<feature-slug>.md` and inspect `## Progress` to find the first incomplete milestone (no `[x]` checkbox). Default to that milestone and confirm with the user.

### Step 3: Mark ticket In Progress (M1 only)

If building milestone 1, move the parent ticket to **In Progress**:

```text
mcp__linear_server__save_issue({ id: "<ticket-id>", stateId: "<in-progress-state-id>" })
```

Use `mcp__linear_server__list_issue_statuses` to look up the state ID if needed. Skip this step for M2+.

### Step 4: Call execplan-build

Derive the branch prefix from the ticket slug and user initials:
- Format: `<initials>-<ticket-slug>`
- Example: `os-eng-123-add-dark-mode`

Run the `execplan-build` skill with:
- Milestone number N
- Feature slug (to locate the execplan)
- Branch prefix

`execplan-build` handles all implementation, simplify, code-review, progress update, commit, and PR steps.

### Step 5: Move ticket to Code Review (last milestone only)

After `execplan-build` completes, check if this was the last milestone (no remaining incomplete milestones in `## Progress`).

If yes, move the parent ticket to **Code Review**:

```text
mcp__linear_server__save_issue({ id: "<ticket-id>", stateId: "<code-review-state-id>" })
```

Leave it **In Progress** for mid-run milestones.

### Step 6: Tell the user what to do next

For a mid-run milestone:
```
PR opened: <pr-url>
Ticket ENG-123 remains In Progress.

After this PR is reviewed and merged, build the next milestone with:
  /linear-build ENG-123 M<N+1>
```

For the last milestone:
```
PR opened: <pr-url>
Ticket ENG-123 moved to Code Review.

This was the last milestone — execplan-complete was run as part of this build.
```

---

## Error Handling

- **Ticket not found**: Stop and report. Verify the ID and Linear MCP config.
- **Execplan not found**: Stop — `linear-plan` must complete first.
- **Linear state update fails**: Note and continue — don't block implementation over a status update.
- All other errors: see `execplan-build` error handling.
