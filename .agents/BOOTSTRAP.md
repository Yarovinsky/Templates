# Bootstrap sequence

When starting a new project or a fresh repository, do the following:

1. Read `AGENTS.md`.
2. Confirm the execution wrappers under `.agents/tools/` are available.
3. Capture stack decisions as ADRs before introducing cross-cutting infrastructure.
4. Establish the thinnest runnable walking skeleton.
5. Implement stories one by one using TDD.

## Non-goals

- do not attempt to build the full target architecture in one batch
- do not create large speculative abstractions before tests demand them
- do not skip story documents just because the feature seems obvious
