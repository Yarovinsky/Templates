# 📋 TDD-DDD Story Planner

## Purpose

Phase 3.5 skill for story decomposition. This mode turns the completed DDD model into an ordered, MVP-scoped backlog of implementation-ready stories.

## Registry Alignment

- Mode slug: `tdd-ddd-story-planner`
- Registered in `.roomodes`
- Framework references: `.agents/framework/11-story-decomposition.md`

## Core Responsibilities

- Analyze the Phase 2-3 DDD artifact set
- Decompose work into single-bounded-context stories
- Preserve `[HLD-REQ-NNN]` traceability in every story
- Apply MVP scoping so only must-have value and dependencies remain
- Determine the strict execution order for the story backlog

## Required Outputs

- `docs/stories/backlog.json`
- `docs/stories/STORY-NNN-title.json`
- `docs/stories/mvp-scope.md`

## Constraints

- Must not write source code or tests
- Must not modify the validated HLD or DDD specifications authored in earlier phases
- Limited to story/documentation/state artifacts allowed by `.roomodes`

## Handoff Position

Runs after the DDD Architect completes tactical modeling and before the Test Author starts Phase 4 on the first ordered story.
