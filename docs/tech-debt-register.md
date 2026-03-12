# Technical Debt Register Template

Use this register to track intentionally deferred engineering work. Keep entries small enough to act on, but detailed enough to support prioritization and governance.

## Usage Guidance

- Record debt that has a known impact on maintainability, operability, quality, or delivery speed.
- Separate debt from defects; if something is broken now, track it in the defect system and link it here only if structural debt is a root cause.
- Review the register during planning, refactoring, and release readiness checks.

## Register

| ID | Title | Area | Debt Type | Description | Impact | Likelihood | Priority | Owner | Target Resolution | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `TD-001` | `<short title>` | `<component or domain>` | `<code / architecture / test / data / infra / process>` | `<what was deferred and why>` | `<impact>` | `<low / medium / high>` | `<low / medium / high / critical>` | `<owner>` | `<date or milestone>` | `<open / planned / in progress / resolved / accepted>` |

## Detailed Entry Template

### `TD-XXX` - `<title>`

| Field | Value |
| --- | --- |
| Date Raised | `<yyyy-mm-dd>` |
| Raised By | `<name or role>` |
| Related Story / Work Item | `<identifier>` |
| Related Artifact | `<doc, PR, ADR, report>` |
| Root Cause | `<why the debt exists>` |
| Consequences Of Delay | `<what gets worse if not addressed>` |
| Proposed Remediation | `<recommended next step>` |
| Acceptance Rationale | `<why the debt is temporarily acceptable>` |

## Review Cadence

| Review Date | Participants | Decisions | Notes |
| --- | --- | --- | --- |
| `<yyyy-mm-dd>` | `<roles>` | `<reprioritized / accepted / scheduled / resolved>` | `<notes>` |

## Cross-References

- Refactoring outcomes: [`docs/refactoring-report.md`](docs/refactoring-report.md)
- Quality exceptions: [`docs/reports/quality-gate-report.md`](docs/reports/quality-gate-report.md)
- Delivery risk review: [`docs/delivery-checklist.md`](docs/delivery-checklist.md)
