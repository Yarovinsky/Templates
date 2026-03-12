# Test Plan Template

Use this template to define how solution quality will be validated. The plan should describe approach, scope, environments, responsibilities, entry and exit criteria, and evidence expectations.

## Document Control

| Field | Value |
| --- | --- |
| Project / Product | `<name>` |
| Release / Iteration | `<identifier>` |
| Author | `<name or role>` |
| Reviewers | `<roles or names>` |
| Version | `<version>` |
| Status | `<draft / approved / superseded>` |

## Objectives

- `<quality objective 1>`
- `<quality objective 2>`
- `<quality objective 3>`

## Test Scope

### In Scope

- `<feature, capability, interface, or risk area>`

### Out Of Scope

- `<explicit exclusions>`

## Test Strategy

| Test Level / Type | Purpose | Technique | Owner | Environment / Tooling |
| --- | --- | --- | --- | --- |
| Unit | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |
| Integration | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |
| Contract / API | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |
| End-to-End | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |
| Performance | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |
| Security | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |
| Exploratory / UAT | `<purpose>` | `<approach>` | `<owner>` | `<tools>` |

## Quality Risks And Coverage Focus

| Risk ID | Risk Description | Impact | Likelihood | Planned Test Response |
| --- | --- | --- | --- | --- |
| `<risk-id>` | `<description>` | `<impact>` | `<likelihood>` | `<coverage approach>` |

## Environments And Test Data

| Environment | Purpose | Configuration Notes | Test Data Strategy | Owner |
| --- | --- | --- | --- | --- |
| `<env>` | `<purpose>` | `<notes>` | `<seed / synthetic / masked / ephemeral>` | `<owner>` |

## Entry Criteria

- `<criterion>`

## Exit Criteria

- `<criterion>`

## Defect Management

Describe severity model, triage process, response expectations, and release decision rules.

## Reporting And Evidence

Link or reference the artifacts used to demonstrate execution quality.

- Traceability: [`docs/traceability-matrix.md`](docs/traceability-matrix.md)
- Coverage report: [`docs/reports/coverage-report.md`](docs/reports/coverage-report.md)
- Mutation report: [`docs/reports/mutation-report.md`](docs/reports/mutation-report.md)
- Quality gate summary: [`docs/reports/quality-gate-report.md`](docs/reports/quality-gate-report.md)
