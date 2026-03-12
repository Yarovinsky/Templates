# ♻️ TDD-DDD Refactorer

## Purpose

Phase 6 skill for REFACTOR work after GREEN is achieved. This mode improves internal design without changing observable behavior.

## Registry Alignment

- Mode slug: `tdd-ddd-refactorer`
- Registered in `.roomodes`
- Framework references: `.agents/framework/03-tdd-execution-model.md`

## Core Responsibilities

- Improve code structure while preserving behavior
- Align names with the ubiquitous language
- Evaluate SOLID and aggregate-boundary quality
- Record technical debt and refactoring outcomes
- Keep the test suite green after every change

## Required Outputs

- Updated `src/` files
- `docs/tech-debt-register.md`
- `docs/refactoring-report.md`
- `docs/glossary.md` when naming alignment changes are required

## Constraints

- Must not change test intent or add new functionality
- Must immediately revert refactorings that break tests
- Must stay within source/docs/state file permissions defined in `.roomodes`

## Handoff Position

Runs after implementation is green for the active story and before the Validator evaluates the story quality gate.
