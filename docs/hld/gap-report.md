# HLD Gap Report Template

Use this template to capture missing architectural information, unresolved design areas, or incomplete validation items discovered during high-level design review.

## Summary

| Field | Value |
| --- | --- |
| Review Cycle | `<identifier>` |
| Reviewed Artifact | `<document or version>` |
| Facilitator | `<name or role>` |
| Date | `<yyyy-mm-dd>` |
| Overall Assessment | `<informational / needs follow-up / release blocker>` |

## Gap Register

| Gap ID | Area | Description | Why It Matters | Severity | Recommended Action | Owner | Due Date | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `HLD-GAP-001` | `<area>` | `<missing or incomplete design content>` | `<impact>` | `<low / medium / high / critical>` | `<action>` | `<owner>` | `<yyyy-mm-dd>` | `<open / in progress / closed / accepted>` |

## Review Dimensions

### Functional Coverage

Note any missing flows, use cases, or integrations.

### Quality Attributes

Note any missing treatment of availability, security, performance, observability, maintainability, or other non-functional drivers.

### Operational Concerns

Note any missing deployment, support, migration, rollback, or runbook detail.

### Governance And Traceability

Note any missing links to requirements, ADRs, risk registers, or validation evidence.

## Escalations And Decisions Needed

| Topic | Needed From | Decision Required | Target Date |
| --- | --- | --- | --- |
| `<topic>` | `<team or role>` | `<decision>` | `<yyyy-mm-dd>` |

## Related Artifacts

- Validated HLD: [`docs/hld/validated-hld.md`](docs/hld/validated-hld.md)
- Ambiguities: [`docs/hld/ambiguity-report.md`](docs/hld/ambiguity-report.md)
