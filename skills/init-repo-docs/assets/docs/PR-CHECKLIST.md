# PR Checklist

Repo-specific checks to run before opening a pull request. Used by the `pr-checklist` skill alongside universal checks (lint, format, type check, tests).

## How to Use

Each item is either:
- **A command** — the skill will run it automatically
- **A prompt** — the skill will ask for confirmation

Add, remove, or adjust items as the project evolves.

---

## Code Quality

- [ ] `{npm run lint}` — no lint errors
- [ ] `{npm run format:check}` — code is formatted
- [ ] `{npm run typecheck}` — no type errors

## Tests

- [ ] `{npm test}` — all tests pass
- [ ] `{npm run test:coverage}` — coverage meets threshold
- [ ] New behavior has test coverage

## Database

- [ ] Database migrations included for any schema changes
- [ ] Migrations are reversible (down migration exists)
- [ ] No breaking changes to existing data

## API & Interfaces

- [ ] Public API changes are backwards compatible (or breaking change is intentional and documented)
- [ ] API documentation updated if endpoints changed

## Observability

- [ ] New features have appropriate logging
- [ ] Errors are tracked and surfaced
- [ ] Key operations have metrics or traces (if applicable)

## Environment & Configuration

- [ ] New environment variables are documented (e.g. in `.env.example`)
- [ ] No secrets or credentials committed
- [ ] `.gitignore` updated if new file types should be excluded

## Documentation

- [ ] `AGENTS.md` updated if structure or entry points changed
- [ ] `README.md` updated if setup or usage changed
- [ ] Inline comments added for non-obvious logic

---

*Add repo-specific checks below as the project grows.*
