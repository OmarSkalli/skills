# Quality Score

Quality tracking by domain and architectural layer.

## Scoring Criteria

Each domain is scored on:
- **Test Coverage** (0-5): Unit, integration, e2e tests
- **Documentation** (0-5): Code comments, design docs, runbooks
- **Code Quality** (0-5): Maintainability, clarity, patterns
- **Reliability** (0-5): Error handling, monitoring, recovery
- **Performance** (0-5): Speed, efficiency, scalability

**Overall Score** = Average of all criteria

## Domain Scores

### Authentication & Authorization
- Test Coverage: {score}/5 - {notes}
- Documentation: {score}/5 - {notes}
- Code Quality: {score}/5 - {notes}
- Reliability: {score}/5 - {notes}
- Performance: {score}/5 - {notes}
- **Overall**: {avg}/5

**Gaps**: {What needs improvement}

### Data Layer
- Test Coverage: {score}/5 - {notes}
- Documentation: {score}/5 - {notes}
- Code Quality: {score}/5 - {notes}
- Reliability: {score}/5 - {notes}
- Performance: {score}/5 - {notes}
- **Overall**: {avg}/5

**Gaps**: {What needs improvement}

## Architectural Layer Scores

### Presentation Layer
- **Overall**: {score}/5
- **Gaps**: {notes}

### Application Layer
- **Overall**: {score}/5
- **Gaps**: {notes}

### Domain Layer
- **Overall**: {score}/5
- **Gaps**: {notes}

### Infrastructure Layer
- **Overall**: {score}/5
- **Gaps**: {notes}

## Historical Tracking

| Date | Domain | Score | Change | Notes |
|------|--------|-------|--------|-------|
| {YYYY-MM-DD} | {Domain} | {score}/5 | +0.5 | {What improved} |

---
Updated: {YYYY-MM-DD}

Quality scores help identify where to invest effort. Re-evaluate quarterly or after major features.
