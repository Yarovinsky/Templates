# Validated High-Level Design Template

Use this document to capture the approved high-level solution design after review. This template is intentionally generic and should be filled with project-specific architecture decisions, assumptions, and validation results.

## Document Control

| Field | Value |
| --- | --- |
| System / Initiative | `<name>` |
| Version | `<version>` |
| Status | `<draft / validated / superseded>` |
| Authors | `<names or roles>` |
| Reviewers | `<names or roles>` |
| Validation Date | `<yyyy-mm-dd>` |

## Executive Summary

Summarize the problem being solved, target outcomes, solution shape, and major constraints.

## Architectural Drivers

| Driver Type | Description | Priority | Source |
| --- | --- | --- | --- |
| Business | `<driver>` | `<priority>` | `<source>` |
| Quality Attribute | `<driver>` | `<priority>` | `<source>` |
| Constraint | `<driver>` | `<priority>` | `<source>` |

## System Context

Describe external actors, upstream and downstream dependencies, and trust or ownership boundaries.

## Solution Overview

### Major Components

| Component | Responsibility | Interfaces | Data Ownership | Notes |
| --- | --- | --- | --- | --- |
| `<component>` | `<responsibility>` | `<interfaces>` | `<owned data>` | `<notes>` |

### Primary Flows

Document the core end-to-end flows that drive the design.

## Cross-Cutting Concerns

- Security and privacy
- Reliability and resilience
- Observability
- Performance and scalability
- Configuration and deployment

## Key Decisions

| Decision | Rationale | Alternatives Considered | Consequences | Related ADR |
| --- | --- | --- | --- | --- |
| `<decision>` | `<why>` | `<alternatives>` | `<trade-offs>` | `<link>` |

## Assumptions And Constraints

| Type | Description | Validation Status | Owner |
| --- | --- | --- | --- |
| Assumption | `<description>` | `<pending / validated / invalidated>` | `<owner>` |
| Constraint | `<description>` | `<acknowledged>` | `<owner>` |

## Validation Outcome

| Review Area | Result | Evidence | Follow-Up |
| --- | --- | --- | --- |
| Requirements alignment | `<result>` | `<evidence>` | `<action>` |
| Feasibility | `<result>` | `<evidence>` | `<action>` |
| Operational readiness | `<result>` | `<evidence>` | `<action>` |
| Risk acceptability | `<result>` | `<evidence>` | `<action>` |

## Related Review Artifacts

- Gaps: [`docs/hld/gap-report.md`](docs/hld/gap-report.md)
- Ambiguities: [`docs/hld/ambiguity-report.md`](docs/hld/ambiguity-report.md)
- DDD alignment: [`docs/ddd/context-map.md`](docs/ddd/context-map.md)
