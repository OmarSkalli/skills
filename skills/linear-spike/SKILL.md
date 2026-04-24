---
name: linear-spike
description: Exploratory spike for a Linear ticket — runs through the full execplan as throwaway code to uncover surprises, documents findings back into the plan, then resets all code changes. Use after linear-plan and before linear-plan approve when the approach is uncertain.
---

# Linear Spike

Run a throwaway implementation to surface surprises before committing to the plan. All code changes are reverted at the end — only the learnings (documented in the execplan) survive.

## When to Use

- The approach in the execplan is uncertain or involves unfamiliar territory
- You want to validate assumptions before creating sub-tasks and starting formal milestone work
- The ticket involves risky migrations, new integrations, or architectural unknowns

Do **not** use this for straightforward tickets where the execplan is already clear.

## Prerequisites

- The **Linear MCP plugin** must be active
- `linear-plan` must have already run — the execplan must exist on the plan branch

---

## Workflow

### Step 1: Read the ticket and execplan

Fetch the ticket via `mcp__linear_server__get_issue`. Read the full execplan at `docs/exec-plans/active/<feature-slug>.md`.

### Step 2: Record the starting commit

```bash
git rev-parse HEAD
```

Save this SHA — it's the reset target at the end.

### Step 3: Execute the full plan as a spike

Work through all milestones from `## Concrete Steps` in exploratory mode:

- Move fast — this is throwaway code, not production quality
- Do not run `simplify` or open PRs
- The goal is to hit real obstacles, not produce clean code

As you go, document every surprise immediately in `## Surprises & Discoveries`:

```markdown
## Surprises & Discoveries

- **Surprise**: <what was unexpected>
  **Evidence**: <error message, output, or observation>
  **Impact on plan**: <does this change a milestone? block something? add work?>
```

Also log any significant decisions in `## Decision Log`.

### Step 4: Assess the findings

After completing the spike (or hitting a blocker worth stopping for), review what was discovered:

- Are any milestones significantly larger or smaller than estimated?
- Are there hidden dependencies between milestones?
- Does the overall approach still hold, or does the plan need restructuring?
- Are there new milestones needed (e.g. a prerequisite that wasn't in the plan)?

### Step 5: Update the execplan

Revise the execplan on the plan branch to incorporate the findings:

- Update `## Plan of Work` milestones if scope changed
- Update `## Concrete Steps` with more accurate steps based on what you learned
- Update `## Interfaces and Dependencies` if new dependencies were discovered
- Update `## Idempotence and Recovery` if risks changed

Do **not** clear `## Surprises & Discoveries` — keep the spike findings as a record.

### Step 6: Reset all code changes

```bash
git reset --hard <starting-sha>
```

This removes all code changes from the spike. Only the updated execplan file remains (since it was on the plan branch before the spike started, it is preserved in the working tree if you staged/committed it — see below).

**Important**: Commit the updated execplan before resetting:

```bash
git add docs/exec-plans/active/<feature-slug>.md
git commit -m "plan: incorporate spike findings for <ticket-slug>"
git reset --hard HEAD
```

The reset after committing the execplan update is a no-op for the plan file, but cleans up any leftover spike code that wasn't staged.

### Step 7: Report to the user

Summarize what the spike found:

```
Spike complete. Findings:
- <key surprise 1>
- <key surprise 2>
- <any plan changes made>

Execplan updated on branch <plan-branch>.

Review the revised plan, then run:
  /linear-plan approve <TICKET-ID>
```

If the spike revealed that the plan needs significant rethinking, say so explicitly and suggest re-reviewing before approving.

---

## Error Handling

- **Execplan not found**: Stop — run `linear-plan` first.
- **Spike hits a hard blocker**: Document the blocker in Surprises, reset code, update the plan, and report to the user. Do not push through blockers silently.
- **Reset fails due to uncommitted changes**: Stash or discard changes manually, then reset. Never leave spike code on the plan branch.
