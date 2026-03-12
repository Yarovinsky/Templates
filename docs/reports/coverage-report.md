# Coverage Report Template

Use this report to summarize code coverage outcomes for a build, release, or validation cycle. This template is for reporting format only and should be populated with real measurement data when used in a project.

## Report Metadata

| Field | Value |
| --- | --- |
| Build / Commit | `<identifier>` |
| Date | `<yyyy-mm-dd>` |
| Tooling | `<coverage tool and version>` |
| Scope | `<modules, packages, services>` |
| Prepared By | `<name or role>` |

## Headline Summary

| Metric | Result | Threshold | Status |
| --- | --- | --- | --- |
| Line Coverage | `<value>` | `<threshold>` | `<pass / fail / warning>` |
| Branch Coverage | `<value>` | `<threshold>` | `<pass / fail / warning>` |
| Function / Method Coverage | `<value>` | `<threshold>` | `<pass / fail / warning>` |

## Coverage By Area

| Area | Line Coverage | Branch Coverage | Risk Interpretation | Action Needed |
| --- | --- | --- | --- | --- |
| `<module>` | `<value>` | `<value>` | `<interpretation>` | `<action>` |

## Exclusions And Rationale

| Excluded Area | Reason | Approval / Justification |
| --- | --- | --- |
| `<area>` | `<reason>` | `<approval>` |

## Observations

- `<observation about trends, blind spots, or high-risk low-coverage areas>`

## Related Artifacts

- Test strategy: [`docs/test-plan.md`](docs/test-plan.md)
- Mutation analysis: [`docs/reports/mutation-report.md`](docs/reports/mutation-report.md)
- Delivery quality gate: [`docs/reports/quality-gate-report.md`](docs/reports/quality-gate-report.md)
