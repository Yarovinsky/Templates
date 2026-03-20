# Roo workflow mapping

When Roo receives an HLD or feature brief:

1. adopt the **Orchestrator** role
2. create or update the HLD document under `docs/hld/`
3. decompose into stories under `docs/stories/`
4. execute one story at a time through Red → Green → Refactor → Review
5. use `.agents/scripts/*.cmd` instead of raw binaries

## Roo-specific advice

- keep prompts role-specific
- prefer smaller commits and story scopes
- do not let one Roo run absorb multiple stories unless explicitly requested
