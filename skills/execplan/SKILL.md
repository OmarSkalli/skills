---
name: execplan
description: Create execution plans (ExecPlans) for implementing features. Use when the user wants to create an implementation plan, document how to build a feature (not just what to build), create a self-contained guide for complex work, or add an execution plan to docs/exec-plans/active/. ExecPlans are living documents with all 12 required sections including Progress tracking, Decision logs, and Surprises.
---

# ExecPlan

Create self-contained execution plans following the harness engineering pattern.

## Overviewe

Execution plans (ExecPlans) are **living documents** that guide implementation of complex features. They're self-contained guides that enable both agents and humans to execute multi-hour tasks without external context.

### Key Characteristics

- **Self-contained**: Everything needed to execute is in the document
- **Living**: Updated during execution with progress, decisions, surprises
- **Observable**: Focus on verifiable outcomes, not internal details
- **First-class**: Versioned in git, moved to completed/ when done

### Required Sections (All 12)

1. Purpose / Big Picture
2. Progress (timestamped checkboxes)
3. Surprises & Discoveries
4. Decision Log
5. Outcomes & Retrospective (filled at completion)
6. Context and Orientation
7. Plan of Work
8. Concrete Steps
9. Validation and Acceptance
10. Idempotence and Recovery
11. Artifacts and Notes
12. Interfaces and Dependencies

## Workflow

### Step 1: Gather Information

Ask the user:

1. **Feature name** - What's being implemented
2. **Purpose** - User-visible behavior this enables
3. **Related spec** - Link to product spec (if exists)
4. **Approach** - High-level implementation strategy

Optional:
- Specific milestones
- Known constraints
- Dependencies

### Step 2: Analyze Current Repository

Before creating the plan, gather context:

```bash
# Check directory structure
tree -L 2 -I 'node_modules|.git'

# Check for relevant existing code
rg "{relevant-pattern}" --files-with-matches

# Check dependencies
cat package.json  # or requirements.txt, go.mod, etc.
```

This context fills the "Context and Orientation" section.

### Step 3: Create ExecPlan File

Create file at `docs/exec-plans/active/{feature-slug}.md`.

**Filename convention:**
- Lowercase with hyphens
- Descriptive: `implement-user-auth.md`, not `task-123.md`

### Step 4: Fill Template

Use the comprehensive template below. Fill all 12 sections:

- **Auto-generate**: Context and Orientation (from Step 2)
- **User provides**: Purpose, high-level approach
- **Plan together**: Milestones, concrete steps
- **Leave empty**: Progress (checked off during execution), Surprises, Decisions, Outcomes

### Step 5: Provide Guidance

Tell the user:

**During execution:**
- Update Progress section with timestamps after each milestone
- Log decisions as they're made
- Document surprises immediately
- Append artifacts (diffs, error messages) to Artifacts section

**After completion:**
- Fill Outcomes & Retrospective
- Use `execplan-complete` skill to move to completed/

## ExecPlan Template

````markdown
# ExecPlan: {Feature Name}

## Purpose / Big Picture

{User-visible behavior this enables, in plain language. Focus on what end users will be able to do, not technical details.}

Related spec: [[../product-specs/{feature}]]  (if applicable)

## Progress

- [ ] {Milestone 1: Setup and scaffolding}
- [ ] {Milestone 2: Core implementation}
- [ ] {Milestone 3: Testing and validation}
- [ ] {Milestone 4: Documentation and cleanup}

{During execution, mark with timestamps:}
{- [x] (2026-02-23 14:30Z) Milestone 1 completed}

## Surprises & Discoveries

{Empty initially. During execution, document:}
{- Unexpected behaviors}
{- Bugs discovered}
{- Insights that change understanding}
{- Evidence (error messages, screenshots)}

## Decision Log

{Empty initially. During execution, record:}

{- **Decision**: Use PostgreSQL instead of MongoDB}
{  **Rationale**: Team has more PostgreSQL expertise, existing infra}
{  **Date/Author**: 2026-02-23 / Omar}

## Outcomes & Retrospective

{Filled at completion. Document:}
{- What was achieved}
{- What gaps remain}
{- Lessons learned}
{- Follow-up items}

---

## Context and Orientation

### Repository State

{Auto-generate this section from current repo inspection}

Current directory structure:
```
{Paste relevant parts of tree output}
```

Key files for this work:
- `{file-path}` - {brief explanation}
- `{file-path}` - {brief explanation}

### Technology Stack

{List relevant technologies}
- Framework: {e.g., Next.js 14}
- Database: {e.g., PostgreSQL with Prisma}
- Authentication: {e.g., NextAuth.js}

### Dependencies

{List libraries this work depends on}
- `{package-name}` (v{version}) - {what it does, why it matters}

### Current State

{Describe starting point for someone with no context}
- What exists today
- What's missing
- Why this work is needed

## Plan of Work

{Narrative description of the implementation approach}

### Milestone 1: {Name}

**Goal**: {What this achieves}

**Work**: {Prose description of changes - files to create/modify, logic to add}

**Result**: {Expected state after completion}

**Proof**: {How to verify it worked - commands to run, expected output}

### Milestone 2: {Name}

**Goal**: {What this achieves}

**Work**: {Prose description}

**Result**: {Expected state}

**Proof**: {Verification}

{Add more milestones as needed}

## Concrete Steps

{Exact commands with working directories and expected output}

### Milestone 1: {Name}

1. Create directory structure:
   ```bash
   mkdir -p src/auth/{providers,middleware}
   ```

2. Install dependencies:
   ```bash
   npm install next-auth @auth/prisma-adapter
   ```
   Expected: `added 15 packages` in output

3. Create `src/auth/config.ts`:
   ```typescript
   // Exact code to write
   import NextAuth from "next-auth"
   // ...
   ```

4. Verify setup:
   ```bash
   npm run typecheck
   ```
   Expected: `No errors found`

{Continue with detailed steps for each milestone}

## Validation and Acceptance

{Observable behavior verification - focus on demonstrable outcomes}

### End-to-End Scenario

```bash
# Start the application
npm run dev

# Test the authentication flow
curl http://localhost:3000/api/auth/signin
# Expected: HTTP 200 with sign-in page HTML

# Authenticate
{Steps to test full flow}
# Expected: {Observable outcome}
```

### Test Suite

```bash
npm test -- auth.test.ts
# Expected: All tests pass (X passing)
```

### Acceptance Criteria

- [ ] User can sign in with email/password
- [ ] Protected routes redirect to login
- [ ] Session persists across page refreshes
- [ ] Sign out clears session

{Each criterion should be verifiable by running commands above}

### PR Checklist Notes

Before opening a PR, run the `pr-checklist` skill. Note any feature-specific checks this work requires (beyond the standard `docs/PR-CHECKLIST.md`):

Before opening a PR, run the `pr-checklist` skill. Review `docs/PR-CHECKLIST.md` during planning and note any feature-specific checks this work requires:

{e.g. "This feature adds a new env var — ensure .env.example is updated"}

## Idempotence and Recovery

### Safe to Re-run

This plan can be executed multiple times safely because:
- Database migrations use idempotent `IF NOT EXISTS`
- File creation checks for existing files
- Package installs are idempotent

### Rollback Procedure

If something goes wrong:

1. Reset database:
   ```bash
   npm run db:reset
   ```

2. Remove created files:
   ```bash
   git checkout HEAD -- src/auth/
   ```

3. Uninstall added packages:
   ```bash
   npm uninstall next-auth @auth/prisma-adapter
   ```

4. Return to clean state:
   ```bash
   git reset --hard {starting-commit}
   ```

### Known Risks

- {Risk 1}: {Mitigation}
- {Risk 2}: {Mitigation}

## Artifacts and Notes

{Filled during execution with:}
{- Code diffs}
{- Error messages and resolutions}
{- Performance measurements}
{- Screenshots}

{Example:}
{```diff}
{+ Added JWT token generation}
{+ export function generateToken(userId: string) {}
{```}

## Interfaces and Dependencies

### New Interfaces

```typescript
// Exact signatures for new APIs

interface User {
  id: string
  email: string
  name: string | null
}

function authenticateUser(
  email: string,
  password: string
): Promise<User | null>
```

### Modified Interfaces

**Before**:
```typescript
export function getUser() {
  // No authentication
}
```

**After**:
```typescript
export function getUser(session: Session) {
  // Requires authentication
}
```

### Database Schema Changes

```sql
-- New tables
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL
);

CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users(id),
  expires_at TIMESTAMP NOT NULL
);
```

### External Dependencies

- **next-auth**: Authentication library
  - Why: Industry-standard, well-maintained
  - Version: ^5.0.0
  - Docs: https://authjs.dev

---

**Metadata**
- **Status**: 🚧 Active
- **Owner**: {name}
- **Created**: {YYYY-MM-DD}
- **Started**: {YYYY-MM-DD when execution begins}
- **Completed**: {YYYY-MM-DD when moved to completed/}
````

## During Execution

### Updating Progress

After completing each milestone:

```markdown
## Progress

- [x] (2026-02-23 14:30Z) Setup and scaffolding
- [x] (2026-02-23 16:45Z) Core implementation
- [ ] Testing and validation
- [ ] Documentation and cleanup
```

Timestamps measure velocity and help understand effort.

### Logging Decisions

When making a mid-implementation choice:

```markdown
## Decision Log

- **Decision**: Use bcrypt for password hashing instead of argon2
  **Rationale**: bcrypt has better Node.js support, team familiarity
  **Implications**: Slightly slower than argon2, but acceptable for our scale
  **Date/Author**: 2026-02-23 / Omar
```

### Documenting Surprises

When encountering unexpected behavior:

```markdown
## Surprises & Discoveries

- **Surprise**: NextAuth.js session cookies not persisting in development
  **Evidence**: Cookie inspector shows `SameSite=Lax` being rejected
  **Resolution**: Set `NEXTAUTH_URL=http://localhost:3000` in .env
  **Impact**: Delayed milestone 2 by 1 hour
```

## Tips

**Self-containment is non-negotiable:**
- Define every technical term
- Include full file paths
- Show expected output transcripts
- No external links to blogs or docs

**Focus on observable outcomes:**
- "After running X, Y happens" not "Implement Y"
- Commands to run and their output
- HTTP responses, CLI results, visual changes

**Write for novices:**
- Someone unfamiliar with the repo should be able to execute
- Explain architectural choices
- Define non-obvious jargon inline

**Keep plans focused:**
- One plan per feature/unit of work
- Large features: break into multiple plans
- Small changes: lightweight plan is fine

**Plans are living documents:**
- Update during execution, not after
- Fresh timestamps show real progress
- Decisions logged when made, not reconstructed

## Integration with Other Skills

**Before creating execplan:**
- Use `product-spec` skill to define what to build
- Reference the spec in Purpose section

**After completing execplan:**
- Use `execplan-complete` skill to:
  - Move to docs/exec-plans/completed/
  - Update FEATURES.md
  - Extract learnings to tech-debt.md

**Related specs:**
- Spec defines "what" - ExecPlan defines "how"
- Spec has user stories - ExecPlan has concrete steps
- Spec is stable - ExecPlan evolves during execution

## Common Patterns

**Feature implementation:**
1. Spec exists with requirements
2. Create ExecPlan with milestones
3. Execute, updating Progress/Decisions/Surprises
4. Complete and move to completed/

**Research spike:**
1. Create lightweight ExecPlan
2. First milestone: "Investigate options"
3. Document findings in Surprises
4. Decision Log captures choice
5. Convert findings to design doc or full spec

**Bug fix:**
1. Minimal ExecPlan documenting issue
2. Context section shows current broken behavior
3. Plan shows fix approach
4. Validation shows bug no longer reproduces

**Refactoring:**
1. ExecPlan documents current state and target state
2. Milestones preserve functionality at each step
3. Validation ensures behavior unchanged
4. Interfaces section shows API changes
