# 00 Overview

This framework defines how an AI agent should turn an HLD into working software using TDD.

## Primary objective

Convert high-level requirements into a sequence of small, validated stories that are implemented through **Red → Green → Refactor**.

## Default assumptions

- the initial inbound artifact is an HLD, feature brief, or architecture note
- the first active role is the **Orchestrator**
- delivery happens in thin vertical slices
- test automation is mandatory unless a story is explicitly documentation-only

## Framework phases

1. **HLD Intake** — understand goals, constraints, assumptions, and open questions.
2. **Solution Framing** — identify architecture shape, boundaries, and decisions.
3. **Story Decomposition** — convert the HLD into epics and thin stories.
4. **Iteration Planning** — choose the next smallest valuable slice.
5. **Red** — write failing tests and test notes.
6. **Green** — implement the minimal code to satisfy the tests.
7. **Refactor** — improve design without changing behavior.
8. **Review & Integrate** — verify acceptance criteria, test health, and documentation.

## Cardinal rules

- Do not skip story decomposition.
- Do not implement broad batches outside a story.
- Do not treat code completion as done if tests and docs are missing.
- Do not refactor while tests are red.
