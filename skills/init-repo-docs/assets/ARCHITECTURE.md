# Architecture

High-level system architecture and component overview.

## System Overview

{2-3 paragraphs describing the system at a high level}

## Core Components

### {Component 1}
- **Purpose**: {What it does}
- **Location**: {File paths or package}
- **Dependencies**: {What it depends on}

### {Component 2}
- **Purpose**: {What it does}
- **Location**: {File paths or package}
- **Dependencies**: {What it depends on}

## Package Layering

```
┌─────────────────────────┐
│     Presentation        │  UI, API endpoints
├─────────────────────────┤
│     Application         │  Business logic, use cases
├─────────────────────────┤
│     Domain              │  Core models, entities
├─────────────────────────┤
│     Infrastructure      │  Database, external services
└─────────────────────────┘
```

## Domain Map

### {Domain 1} (e.g., Authentication)
- Components: {List key components}
- Quality: {Link to QUALITY_SCORE.md}
- Design docs: {Link to relevant design docs}

### {Domain 2} (e.g., Data Layer)
- Components: {List key components}
- Quality: {Link to QUALITY_SCORE.md}
- Design docs: {Link to relevant design docs}

## Key Decisions

See [[docs/design-docs/]] for detailed architectural decisions.

Major decisions:
- {Decision 1}: [[docs/design-docs/decision-1]]
- {Decision 2}: [[docs/design-docs/decision-2]]

## Constraints & Trade-offs

- **Performance**: {Key performance considerations}
- **Scalability**: {Scalability approach}
- **Security**: {Security boundaries}
- **Maintainability**: {How we keep this maintainable}

---
For detailed design decisions, see [[docs/design-docs/index]]
