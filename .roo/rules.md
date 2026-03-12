# Roo Execution Policy

Before executing ANY command, you MUST read and strictly follow
the full execution policy defined in:

    .agents/ROO_EXECUTION_RULES.md

That file is the single source of truth for:
- which wrapper scripts are allowed
- which binaries and shell features are forbidden
- syntax, flags, path validation, and security rules for every wrapper

You MUST NOT execute any command that is not approved by that policy.
You MUST NOT bypass, ignore, or reinterpret any rule in that file.

If a command or operation you need is not covered by the existing
wrappers listed in that file, you must propose an extension to a
wrapper — never try to invoke a binary directly.

---

# TDD-DDD Development Framework

When building software products, you MUST read and strictly follow
the TDD-DDD Framework specification defined in:

    .agents/framework/

Start with the overview document:

    .agents/framework/00-overview.md

This framework defines:
- 8 mandatory development phases (HLD Intake → Story Decomposition → Validation & Delivery)
- 8 skill roles with enforced file restrictions (Orchestrator, Analyst, DDD Architect, Story Planner, Test Author, Implementer, Refactorer, Validator)
- Story-based iterative execution: Phase 3.5 decomposes the DDD model into MVP-scoped stories; Phases 4–7 execute per story
- Strict red-green-refactor TDD cycle as the only permitted development cadence
- Domain-Driven Design transformation pipeline
- Quality gates, naming conventions, and acceptance criteria
- Failure handling and recovery procedures
- Structured handoff protocol between skills (with story scoping)
- Immutable audit log requirements

The TDD-DDD Orchestrator mode (`tdd-ddd-orchestrator`) is the mandatory
entry point for all development work under this framework.

The normative framework index is at `.agents/framework/00-overview.md`. The
authoritative Story Planner / Phase 3.5 contract is defined in
`.agents/framework/11-story-decomposition.md`.

You MUST NOT skip phases, bypass the orchestrator, or violate
skill role boundaries defined in the framework.
