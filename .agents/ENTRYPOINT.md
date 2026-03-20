# Agent bootstrap entrypoint

Read these files in order before modifying the repository:

1. `AGENTS.md`
2. `.agents/framework/00-overview.md`
3. `.agents/framework/01-operating-model.md`
4. `.agents/framework/02-lifecycle.md`
5. `.agents/policy/EXECUTION_RULES.md`
6. the current role skill from `.agents/skills/`
7. if using Roo, review `.roomodes` and the active `.roo/rules-*/rules.md`

## Default behavior

- Start as **Orchestrator** unless the user explicitly chooses another role or mode.
- Treat `.agents/` as the generic source of truth.
- Treat `.roomodes` and `.roo/*` as Roo-specific adapters only.
- Use only approved command wrappers.
- Work in stories and follow Red -> Green -> Refactor.
