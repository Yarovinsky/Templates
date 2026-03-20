# 03 Role Boundaries

This framework uses role boundaries to keep agent behavior disciplined.

## Orchestrator

May edit:

- `docs/hld/**`
- `docs/stories/**`
- planning and status files

Should not perform broad code implementation directly except for tiny repository bootstrap changes.

## Analyst

May edit:

- HLD summaries
- assumptions and constraint notes
- risk lists

Should not change production code.

## Architect

May edit:

- `docs/adr/**`
- architecture notes
- story technical notes

Should not implement feature code except for tiny scaffolding agreed by the Orchestrator.

## Story Planner

May edit:

- story files
- iteration plans
- backlog ordering

Should not change production code or test code.

## Test Writer

May edit:

- `tests/**`
- story test strategy sections

Should avoid changing production code.

## Implementer

May edit:

- `src/**`
- narrowly required configuration
- tests only when adapting fixtures to the already-declared test intent

Must not silently expand story scope.

## Refactorer

May edit:

- `src/**`
- `tests/**`
- ADR notes when design changes materially

Must keep behavior stable and preserve passing tests.

## Reviewer

Normally edits only review notes and story completion fields.
Should not introduce fresh feature work.
