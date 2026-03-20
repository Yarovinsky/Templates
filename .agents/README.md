# .agents framework

This repository uses a **generic-first agent framework**.
The goal is to separate the stable development model from any single agent runtime.

## Top-level structure

- `policy/` — execution and safety policy for wrappers
- `tools/` — canonical command wrappers, shared library, manifest, tests
- `scripts/` — compatibility entry points for agents that already expect this path
- `framework/` — lifecycle, role model, TDD workflow, handoffs, quality gates
- `skills/` — role-specific operating instructions
- `templates/` — reusable document templates
- `adapters/` — runtime-specific integration guidance, for example Roo

## Use model

- **generic core** lives under `.agents/framework`, `.agents/policy`, `.agents/tools`, and `.agents/skills`
- **runtime adapters** live under `.agents/adapters/<runtime>/`
- the repository remains usable even if the runtime changes later
