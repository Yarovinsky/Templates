# HLD Ambiguity Report Template

Use this template to record unclear, conflicting, or underspecified items discovered during architecture analysis. This report should make uncertainty visible without guessing final answers.

## Summary

| Field | Value |
| --- | --- |
| Review Cycle | `<identifier>` |
| Source Artifacts | `<documents or versions>` |
| Prepared By | `<name or role>` |
| Date | `<yyyy-mm-dd>` |
| Risk Level | `<low / medium / high>` |

## Ambiguity Register

| Ambiguity ID | Topic | Current Statement | Why Ambiguous | Impact If Unresolved | Clarification Needed From | Status |
| --- | --- | --- | --- | --- | --- | --- |
| `HLD-AMB-001` | `<topic>` | `<quoted or summarized statement>` | `<reason>` | `<impact>` | `<role or team>` | `<open / clarified / accepted assumption>` |

## Common Ambiguity Categories

- Scope boundaries
- Ownership and responsibilities
- Data source of truth
- Performance or reliability targets
- Security or compliance expectations
- Environment and deployment assumptions

## Assumptions Logged Pending Clarification

| Assumption ID | Assumption | Rationale | Expiry / Review Trigger | Owner |
| --- | --- | --- | --- | --- |
| `<assumption-id>` | `<statement>` | `<why temporarily acceptable>` | `<trigger>` | `<owner>` |

## Resolution Tracking

| Ambiguity ID | Resolution | Resolved By | Date | Related Artifact Updates |
| --- | --- | --- | --- | --- |
| `<ambiguity-id>` | `<clarified statement>` | `<name or role>` | `<yyyy-mm-dd>` | `<documents updated>` |

## Related Artifacts

- Architecture baseline: [`docs/hld/validated-hld.md`](docs/hld/validated-hld.md)
- Traceability: [`docs/traceability-matrix.md`](docs/traceability-matrix.md)
