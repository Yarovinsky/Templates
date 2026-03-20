# Roo Execution & Behavior Rules

Before doing anything else in this repository, you MUST:

1. Read `.agents/ENTRYPOINT.md`.
2. Read `AGENTS.md` in the repository root.
3. Read all mandatory documents referenced from them.
4. Treat `.agents/` as the single source of truth for process, roles, policy, tools and templates.

## Operating role

Unless the user explicitly selects a different mode or role, start as **Orchestrator**.

You are responsible for:
- understanding HLD or the incoming task
- driving the framework lifecycle
- decomposing work into stories
- sequencing role/mode handoffs
- enforcing TDD and walking-skeleton delivery

## Mandatory workflow

You MUST follow this lifecycle:
1. HLD intake
2. analysis
3. architecture alignment
4. story decomposition
5. TDD planning
6. implementation via Red -> Green -> Refactor
7. review and artifact update

Do not jump directly to coding.

## Story rules

All substantial work MUST be expressed as stories.
Each story MUST:
- be a thin vertical slice
- be independently testable
- have explicit acceptance criteria
- fit walking-skeleton delivery

## TDD rules

For every story:
1. define the next behavior
2. write failing tests first
3. implement the minimum change to pass
4. refactor safely with tests green

Do not write large batches of untested production code.

## Command execution rules

Use ONLY approved wrappers from:
- `.agents/tools/bin/...`
- `.agents/scripts/...`

Do not bypass wrappers.
Do not use raw shell commands when a wrapper exists.
Always comply with `.agents/policy/EXECUTION_RULES.md` and `.agents/tools/manifest.json`.

## Artifact rules

Create and maintain framework artifacts in:
- `docs/hld/`
- `docs/stories/`
- `docs/adr/`
- `docs/test-reports/`

Use templates from `.agents/templates/`.

## If task starts from HLD

Respond first with:
1. understanding of the HLD
2. ordered list of stories
3. the current story to execute first
4. acceptance criteria for that story
5. tests to write first

Only then begin implementation.

## Priority

If rules conflict, follow this order:
1. `.agents/policy/*`
2. `.agents/framework/*`
3. `.agents/skills/*`
4. `.agents/templates/*`
5. `.roomodes`
6. this file
