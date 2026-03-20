# 01 Operating Model

## Who receives the HLD?

The agent that first receives an HLD, product brief, or broad implementation request becomes the **Orchestrator**.
This role owns the end-to-end flow until the requested scope is delivered or explicitly paused.

## Required orchestration sequence

The Orchestrator should drive work through this sequence:

1. **Analyst** extracts goals, constraints, actors, and ambiguity.
2. **Architect** defines the minimal viable design and identifies ADR-worthy choices.
3. **Story Planner** decomposes the work into epics and thin stories.
4. **Test Writer** writes the failing tests for the next story.
5. **Implementer** performs the minimal production change to make tests pass.
6. **Refactorer** improves design while preserving green.
7. **Reviewer** checks scope, quality, and completion evidence.
8. **Orchestrator** updates status, decides next slice, and repeats.

## Story-first rule

The Orchestrator must not authorize implementation before a story file exists with:

- goal
- acceptance criteria
- explicit out-of-scope list
- test strategy
- completion checklist

## Escalation rule

If a story reveals a missing architectural decision, pause coding long enough to capture an ADR or story amendment, then continue.
