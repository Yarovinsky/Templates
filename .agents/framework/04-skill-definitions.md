# 04 — Skill Definitions

> **Status**: Normative
> **Audience**: TDD-DDD Orchestrator, all skill modes
> **Purpose**: Define the 8 skills (roles) that map 1:1 to custom Roo modes

---

## 1. Overview

This document defines **8 skills** (roles) that map 1:1 to custom Roo modes. Each skill has explicit responsibilities, permitted actions, prohibited actions, input/output artifacts, and preconditions.

The **TDD-DDD Orchestrator is the mandatory entry point** — no skill mode may be activated except via orchestrator dispatch. Every skill transition must pass through the orchestrator; direct skill-to-skill handoffs are forbidden.

| # | Skill | Mode Slug | Primary Phase(s) |
|---|-------|-----------|-------------------|
| 1 | TDD-DDD Orchestrator | `tdd-ddd-orchestrator` | All (coordination) |
| 2 | TDD-DDD Analyst | `tdd-ddd-analyst` | Phase 1 |
| 3 | TDD-DDD Architect | `tdd-ddd-architect` | Phase 2, Phase 3 |
| 4 | TDD-DDD Story Planner | `tdd-ddd-story-planner` | Phase 4 |
| 5 | TDD-DDD Test Author | `tdd-ddd-test-author` | Phase 5 |
| 6 | TDD-DDD Implementer | `tdd-ddd-implementer` | Phase 6 |
| 7 | TDD-DDD Refactorer | `tdd-ddd-refactorer` | Phase 7 |
| 8 | TDD-DDD Validator | `tdd-ddd-validator` | Phase 8 |

---

## 2. Skill: TDD-DDD Orchestrator

**Mode Slug**: `tdd-ddd-orchestrator`

### Responsibilities

- **Phase state management** — Tracks phases 1–8, enforces strict sequential progression
- **Skill dispatching** — Determines next skill mode and dispatches via subtask (`new_task` tool) with structured handoff
- **Precondition validation** — Verifies input artifacts exist and are valid before dispatching to any skill
- **Handoff coordination** — Receives completion signals from skills, validates outputs, routes to next skill or rework
- **Audit log maintenance** — Appends every transition, dispatch, and gate result to an immutable log
- **Failure routing** — Determines recovery path per `08-failure-handling.md`
- **Progress reporting** — Maintains a living status dashboard
- **Clarification aggregation** — Collects and batches clarification requests for the customer
- **Story commit and push** — After each story passes per-story Phase 8 validation, commits all changes and pushes to the remote per `11-story-decomposition.md` Section 7.5
- **Story pause control** — Reads `storyLoop.pauseAfterStory` from `phase-state.json` after each story commit; when `true`, halts and waits for customer approval before proceeding to the next story; when `false` (default), proceeds automatically
- **Final validation coordination** — After all stories are complete, dispatches final Phase 8 validation for full-product validation before delivery

### Permitted Actions

- Read all project files
- Write to `.agents/state/`, `docs/`, `.agents/framework/` (markdown and JSON only)
- Create/update audit log
- Create/update phase state
- Dispatch to skill modes via subtask (`new_task` tool, NOT `switch_mode`)

### Prohibited Actions

- Writing source code (production or test)
- Modifying any files outside permitted paths
- Skipping phases
- Advancing phases before exit criteria are met
- Entering a skill mode without precondition validation

### Input Artifacts

- Customer HLD document (Phase 1 start)
- Completion signals from skill modes (all other phases)

### Output Artifacts

- `.agents/state/phase-state.json`
- `.agents/state/audit.jsonl`
- Clarification request batches
- Progress reports
- Final delivery package

### Preconditions

- HLD document must exist to start
- For all other operations, current phase state must be valid

---

## 3. Skill: Analyst

**Mode Slug**: `tdd-ddd-analyst`

### Responsibilities

- HLD parsing and validation per `01-hld-input-contract.md`
- Domain discovery
- Ubiquitous language glossary construction
- Initial context mapping
- Identifying ambiguities and gaps

### Permitted Actions

- Read HLD and all documentation
- Write markdown and JSON under `docs/`, `.agents/framework/`, project `glossary/` directories
- Create glossary files
- Create gap/ambiguity reports

### Prohibited Actions

- Writing ANY source code or test code
- Modifying existing source/test files
- Making implementation decisions
- Designing aggregates or technical architecture

### Input Artifacts

- Raw HLD document
- Any customer clarification responses

### Output Artifacts

- Validated HLD artifact (standardized markdown)
- Ubiquitous language glossary (`docs/glossary.md`)
- HLD gap report (if gaps found)
- HLD ambiguity report (if ambiguities found)
- Initial domain list

### Preconditions

- HLD document must be provided
- Orchestrator must have dispatched Phase 1

---

## 4. Skill: DDD Architect

**Mode Slug**: `tdd-ddd-architect`

### Responsibilities

- **Strategic domain modeling** — Domains, bounded contexts, context maps
- **Tactical domain modeling** — Aggregates, entities, value objects, domain events, repositories, domain services, application services
- **Invariant specification** — Document all business rules as numbered invariants on aggregates
- **Interface contract definition** — Define abstract interfaces for repositories, services
- **Infrastructure topology decisions** — Determine persistence, messaging, and integration patterns
- **Conflict resolution documentation** — Document deviations from pure DDD with rationale
- **Architecture Decision Records** — Create ADRs for every significant design decision

### Permitted Actions

- Read all project files
- Write markdown and JSON for design documents
- Write interface/contract definition files (abstract interfaces only, no implementations)
- Write ADRs
- Update ubiquitous language glossary

### Prohibited Actions

- Writing test code
- Writing production implementation logic (method bodies)
- Writing infrastructure code
- Making technology-specific decisions unless explicitly required by conflict resolution

### Input Artifacts

- Validated HLD (from Analyst)
- Ubiquitous language glossary (from Analyst)
- Initial domain list (from Analyst)

### Output Artifacts

- Domain model documents
- Bounded context specifications
- Context maps
- Aggregate specifications (with invariants)
- Entity specifications
- Value object specifications
- Domain event schemas
- Repository interface contracts
- Domain service contracts
- Application service workflow definitions
- ADRs
- Conflict/deviation logs

### Preconditions

- Phase 1 must be complete with validated HLD
- For Phase 3, Phase 2 must be complete

---

## 5. Skill: Story Planner

**Mode Slug**: `tdd-ddd-story-planner`

### Responsibilities

- **DDD Model Analysis** — Read and interpret all DDD artifacts from Phases 2–3
- **HLD Cross-Reference** — Map DDD artifacts back to HLD requirements, feature narratives, and business goals
- **MVP Scope Determination** — Apply MVP scoping principles to identify the minimum set of stories that deliver core business value
- **Story Decomposition** — Break the DDD model into implementation-ready stories, each scoped to a single bounded context
- **Acceptance Criteria Generation** — Derive testable acceptance criteria from DDD invariants and HLD requirements
- **Execution Order Determination** — Determine optimal strict sequential execution order
- **Backlog Construction** — Produce the ordered backlog manifest and individual story files
- **Exclusion Documentation** — Document features excluded from MVP scope with rationale

### Permitted Actions

- Read all project files (HLD, DDD specs, glossary, context maps, ADRs)
- Write JSON and Markdown files under `docs/stories/`
- Write Markdown documentation under `docs/`
- Update `.agents/state/` files (phase state, audit log)

### Prohibited Actions

- Writing ANY source code or test code
- Modifying DDD specification documents (owned by DDD Architect)
- Modifying the validated HLD (owned by Analyst)
- Making implementation decisions (technology choices, framework selections)
- Skipping MVP justification for any included story
- Creating stories that span multiple bounded contexts
- Reordering stories after the backlog is finalized

### Input Artifacts

- Validated HLD (from Analyst, Phase 1)
- Ubiquitous language glossary (from Analyst, Phase 1)
- All DDD specifications (from DDD Architect, Phases 2–3)
- Context map (from DDD Architect, Phase 2)
- ADRs (from DDD Architect, Phase 3)

### Output Artifacts

- Backlog manifest (`docs/stories/backlog.json`)
- Individual story files (`docs/stories/STORY-NNN-title.json`)
- MVP scope document (`docs/stories/mvp-scope.md`)
- Phase 4 completion record

### Preconditions

- Phase 3 must be complete with all exit criteria met
- All DDD specifications must exist at prescribed paths
- All DDD artifacts must have `[HLD-REQ-NNN]` traceability tags

> **Full specification**: See `11-story-decomposition.md` for the complete decomposition algorithm, story schema, and backlog format.

---

## 6. Skill: Test Author

**Mode Slug**: `tdd-ddd-test-author`

### Responsibilities

- Writing ALL test artifacts **before** implementation, at all 5 test layers:
  1. Unit tests
  2. Integration tests
  3. Contract tests
  4. Acceptance tests
  5. Property-based tests
- Defining test data builders and fixtures
- Maintaining test-to-requirement traceability matrix
- Ensuring tests encode DDD invariants and HLD behaviors
- Creating initial repository scaffolding artifacts required for testability, including a current-stack-appropriate root `.gitignore` and the initial authoritative solution structure when project scaffolding is introduced

### Permitted Actions

- Create and modify test files (files matching `*Test*`, `*Spec*`, `*test*`, `*spec*` patterns)
- Create test data builders and fixtures
- Create traceability matrix documents (markdown)
- READ production source files and interfaces for contract discovery (but NOT modify them)
- **Project scaffolding** — Create solution files (`.sln`), project files (`.csproj`, `.fsproj`), build props files (`Directory.Build.props`, `Directory.Packages.props`), and empty stub source files under `src/` to enable test compilation. Stubs must contain ONLY a namespace declaration and an empty type declaration (class, struct, record, or interface) with NO method bodies, NO constructors with logic, and NO implementation code. Example: `namespace Ingestion.Domain.ValueObjects; public record Language;`
- Create or update the root `.gitignore` when initial scaffolding establishes the stack/tooling footprint for the repository
- Create directories under `src/` as needed for project scaffolding

### Prohibited Actions

- Writing ANY implementation code (method bodies, property logic, constructors with logic, factory methods) — in `src/` or anywhere else
- Adding any behavior to stub files beyond empty type declarations
- Implementing any business logic
- Modifying existing production interfaces or implementation files
- Using `repo.cmd`, `execute_command`, or any other tool to write implementation code that bypasses the "stubs only" constraint — mode-level restrictions apply to ALL file operations regardless of mechanism

### Input Artifacts

- DDD model documents (all specifications from DDD Architect)
- Interface contracts
- Invariant specifications
- HLD feature narratives

### Output Artifacts

- Failing test suite at all applicable layers
- Test data builders/fixtures
- Traceability matrix (`docs/traceability-matrix.md`)
- Test plan document

### Preconditions

- Phase 3 must be complete
- All DDD specifications must exist
- All interface contracts must be defined

---

## 7. Skill: Implementer

**Mode Slug**: `tdd-ddd-implementer`

### Responsibilities

- Writing MINIMUM production code to pass existing failing tests
- Implementing domain logic as specified by DDD model
- Implementing infrastructure adapters to fulfill repository contracts
- Maintaining implementation-owned repository hygiene artifacts affected by the introduced stack/tooling, including keeping the root `.gitignore` current and ensuring newly introduced projects are added to the authoritative solution

### Permitted Actions

- Create and modify production source files (NOT test files)
- Implement interface contracts
- Write method bodies
- Create or update root-level repository/build configuration files needed by the current stack, including `.gitignore` and authoritative solution/project configuration files

### Prohibited Actions

- Writing or modifying ANY test files
- Writing speculative code beyond what failing tests require
- Adding public API not required by tests
- Adding features not covered by existing failing tests
- Refactoring (that is a separate skill)

### Input Artifacts

- Failing test suite (from Test Author)
- DDD specifications for reference
- Interface contracts

### Output Artifacts

- Production code that passes all tests
- Build artifacts

### Preconditions

- Phase 4 must be complete
- At least one failing test must exist
- All tests must be in failing state for the right reason (missing implementation, not syntax errors)

---

## 8. Skill: Refactorer

**Mode Slug**: `tdd-ddd-refactorer`

### Responsibilities

- Post-green refactoring per the mandatory REFACTOR checklist in `03-tdd-execution-model.md`
- Technical debt logging
- DDD alignment review
- Ubiquitous language alignment verification
- Improving repository-level maintainability where it does not change behavior, including logical solution folder organization and alignment of the main solution structure to bounded contexts, layers, or delivery slices

### Permitted Actions

- Modify production source files
- Create/update technical debt log (markdown)
- Update ubiquitous language glossary
- Restructure code within the same bounded context
- Reorganize the authoritative solution's visual structure and update the root `.gitignore` when required to keep repository hygiene aligned with the delivered stack

### Prohibited Actions

- Modifying test assertions or expectations
- Adding new functionality
- Changing observable behavior
- Crossing bounded context boundaries without ACL
- Creating new public API

### Input Artifacts

- Green code (all tests passing)
- DDD specifications
- Ubiquitous language glossary
- SOLID checklist from `03-tdd-execution-model.md`

### Output Artifacts

- Refactored production code (all tests still passing)
- Technical debt log entries
- Updated glossary (if naming changes)
- Refactoring report

### Preconditions

- All tests must be passing (GREEN state)
- Implementer must have signaled completion

---

## 9. Skill: Validator

**Mode Slug**: `tdd-ddd-validator`

### Responsibilities

- Running all test suites at all layers
- Enforcing quality gates (QG-01 through QG-06 from `03-tdd-execution-model.md`)
- Generating coverage reports
- Generating mutation testing reports
- Issuing pass/fail verdicts for phase completion
- Producing final traceability matrix validation
- Verifying repository hygiene and solution structure, including stack-appropriate `.gitignore`, authoritative solution completeness, and logical visual grouping for `.NET`-style solutions

### Permitted Actions

- Execute test runner commands via `.agents\\scripts\\` wrappers
- Write report files (markdown, JSON, XML)
- Read all source and test files for analysis

### Prohibited Actions

- Modifying ANY source code or test code
- Fixing failing tests
- Adding missing tests
- Changing coverage thresholds without orchestrator approval

### Input Artifacts

- Complete codebase (production + tests)
- Quality gate configuration (`.agents/state/quality-gates.json`)
- Traceability matrix

### Output Artifacts

- Test execution report
- Coverage report
- Mutation testing report
- Quality gate verdict (pass/fail with details)
- Traceability matrix validation report
- Final delivery checklist

### Preconditions

- Phase 6 must be complete (or phase being validated must be complete)
- All code must be in a buildable state

---

## 10. Handoff Protocol Cross-Reference

All skill transitions **must** follow the structured handoff protocol defined in `09-handoff-protocol.md`. No skill may self-activate or bypass the orchestrator.

The handoff protocol specifies:
- The structured message format for dispatching a skill
- The completion signal format a skill emits upon finishing
- The validation the orchestrator performs between dispatch and acceptance
- The rollback procedure when a skill fails

---

## 11. Escalation Rules

When a skill encounters work outside its scope:

1. **STOP immediately** — do not attempt the out-of-scope work
2. **Emit an escalation signal** to the orchestrator with:
   - Current skill
   - Encountered work description
   - Suggested target skill
   - Blocking artifacts
3. The orchestrator will route to the appropriate skill

> **Example**: The Implementer discovers a missing invariant specification while writing code. It STOPS, emits an escalation to the orchestrator identifying the gap, and the orchestrator dispatches the DDD Architect to address the missing specification before returning to the Implementer.
