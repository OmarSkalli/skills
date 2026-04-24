---
name: linear-plan
description: Plan a Linear ticket — reads the ticket, asks clarifying questions, creates a plan branch, writes an execplan, comments the summary on the ticket, and moves to Ready to Build. Use before linear-build.
---

# Linear Plan

Plan a Linear ticket before any code is written.

## Prerequisites

The **Linear MCP plugin** must be active in the current project (`.mcp.json`):

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

---

## Workflow

### Step 1: Read the ticket

Call `mcp__linear_server__get_issue` with the provided ticket ID.

Extract:
- **Title** — used for branch name and execplan feature name
- **Description** — used for execplan purpose and clarifying questions
- **Labels / Priority** — noted in execplan context
- **Status** — check it makes sense to plan this now

Status handling:
- **Ready / Todo / Backlog** — proceed
- **Plan Review** — the plan already exists; ask if the user wants to revise it or proceed to build
- **Ready to Build / In Progress / Code Review** — check whether planning is still needed vs. picking up where things left off
- **Completed** — stop unless the user explicitly asks to re-plan

If the ticket cannot be fetched, stop and report the error.

### Step 2: Ask clarifying questions

Before writing the execplan, surface ambiguities. Ask **1–4 focused questions** in plain chat. Skip questions whose answers are obvious from the ticket or codebase.

Good questions:
- Is there an existing component or pattern to extend?
- Are there edge cases not covered in the description?
- Any dependencies that must be in place first?
- Acceptance criteria beyond what is stated?

### Step 3: Create the plan branch

```bash
git checkout main && git pull --ff-only
git checkout -b <initials>-<ticket-slug>-plan
```

Branch naming:
- Format: `<initials>-<ticket-slug>-plan`
- Slug: kebab-case ticket title, lowercased, trimmed to ~40 chars
- Example: ticket "ENG-123 Add dark mode toggle" → `os-eng-123-add-dark-mode-toggle-plan`

If the branch already exists, ask the user whether to reuse it or create a new name.

### Step 4: Write the execplan

Run the `execplan` skill, pre-filling from the ticket:
- **Feature name**: ticket title
- **Purpose**: ticket description (summarized if long)
- **Related spec**: include if the ticket links one

The execplan is written to `docs/exec-plans/active/<feature-slug>.md` following the full 12-section template.

Write the execplan with **narrow, focused milestones** — 4–6 is usually right for a single ticket. Each milestone should be independently reviewable and committable.

### Step 5: Commit the plan

Commit the execplan file to the plan branch:

```bash
git add docs/exec-plans/active/<feature-slug>.md
git commit -m "plan: <ticket-title>"
```

### Step 6: Comment on the ticket

Summarize the plan in 3–6 lines and post it as a comment on the Linear ticket:

```text
mcp__linear_server__save_comment({
  issueId: "<ticket-id>",
  body: "Plan written: docs/exec-plans/active/<feature-slug>.md\n\n<3-6 line summary of milestones>"
})
```

### Step 7: Move ticket to Ready to Build

```text
mcp__linear_server__save_issue({ id: "<ticket-id>", stateId: "<ready-to-build-state-id>" })
```

Use `mcp__linear_server__list_issue_statuses` to find the ID for **Ready to Build** if needed.

### Step 8: Tell the user what to do next

```
Plan written to docs/exec-plans/active/<feature-slug>.md on branch <branch-name>.
Ticket moved to Ready to Build.

Optionally run a spike to surface surprises before building:
  /linear-spike <TICKET-ID>

When ready, start building:
  /linear-build <TICKET-ID>
```

---

## Error Handling

- **Ticket not found**: Stop and report. Ask the user to verify the ID and Linear MCP config.
- **Branch already exists**: Ask whether to reuse it or pick a different name.
- **Ready to Build state not found**: Report the available states and ask the user which one to use.
