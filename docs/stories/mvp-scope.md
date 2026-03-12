# MVP Scope

This template captures the Story Planner output for **Phase 3.5: Story Decomposition**.

## Purpose

- Record which bounded contexts, capabilities, and story slices are included in the MVP.
- Document which features are explicitly deferred and why.
- Provide a stable baseline artifact that matches [`docs/stories/backlog.json`](docs/stories/backlog.json).

## Scope Summary

| Field | Value |
| --- | --- |
| Project / Product | `<name-derived-from-validated-hld>` |
| Phase | `3.5` |
| Prepared By | `Story Planner` |
| Decision Date | `<yyyy-mm-dd>` |
| Scope Principle | `Include only must-have business value plus required transitive dependencies.` |

## Included in MVP

### Included Bounded Contexts

- `CoreDomain`

### Included Story Sequence

1. [`docs/stories/STORY-001-create-core-aggregate.json`](docs/stories/STORY-001-create-core-aggregate.json)
2. [`docs/stories/STORY-002-orchestrate-core-application-workflow.json`](docs/stories/STORY-002-orchestrate-core-application-workflow.json)

### Inclusion Rationale

- The included stories establish the minimum domain model needed to deliver core business value.
- Dependencies are ordered sequentially so later workflow stories build on completed aggregate capabilities.
- Each included story remains scoped to a single bounded context.

## Explicitly Excluded from MVP

| Feature / Capability | Reason for Deferral | Related Requirements |
| --- | --- | --- |
| `Advanced reporting dashboard` | Valuable, but not required for first usable release. | `HLD-REQ-045` |
| `<optional future enhancement>` | `<reason>` | `<HLD-REQ-NNN>` |

## Validation Checks

- Every included story maps to at least one `HLD-REQ-NNN` tag.
- No story spans multiple bounded contexts.
- Story ordering respects declared dependencies.
- Exclusions are intentional and documented, not accidental omissions.

## Maintenance Notes

- Keep backlog summary values synchronized with [`docs/stories/backlog.json`](docs/stories/backlog.json).
- Use kebab-case story filenames in all references: `STORY-NNN-kebab-case-title.json`.
- Update this document whenever Phase 3.5 regenerates the story backlog.
