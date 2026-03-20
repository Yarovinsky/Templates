# Agent entry point

Before changing code in this repository, read these files in order:

1. `.agents/framework/00-overview.md`
2. `.agents/framework/01-operating-model.md`
3. `.agents/framework/02-lifecycle.md`
4. `.agents/policy/EXECUTION_RULES.md`
5. the role skill you are currently executing from `.agents/skills/`

## Core rules

- Work in **stories**, not in large unfocused batches.
- Follow **Red → Green → Refactor** for every story.
- Prefer a **walking skeleton** over broad upfront implementation.
- Use only approved command wrappers from `.agents/tools/` or `.agents/scripts/`.
- Keep documentation and code in sync.

## Role assumption

If you receive an HLD or a broad feature request and no role is specified,
assume the **Orchestrator** role first.
The Orchestrator is responsible for decomposition, delegation sequence, and completion tracking.

## Required outputs

At minimum, every implemented feature should leave behind:

- an HLD reference in `docs/hld/`
- a story file in `docs/stories/`
- automated tests in `tests/`
- production changes in `src/`
- updated ADRs if architectural decisions changed
