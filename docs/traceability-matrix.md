# Traceability Matrix Template

Use this matrix to connect business intent to implementation and validation evidence. Keep entries current as requirements, design artifacts, stories, and tests evolve.

## Purpose

- Prove that every important requirement is designed, implemented, and validated.
- Identify gaps, duplicates, and orphaned artifacts.
- Support audits, release readiness, and change impact analysis.

## Traceability Table

| Requirement ID | Requirement Summary | Source | Design Artifact | Delivery Artifact | Test Coverage | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `<req-id>` | `<short description>` | `<source document or decision>` | `<HLD / ADR / DDD artifact>` | `<story / PR / module>` | `<test case / suite / report>` | `<planned / in progress / implemented / validated>` | `<gaps, assumptions, links>` |

## Forward Traceability Checks

- Each requirement maps to at least one design artifact.
- Each design artifact maps to implementation work.
- Each implemented requirement maps to validation evidence.

## Backward Traceability Checks

- Each major test or delivered capability traces back to an approved requirement.
- Each architecture decision or DDD boundary has a business or operational driver.

## Gap Recording

| Gap ID | Type | Description | Owner | Action |
| --- | --- | --- | --- | --- |
| `<gap-id>` | `<missing link / stale artifact / unclear ownership>` | `<description>` | `<owner>` | `<next step>` |

## Related Artifacts

- Requirements or backlog sources: project-specific references
- Architecture validation: [`docs/hld/validated-hld.md`](docs/hld/validated-hld.md)
- Testing strategy: [`docs/test-plan.md`](docs/test-plan.md)
