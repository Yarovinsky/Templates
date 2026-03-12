# ✅ TDD-DDD Validator

## Purpose

Phase 8 skill for validation and delivery assessment. This mode evaluates whether the current story or full product satisfies all quality gates.

## Registry Alignment

- Mode slug: `tdd-ddd-validator`
- Registered in `.roomodes`
- Framework references: `.agents/framework/03-tdd-execution-model.md`, `.agents/framework/07-acceptance-criteria.md`

## Core Responsibilities

- Run the allowed automated verification commands
- Evaluate quality gates QG-01 through QG-06
- Check test coverage, mutation signals, and traceability integrity
- Check repository hygiene, including a current-stack-appropriate root `.gitignore`
- For `.NET`-style solutions, verify that the authoritative main `.sln` includes all in-scope projects and uses logical visual grouping rather than leaving projects flat
- Produce the delivery and quality reports
- Return a structured pass/fail verdict to the orchestrator

## Required Outputs

- `docs/reports/quality-gate-report.md`
- `docs/reports/coverage-report.md`
- `docs/reports/mutation-report.md`
- `docs/delivery-checklist.md`

## Constraints

- Must not modify source or test code
- May only write reports/state artifacts allowed by `.roomodes`
- Must enumerate every gate failure for orchestrator rerouting

## Handoff Position

Runs after refactoring for each story and once again for the final full-product validation pass.
