# Refactoring Report Template

Use this report to document refactoring work without mixing it with feature delivery status. The goal is to make structural improvements, rationale, and residual risks explicit.

## Summary

| Field | Value |
| --- | --- |
| Refactoring Window / Iteration | `<identifier>` |
| Lead | `<name or role>` |
| Scope | `<subsystems or modules>` |
| Driver | `<maintainability / performance / complexity / testability / design alignment>` |
| Overall Outcome | `<planned / in progress / completed>` |

## Objectives

- `<objective 1>`
- `<objective 2>`
- `<objective 3>`

## Change Log

| Area | Before | After | Motivation | Risk Level | Validation Performed |
| --- | --- | --- | --- | --- | --- |
| `<module>` | `<previous structure or behavior>` | `<new structure or behavior>` | `<reason>` | `<low / medium / high>` | `<tests, review, metrics>` |

## Design Impact Assessment

### Code Structure

Describe changes to modules, boundaries, abstractions, dependencies, or package organization.

### Domain Alignment

Describe whether the changes improved alignment with domain language, bounded contexts, or aggregate rules.

### Testability

Describe how the refactoring improved isolation, determinism, observability, or test coverage confidence.

## Metrics Comparison

| Metric | Baseline | Current | Interpretation |
| --- | --- | --- | --- |
| Complexity | `<value>` | `<value>` | `<notes>` |
| Duplication | `<value>` | `<value>` | `<notes>` |
| Coverage | `<value>` | `<value>` | `<notes>` |
| Build / Test Time | `<value>` | `<value>` | `<notes>` |

## Risks And Follow-Up

| Item | Type | Description | Action |
| --- | --- | --- | --- |
| `<id>` | `<risk / debt / deferred follow-up>` | `<description>` | `<owner and next step>` |

## Evidence

- Linked pull requests: `<links>`
- Relevant ADRs or decisions: `<links>`
- Related reports: [`docs/tech-debt-register.md`](docs/tech-debt-register.md), [`docs/reports/quality-gate-report.md`](docs/reports/quality-gate-report.md)
