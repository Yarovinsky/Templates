# 09 Handoff Protocol

Each role handoff should leave a concrete artifact, not just intent.

## Analyst → Architect

Must provide:

- problem summary
- constraints
- risks
- open questions

## Architect → Story Planner

Must provide:

- target shape of the slice
- required seams or interfaces
- ADR references

## Story Planner → Test Writer

Must provide:

- one ready story
- acceptance criteria
- explicit out-of-scope notes
- test strategy hints

## Test Writer → Implementer

Must provide:

- failing tests
- clear statement of intended behavior

## Implementer → Refactorer

Must provide:

- passing tests
- summary of the minimal solution

## Refactorer → Reviewer

Must provide:

- passing test evidence
- rationale for structural changes

## Reviewer → Orchestrator

Must provide:

- approve or reject
- specific gaps if rejected
- explicit completion note if approved
