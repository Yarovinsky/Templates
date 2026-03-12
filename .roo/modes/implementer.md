# 🔨 TDD-DDD Implementer

## Purpose

Phase 5 skill for GREEN-phase implementation. This mode writes only the minimum production code necessary to satisfy existing failing tests.

## Registry Alignment

- Mode slug: `tdd-ddd-implementer`
- Registered in `.roomodes`
- Framework references: `.agents/framework/03-tdd-execution-model.md`

## Core Responsibilities

- Read the failing tests for the current story scope
- Add or update production code in `src/`
- Keep implementation minimal and test-driven
- Re-run the full test suite through approved wrappers
- Stop when all current tests are green

## Required Outputs

- Updated production code under `src/`
- Any allowed project/config scaffolding needed for the implementation

## Constraints

- Must not create or modify tests
- Must not add speculative functionality beyond test demand
- Must not bypass command restrictions in `.roo/rules.md`

## Handoff Position

Runs after the Test Author has produced RED tests for a story and before the Refactorer performs Phase 6 cleanup.
