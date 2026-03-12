# Mutation Report Template

Use this report to summarize mutation testing outcomes and identify weak assertions, untested paths, or over-trusted coverage metrics.

## Report Metadata

| Field | Value |
| --- | --- |
| Build / Commit | `<identifier>` |
| Date | `<yyyy-mm-dd>` |
| Tooling | `<mutation tool and version>` |
| Scope | `<target modules or packages>` |
| Prepared By | `<name or role>` |

## Headline Summary

| Metric | Result | Threshold | Status |
| --- | --- | --- | --- |
| Mutation Score | `<value>` | `<threshold>` | `<pass / fail / warning>` |
| Killed Mutants | `<count>` | `<n/a>` | `<informational>` |
| Survived Mutants | `<count>` | `<n/a>` | `<informational>` |
| Timeout / No-Coverage Mutants | `<count>` | `<n/a>` | `<informational>` |

## Results By Area

| Area | Mutation Score | Key Weakness | Recommended Test Improvement | Owner |
| --- | --- | --- | --- | --- |
| `<module>` | `<value>` | `<weakness>` | `<action>` | `<owner>` |

## Surviving Mutant Analysis

| Mutant ID | Location | Why It Survived | Risk | Planned Action |
| --- | --- | --- | --- | --- |
| `<id>` | `<file/function>` | `<analysis>` | `<risk>` | `<action>` |

## Interpretation Notes

- High coverage does not guarantee strong assertions.
- Persistent surviving mutants may indicate design complexity or missing behavior specifications.
- Repeated false positives should lead to tool configuration review.

## Related Artifacts

- Coverage report: [`docs/reports/coverage-report.md`](docs/reports/coverage-report.md)
- Quality gate: [`docs/reports/quality-gate-report.md`](docs/reports/quality-gate-report.md)
