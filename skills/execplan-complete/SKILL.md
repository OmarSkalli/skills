---
name: execplan-complete
description: Complete and archive an execution plan after implementation is finished. Use when the user has finished implementing a feature with an active execution plan, wants to mark an execplan as done, move a plan from active/ to completed/, update FEATURES.md with the shipped feature, or extract learnings from implementation to technical debt tracker.
---

# ExecPlan Complete

Finalize execution plans and capture organizational learnings.

## Overview

When implementation is complete, this skill:

1. Prompts for Outcomes & Retrospective
2. Moves plan from `docs/exec-plans/active/` to `docs/exec-plans/completed/`
3. Updates `FEATURES.md` with shipped feature
4. Extracts technical debt to `docs/exec-plans/tech-debt.md`
5. Updates metadata (completion date, status)

This ensures plans become organizational memory, not abandoned artifacts.

## Workflow

### Step 1: Verify Completion

Before completing, confirm:

```bash
# Read the execution plan
cat docs/exec-plans/active/{execplan-name}.md
```

Check:

- [ ] All Progress items marked complete with timestamps
- [ ] All tests passing
- [ ] Feature deployed/merged
- [ ] No open blockers

If not ready, guide user to finish remaining work first.

### Step 2: Gather Retrospective

Ask the user (or help them articulate):

1. **What was achieved?**
   - Main accomplishments
   - Observable outcomes
   - Metrics if applicable

2. **What gaps remain?**
   - Known limitations
   - Follow-up work needed
   - Technical debt introduced

3. **What did we learn?**
   - Surprises that became insights
   - What would we do differently?
   - Patterns to codify

4. **Follow-up items**
   - Specific tasks that need to happen
   - Where they should be tracked

### Step 3: Update Outcomes Section

Add the Outcomes & Retrospective to the plan:

```markdown
## Outcomes & Retrospective

### Achievements

{Summarize what was built, referencing observable outcomes}

### Gaps & Limitations

{What wasn't included or needs follow-up}

### Lessons Learned

{Key insights from implementation}

**What worked well:**

- {Positive pattern 1}
- {Positive pattern 2}

**What to improve:**

- {Area for improvement 1}
- {Area for improvement 2}

### Follow-Up Items

- {Specific next step 1}
- {Specific next step 2}
```

### Step 4: Extract Technical Debt

If gaps were identified, add them to `docs/exec-plans/tech-debt.md`:

```markdown
## {Priority Level}

**{Issue name}**

- Impact: {What's affected or limited}
- Context: {Why this trade-off was made}
- Proposed fix: {How to address it eventually}
- Related: [[completed/{execplan-name}]] - where this originated
- Date logged: {YYYY-MM-DD}
```

Priority levels: High Priority, Medium Priority, Low Priority / Future

### Step 5: Update Metadata

Update the plan's metadata section:

```markdown
**Metadata**

- **Status**: ✅ Completed
- **Owner**: {name}
- **Created**: {YYYY-MM-DD}
- **Started**: {YYYY-MM-DD}
- **Completed**: {current-date}
```

### Step 6: Move to Completed

Move the file:

```bash
mv docs/exec-plans/active/{execplan-name}.md docs/exec-plans/completed/{execplan-name}.md
```

Verify the move:

```bash
ls docs/exec-plans/completed/ | grep {execplan-name}
```

### Step 7: Update FEATURES.md

Add entry to `FEATURES.md`:

**If feature is user-facing**, add to appropriate category:

```markdown
## {Feature Category}

**{Feature Name}**

- Spec: [[docs/product-specs/{feature}]]
- Design: [[docs/design-docs/{design}]] (if applicable)
- Execution: [[docs/exec-plans/completed/{execplan-name}]]
- Status: ✅ Production (or 🧪 Experimental, 🚧 Beta)
- Shipped: {YYYY-MM-DD}
```

**If feature is internal/infrastructure**, add to appropriate section or skip.

### Step 8: Update Related Specs

If a product spec exists for this feature, update its status:

```markdown
---

**Status**: ✅ Shipped
**Owner**: {name}
**Created**: {YYYY-MM-DD}
**Updated**: {current-date}
```

### Step 9: Provide Summary

Tell the user:

**Completed:**

- ✅ ExecPlan moved to completed/
- ✅ FEATURES.md updated (if applicable)
- ✅ Technical debt logged (if applicable)

**Next steps:**

- Commit these changes to git
- Consider creating a commit message referencing the completed plan
- If there's follow-up work, create new spec or execplan

## Completion Checklist

Use this checklist when completing a plan:

- [ ] All Progress checkboxes marked complete
- [ ] Outcomes & Retrospective filled in
- [ ] Metadata updated with completion date
- [ ] Technical debt extracted (if any)
- [ ] Plan moved to completed/
- [ ] FEATURES.md updated (if user-facing)
- [ ] Related spec status updated (if exists)
- [ ] Git commit created

## Tips

**Don't skip the retrospective:**

- This is where organizational learning happens
- Even small plans benefit from reflection
- Future you will thank past you

**Be honest about gaps:**

- Technical debt isn't failure
- Document trade-offs made
- Makes future work easier to prioritize

**Link everything:**

- Completed plans link to specs
- FEATURES.md links to plans
- Tech debt links back to plans
- Creates navigable history

**Commit immediately:**

- Don't let completed plans linger uncommitted
- Completion is a milestone worth committing
- Use descriptive commit message

## Integration with Other Skills

**Before using this skill:**

- Used `execplan` to create the plan
- Implemented the feature following the plan
- Updated Progress, Decisions, Surprises during work

**After using this skill:**

- If follow-up work needed: use `product-spec` or `execplan` for next steps
- If learnings should influence architecture: update `docs/design-docs/core-beliefs.md`
- If pattern emerged: update `docs/DESIGN.md`

## Example Completion Flow

**User**: "I finished implementing the auth feature"

**Claude**:

1. Reads `docs/exec-plans/active/implement-auth.md`
2. Confirms all milestones complete
3. Asks: "What were the main achievements and learnings?"
4. User provides retrospective
5. Claude updates Outcomes section
6. Identifies gap: "Session management needs optimization"
7. Adds to tech-debt.md
8. Updates metadata
9. Moves to completed/
10. Adds to FEATURES.md under "Authentication & Authorization"
11. Updates related spec status
12. Provides summary and next steps

## Common Patterns

**Feature shipped successfully:**

1. Fill retrospective highlighting wins
2. Move to completed/
3. Update FEATURES.md with ✅ Production status
4. Create git commit celebrating the ship

**Feature partially complete:**

1. Document what shipped vs what's deferred
2. Add deferred items to tech-debt.md
3. Move plan to completed/ (it's done even if feature isn't perfect)
4. Create new execplan for deferred work if needed

**Research spike complete:**

1. Summarize findings in Outcomes
2. Document decision made in retrospective
3. Move to completed/
4. Create design doc or full spec based on findings

**Bug fix complete:**

1. Confirm bug no longer reproduces
2. Document root cause in retrospective
3. Note prevention strategy (linting, tests added)
4. Move to completed/
5. Consider if core-beliefs.md should be updated

## Metadata Updates

When marking complete, always update:

**Status changes:**

- 🚧 Active → ✅ Completed

**Dates to fill in:**

- Completed: {current-date}
- If not set: Started: {when first checkbox was marked}

**Optional fields:**

- Duration: {Started → Completed time span}
- Contributors: {If multiple people worked on it}

## Archival Best Practices

**Completed plans are valuable:**

- Show implementation patterns
- Document decisions made
- Provide templates for similar work
- Create institutional knowledge

**Keep them discoverable:**

- Consistent naming in completed/
- Updated FEATURES.md links to them
- Specs link to execution plans
- Git history preserves them

**Review periodically:**

- Quarterly: read completed plans
- Extract patterns to design docs
- Update core-beliefs based on learnings
- Archive truly obsolete plans separately

---

Completing plans properly transforms individual work into organizational knowledge. Don't skip this step.
