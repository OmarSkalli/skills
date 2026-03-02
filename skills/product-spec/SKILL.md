---
name: product-spec
description: Create product specifications for new features. Use when the user wants to document product requirements, create a product spec, define what a feature should do (not how to build it), or add a new specification to docs/product-specs/. This is for defining the "what" before creating execution plans for "how".
---

# Spec

Create structured product specifications following the harness engineering pattern.

## Overview

Product specs define **what** to build, not how. They contain:

- User stories and use cases
- Requirements and success criteria
- Design considerations
- Open questions

Specs live in `docs/product-specs/` and get indexed in `docs/product-specs/index.md`.

## Workflow

### Step 1: Gather Information

Ask the user:

1. **Feature name** - Clear, concise name
2. **Brief description** - 1-2 sentences
3. **Target user** - Who is this for?
4. **Problem being solved** - Why build this?

Optional (can gather during writing):

- User stories
- Success metrics
- Constraints

### Step 2: Determine File Location

Check if `docs/product-specs/` exists:

```bash
ls docs/product-specs/
```

If directory doesn't exist:

- Ask if user wants to initialize full harness structure with `init-repo-docs` skill
- Or create just the product-specs directory:
  ```bash
  mkdir -p docs/product-specs
  ```

### Step 3: Create Spec File

Create file at `docs/product-specs/{feature-slug}.md` using template below.

**Filename convention:**

- Lowercase with hyphens: `user-authentication.md`
- Not `UserAuthentication.md` or `user_authentication.md`

### Step 4: Update Index

Add entry to `docs/product-specs/index.md`:

If index doesn't exist, create it with:

```markdown
# Product Specs Index

Catalogue of all product specifications.

## Active Specs

| Title              | Status     | Owner   | Updated      | Summary         |
| ------------------ | ---------- | ------- | ------------ | --------------- |
| [[{feature-slug}]] | 📋 Planned | {owner} | {YYYY-MM-DD} | {brief summary} |
```

If index exists, add row to appropriate table:

- **Active Specs** - For features currently being worked on
- **Shipped Specs** - For completed features
- **Planned Specs** - For approved but not started features

### Step 5: Next Steps

Tell the user:

**To implement this spec:**

- Use `execplan` skill to create execution plan
- Execution plan will reference this spec

**To refine this spec:**

- Fill in user stories section
- Add design considerations
- Document open questions
- Define success metrics

## Spec Template

```markdown
# {Feature Name}

{One paragraph summary of what this feature does and why it matters}

## Problem Statement

### Current State

{What's the situation today?}

### Pain Points

- {Pain point 1}
- {Pain point 2}
- {Pain point 3}

### Desired Outcome

{What should be possible after this is built?}

## Target Users

**Primary**: {Who is the main user?}

- {Use case 1}
- {Use case 2}

**Secondary**: {Who else benefits?}

- {Use case}

## User Stories

### Core Functionality

**As a** {user type}
**I want** {capability}
**So that** {benefit}

**Acceptance Criteria:**

- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

### Additional Stories

{More user stories as needed}

## Requirements

### Must Have (P0)

- {Requirement 1}
- {Requirement 2}

### Should Have (P1)

- {Requirement 1}
- {Requirement 2}

### Nice to Have (P2)

- {Requirement 1}

## Success Metrics

How we'll measure success:

- **{Metric 1}**: {Target value}
- **{Metric 2}**: {Target value}
- **{Metric 3}**: {Target value}

## Design Considerations

### UI/UX

{If applicable: mockups, wireframes, user flow}

### Technical Constraints

- {Constraint 1}
- {Constraint 2}

### Dependencies

- {Dependency 1}
- {Dependency 2}

### Out of Scope

Explicitly NOT included in this spec:

- {Out of scope item 1}
- {Out of scope item 2}

## Open Questions

- [ ] {Question 1}
- [ ] {Question 2}
- [ ] {Question 3}

## Related Documents

- Vision: [[../VISION.md]]
- Design Doc: [[../design-docs/{related-design}]] (if applicable)
- Execution Plan: [[../exec-plans/active/{feature}]] (when created)

---

**Status**: 📋 Planned
**Owner**: {name}
**Created**: {YYYY-MM-DD}
**Updated**: {YYYY-MM-DD}
```

## Minimal Spec Template

For simpler features, use this shorter version:

```markdown
# {Feature Name}

{Brief description}

## Problem

{What problem does this solve?}

## Solution

{What should be built?}

## Requirements

- {Requirement 1}
- {Requirement 2}
- {Requirement 3}

## Success Criteria

- {How we know it works}

---

**Status**: 📋 Planned | **Owner**: {name} | **Created**: {YYYY-MM-DD}
```

## Tips

**Keep it simple:**

- Start with minimal template
- Add sections as needed
- Not every spec needs all sections

**Focus on outcomes:**

- Define the "what" and "why"
- Leave the "how" for execution plans
- Success criteria should be observable

**Iterate:**

- Specs evolve as understanding deepens
- Update as questions get answered
- Link to execution plans when work starts

**Status indicators:**

- 📋 Planned - Approved, not started
- 🚧 In Progress - Active development
- ✅ Shipped - Live in production
- 💡 Idea - Proposal stage
- ⏸️ Paused - On hold
- ❌ Cancelled - Not moving forward

## Integration with Other Skills

**After creating spec:**

- Use `execplan` skill to create execution plan referencing this spec
- Execution plan will link back: `Spec: [[docs/product-specs/{feature}]]`

**Before creating spec:**

- Use `init-repo-docs` skill if documentation structure doesn't exist

## Common Patterns

**Feature addition:**

1. Create spec defining what to add
2. Get approval/feedback
3. Create execution plan for implementation

**Problem investigation:**

1. Create minimal spec documenting problem
2. Add "Open Questions" section
3. Use execution plan for research spike

**User request:**

1. Capture request as spec
2. Add user stories
3. Prioritize (P0/P1/P2)
