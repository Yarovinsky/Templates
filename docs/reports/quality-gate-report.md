# Quality Gate Report Template

Use this template to summarize whether a build, release candidate, or milestone satisfies the project's defined quality gate. Populate it with actual evidence during execution; do not use it as a placeholder sign-off.

## Gate Metadata

| Field | Value |
| --- | --- |
| Release / Build | `<identifier>` |
| Assessment Date | `<yyyy-mm-dd>` |
| Assessed By | `<name or role>` |
| Scope | `<systems, modules, or stories>` |
| Gate Status | `<pass / conditional pass / fail>` |

## Gate Criteria Summary

| Criterion | Threshold / Expectation | Result | Status | Evidence |
| --- | --- | --- | --- | --- |
| Automated tests | `<expectation>` | `<result>` | `<status>` | `<evidence>` |
| Coverage | `<expectation>` | `<result>` | `<status>` | `<evidence>` |
| Mutation | `<expectation>` | `<result>` | `<status>` | `<evidence>` |
| Defect severity | `<expectation>` | `<result>` | `<status>` | `<evidence>` |
| Security checks | `<expectation>` | `<result>` | `<status>` | `<evidence>` |
| Performance / reliability | `<expectation>` | `<result>` | `<status>` | `<evidence>` |
| Documentation / traceability | `<expectation>` | `<result>` | `<status>` | `<evidence>` |

## Exceptions And Waivers

| ID | Exception | Justification | Approved By | Expiry | Risk |
| --- | --- | --- | --- | --- | --- |
| `<id>` | `<exception>` | `<reason>` | `<approver>` | `<date>` | `<risk>` |

## Decision Narrative

Summarize the reasons for the gate result, including major strengths, unresolved concerns, and conditions for proceeding.

## Linked Evidence

- Test planning and execution: [`docs/test-plan.md`](docs/test-plan.md)
- Coverage summary: [`docs/reports/coverage-report.md`](docs/reports/coverage-report.md)
- Mutation summary: [`docs/reports/mutation-report.md`](docs/reports/mutation-report.md)
- Delivery readiness: [`docs/delivery-checklist.md`](docs/delivery-checklist.md)
