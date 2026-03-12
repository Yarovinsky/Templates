# Delivery Checklist Template

Use this checklist as a reusable release and handoff baseline. Tailor it to the delivery model, risk profile, and compliance expectations of the project without presenting unchecked items as already completed.

## Document Control

| Field | Value |
| --- | --- |
| Release / Milestone | `<name>` |
| Build / Version | `<identifier>` |
| Planned Deployment Date | `<yyyy-mm-dd>` |
| Release Owner | `<name or role>` |
| Deployment Window | `<date/time window>` |
| Approval Status | `<draft / in review / approved>` |

## How To Use This Template

- Mark each item with `Done`, `N/A`, or `Pending`.
- Add evidence links where approvals, reports, or runbooks exist.
- Remove sections only when they do not apply to the delivery model.

## Release Readiness Checklist

| Area | Checklist Item | Status | Evidence / Notes | Owner |
| --- | --- | --- | --- | --- |
| Scope | Release scope is frozen and approved. | `<status>` | `<evidence>` | `<owner>` |
| Scope | Deferred items are documented and communicated. | `<status>` | `<evidence>` | `<owner>` |
| Quality | Test execution completed against approved plan. | `<status>` | `<evidence>` | `<owner>` |
| Quality | Critical and high-severity defects have approved disposition. | `<status>` | `<evidence>` | `<owner>` |
| Quality | Coverage, mutation, or equivalent quality reports reviewed. | `<status>` | `<evidence>` | `<owner>` |
| Security | Security review or scanning completed. | `<status>` | `<evidence>` | `<owner>` |
| Operations | Deployment steps validated in target-like environment. | `<status>` | `<evidence>` | `<owner>` |
| Operations | Monitoring, alerting, and logging are configured. | `<status>` | `<evidence>` | `<owner>` |
| Operations | Rollback or recovery approach is documented and tested as needed. | `<status>` | `<evidence>` | `<owner>` |
| Data | Data migration or seed strategy is validated. | `<status>` | `<evidence>` | `<owner>` |
| Documentation | User, support, or operator documentation is updated. | `<status>` | `<evidence>` | `<owner>` |
| Documentation | ADRs, architecture, and traceability artifacts are current. | `<status>` | `<evidence>` | `<owner>` |
| Governance | Required approvals are captured. | `<status>` | `<evidence>` | `<owner>` |
| Support | Ownership for post-release support is confirmed. | `<status>` | `<evidence>` | `<owner>` |

## Open Risks And Exceptions

| ID | Risk / Exception | Impact | Mitigation / Acceptance | Owner |
| --- | --- | --- | --- | --- |
| `<risk-id>` | `<description>` | `<impact>` | `<plan>` | `<owner>` |

## Approvals

| Role | Name | Decision | Date | Notes |
| --- | --- | --- | --- | --- |
| Product | `<name>` | `<approved / approved with conditions / rejected>` | `<yyyy-mm-dd>` | `<notes>` |
| Engineering | `<name>` | `<decision>` | `<yyyy-mm-dd>` | `<notes>` |
| QA | `<name>` | `<decision>` | `<yyyy-mm-dd>` | `<notes>` |
| Operations / Platform | `<name>` | `<decision>` | `<yyyy-mm-dd>` | `<notes>` |
