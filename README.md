# Generic Agent TDD Template

This repository is a **generic-first template for AI-agent-assisted TDD development**.
It is designed so the same repository can be used with Roo today and other agent runtimes later.
The core framework lives in `.agents/`; agent-specific integration lives in `.agents/adapters/`.

## What this template gives you

- a bounded command surface for agents via `.agents/tools/` and `.agents/scripts/`
- a role-based delivery model from **HLD → epics → stories → tests → code → review**
- explicit TDD workflow with **Red → Green → Refactor**
- templates for HLD intake, stories, ADRs, test plans, and iteration planning
- a walking-skeleton-first implementation strategy
- compatibility guidance for Roo without making the repository Roo-centric

## Repository layout

- `.agents/` — agent framework, skills, tools, policies, templates
- `docs/hld/` — high-level design inputs
- `docs/stories/` — decomposed implementation stories
- `docs/adr/` — architecture decision records
- `docs/test-reports/` — execution and validation reports
- `src/` — production code
- `tests/` — automated tests

## Default operating model

1. The agent that receives an HLD acts as the **Orchestrator**.
2. The Orchestrator reads the framework docs in `.agents/framework/`.
3. The HLD is decomposed into epics and thin vertical stories.
4. For each story, the flow is:
   - Test Writer creates failing tests.
   - Implementer makes the minimal production change to go green.
   - Refactorer improves design while preserving green.
   - Reviewer verifies acceptance criteria, scope discipline, and test quality.
5. The Orchestrator updates the story status and picks the next slice.

## First files an agent should read

- `AGENTS.md`
- `.agents/framework/00-overview.md`
- `.agents/framework/01-operating-model.md`
- `.agents/policy/EXECUTION_RULES.md`
- the relevant role skill in `.agents/skills/`

## Principle

This template is intentionally **TDD-first, story-first, and generic-first**.
It is not tied to a single language or runtime.
Project-specific stack decisions should be documented as ADRs under `docs/adr/`.


## Roo support

This template now includes:

- `.roo/rules.md` for repository-wide Roo behavior
- `.roomodes` for project-specific Roo modes
- `.roo/rules-*/rules.md` for per-mode guidance

Recommended Roo flow:
- start in Orchestrator
- decompose with Story Decomposer
- align design with Architect
- execute implementation through TDD Red -> TDD Green -> TDD Refactor
- finish with Reviewer
