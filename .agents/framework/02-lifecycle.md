# 02 Lifecycle

## A. HLD Intake

Create or update:

- `docs/hld/HLD-xxx-<slug>.md`
- `docs/adr/` entries if the HLD already implies hard architecture choices

Outputs:

- concise problem statement
- success criteria
- constraints
- risks
- open questions

## B. Epic and story decomposition

Create:

- `docs/stories/STORY-xxx-<slug>.md`
- optionally an iteration plan if the HLD is large

Outputs:

- ordered story list
- dependency notes
- walking skeleton identification

## C. Story delivery loop

For each story:

1. Tests go red.
2. Minimal code goes green.
3. Refactor preserves green.
4. Reviewer verifies the story.
5. Orchestrator marks the story done and selects the next one.

## D. Completion

A request is complete only when:

- all in-scope stories are done or explicitly deferred
- acceptance criteria are satisfied
- automated tests pass
- documentation is updated
- unresolved risks are recorded
