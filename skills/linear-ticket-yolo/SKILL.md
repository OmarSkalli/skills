---
name: linear-ticket-yolo
description: Implement a Linear ticket end-to-end in one shot — reads the ticket, creates a branch, writes an execplan, executes all milestones, commits, and opens a PR. Fast path for small or well-understood tickets. For larger tickets, prefer linear-plan + linear-build.
---

# Linear Ticket (Yolo)

Implement a Linear ticket end-to-end without stopping for plan review: fetch → branch → plan → build → commit → PR.

**Use this for**: small tickets, well-understood changes, or when you want to move fast and review the full diff at the end.

**Use `linear-plan` + `linear-build` instead when**: the ticket has multiple milestones, the approach is uncertain, or you want per-milestone code review.

Default posture: move quickly, but do not skip ambiguity checks or workflow state updates. The normal path is:

1. Read the ticket
2. Ask targeted questions only if needed
3. Write the execplan
4. Summarize the plan briefly
5. Proceed immediately unless the work is high-risk, ambiguous, or the user explicitly wants plan review first

## Prerequisites

The **Linear MCP plugin** must be active in the current project. It is typically configured in the project's `.mcp.json`:

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

Call `mcp__linear_server__get_issue` with the ticket ID provided by the user (e.g. `ENG-123`).

Extract:

- **Title** — used for the branch name and execplan feature name
- **Description** — used for the execplan purpose and clarifying questions
- **Labels / Priority** — noted in the execplan context
- **Status** — used to decide whether the ticket is ready to be picked up

Recommended status handling:

- **Ready** — proceed normally
- **Todo** — proceed with caution; clarify missing details if needed
- **Backlog** — stop unless the user explicitly asks to work it now
- **In Progress / Ready for Review / Completed** — check whether the user wants to continue from the current state rather than blindly restarting

If the ticket cannot be fetched, stop and report the error.

### Step 2: Create a feature branch

```bash
git checkout main && git pull --ff-only
git checkout -b <initials>-<ticket-slug>
```

Branch naming:

- Prefix: the current user's initials
- Slug: kebab-case ticket title, lowercased and trimmed to ~40 chars
- Format: `<initials>-<ticket-slug>`
- Example: ticket "Add dark mode toggle" → `os-add-dark-mode-toggle`

If the branch already exists locally or remotely, do not guess. Ask the user whether to reuse it or create a different branch name.

### Step 3: Ask clarifying questions

Before writing the execplan, surface ambiguities in the ticket description. Ask the user **1–4 focused questions** in plain chat. Skip questions whose answers are obvious from the ticket or codebase.

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

After writing the execplan:

- Summarize the plan in 3–6 lines
- Add that summary as a comment on the Linear ticket using `mcp__linear_server__save_comment`
- Include the execplan path in the comment when useful

Do **not** block for execplan approval by default. Only stop for plan review first if:

- the work is architectural or cross-cutting
- the ticket is still ambiguous after clarification
- the change includes risky migrations or irreversible infra steps
- the user explicitly wants to review the plan before implementation

### Step 5: Mark ticket In Progress

Before starting implementation, update the Linear ticket status to **In Progress**:

```text
mcp__linear_server__save_issue({ id: "<ticket-id>", state: "In Progress" })
```

If the workspace uses different state names or you need to verify available statuses first, use `mcp__linear_server__list_issue_statuses`. If the state update fails, note it and continue.

### Step 6: Execute the plan

Work through each milestone in the execplan **sequentially**:

1. Implement the milestone
2. If the `simplify` skill is available, run it to review changed code for quality, reuse, and efficiency; otherwise do a focused local review yourself before proceeding
3. Update the `## Progress` section in the execplan with a timestamp:
   ```markdown
   - [x] (2026-03-16 14:30Z) Milestone 1 completed
   ```
4. If `.husky/pre-commit` exists, run it and ensure it passes before moving to the next milestone
5. Log any decisions to `## Decision Log` and surprises to `## Surprises & Discoveries` as they occur
6. For user-facing work, add e2e coverage when the existing harness makes it feasible. If e2e is blocked by missing test infrastructure, document that gap explicitly in the execplan and PR instead of pretending coverage exists.

### Step 7: Commit

Run the `commit` skill after all milestones are complete.

- Prefer automatic commit creation using best judgement on grouping and messages if the active `commit` skill/workflow allows it
- Follow the commit skill constraints (no AI attribution, imperative mood, atomic commits)

### Step 8: Open the PR

Run the `pull-request` skill with one addition: include `Fixes <TICKET-ID>` in the PR body to link the Linear ticket.

Example PR body addition:

```text
Fixes ENG-123
```

This goes at the top of the PR body, before the `## What` section.

Before opening the PR, re-check the current branch name with:

```bash
git branch --show-current
```

Do not assume the branch name still matches the original creation step. If you must invoke `gh pr create` manually, prefer `--body-file - <<'EOF' ... EOF` over inline shell quoting.

### Step 9: Update the Linear ticket

After the PR is created, add the PR URL to the Linear ticket:

```text
mcp__linear_server__save_comment({
  issueId: "<ticket-id>",
  body: "PR: <pr-url>"
})
```

Then move the ticket to **Ready for Review**:

```text
mcp__linear_server__save_issue({ id: "<ticket-id>", state: "Ready for Review" })
```

Do **not** move the ticket to **Completed** from this skill unless the task explicitly includes merge/shipping.

Report the PR URL and ticket URL back to the user.

## Error Handling

- **Ticket not found**: Stop and report. Ask the user to verify the ID and that the Linear MCP is configured.
- **Branch already exists**: Ask the user whether to check it out, reuse it, or create a different name.
- **Pre-commit hook fails**: Fix the underlying issue before proceeding — never skip hooks.
- **PR creation fails**: Report the `gh` error and suggest the user check their GitHub CLI auth (`gh auth status`).
- **Linear state update fails**: Note the failure and continue — don't block implementation over a status update.
- **No authenticated e2e path exists for a user-facing feature**: Call out the gap in the execplan and PR, and leave the harness improvement as follow-up work instead of fabricating coverage.

## Tips

- Read the full ticket description carefully before writing the execplan — tickets often contain constraints buried in comments or sub-bullets.
- If the ticket references a product spec in `docs/product-specs/`, read it before planning.
- Prefer narrow, focused milestones — 4–6 milestones is usually right for a single ticket.
- Keep the execplan in `active/` while the PR is under review; use `execplan-complete` only after the feature is merged or otherwise truly shipped.
