# 05 — Phase Definitions

> **Status**: Normative
> **Audience**: TDD-DDD Orchestrator, all skill modes
> **Purpose**: Define the 8 phases (1–8), their entry/exit criteria, activities, and output artifacts

---

## 1. Phase Sequence Rule

There are **8 mandatory phases** executed in **strict sequential order**:

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → [Phase 5 → Phase 6 → Phase 7 → Phase 8] × N stories
```

After Phase 4 (Story Decomposition), the orchestrator enters a **story iteration loop**: Phases 5–8 are executed sequentially for each story in the backlog, one story at a time. After all stories complete, a final full-product validation pass is performed.

**Rules**:
- No phase may be skipped or reordered
- Phase advancement requires ALL exit criteria to be met
- The orchestrator verifies exit criteria before advancing
- A phase may iterate internally (e.g., rework within Phase 1 for clarifications) without advancing
- Backward routing is permitted only when a later phase's quality gate fails, and only the orchestrator may authorize it
- During the story loop, Phases 5–8 are scoped to the current story; all handoff messages include `storyScope` (see `11-story-decomposition.md`)

---

## 2. Phase 1: HLD Intake and Validation

**Owner Skill**: TDD-DDD Analyst (`tdd-ddd-analyst`)

### Entry Criteria

- Customer has provided HLD document

### Activities

1. Parse HLD document structure
2. Validate all 6 required HLD sections are present (per `01-hld-input-contract.md`)
3. Normalize requirement IDs to `[HLD-REQ-NNN]` format
4. Extract ubiquitous language terms and seed glossary
5. Identify gaps (missing information) and ambiguities (unclear requirements)

### Exit Criteria

- All 6 HLD sections present and validated
- All requirement IDs assigned in `[HLD-REQ-NNN]` format
- Ubiquitous language glossary seeded
- No unresolved gaps or ambiguities

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Validated HLD | Markdown | `docs/hld/validated-hld.md` |
| Gap Report | Markdown | `docs/hld/gap-report.md` (if gaps found) |
| Ambiguity Report | Markdown | `docs/hld/ambiguity-report.md` (if ambiguities found) |
| Initial Glossary | Markdown | `docs/glossary.md` |
| Phase 1 Completion Record | JSON | `.agents/state/phase-1-complete.json` |

### Iteration

If gaps or ambiguities are found, **halt** and request customer clarification. Re-enter Phase 1 after clarification is received. The phase does not advance until all gaps and ambiguities are resolved.

---

## 3. Phase 2: Strategic Domain Modeling

**Owner Skill**: TDD-DDD Architect (`tdd-ddd-architect`)

### Entry Criteria

- Phase 1 complete
- Validated HLD exists at `docs/hld/validated-hld.md`

### Activities

1. Identify domains from HLD requirements and glossary
2. Delineate bounded contexts with clear scope statements
3. Create context maps showing all relationships between bounded contexts
4. Specify relationship types (ACL, Shared Kernel, Customer-Supplier, Conformist, etc.)
5. Refine ubiquitous language glossary with domain-specific terms

### Exit Criteria

- All domains identified and named using ubiquitous language
- All bounded contexts defined with scope statements
- Context map complete with all relationship types specified
- Glossary updated with strategic modeling terms

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Domain Model | Markdown | `docs/ddd/domains.md` |
| Bounded Context Specs | Markdown | `docs/ddd/bounded-contexts.md` |
| Context Map | Markdown + Diagram | `docs/ddd/context-map.md` |
| Updated Glossary | Markdown | `docs/glossary.md` |
| Phase 2 Completion Record | JSON | `.agents/state/phase-2-complete.json` |

---

## 4. Phase 3: Tactical Domain Modeling

**Owner Skill**: TDD-DDD Architect (`tdd-ddd-architect`)

### Entry Criteria

- Phase 2 complete
- Strategic model exists (domains, bounded contexts, context map)

### Activities

1. Define aggregates with numbered invariant lists
2. Define entities with identity rules
3. Define value objects with immutability contracts and equality semantics
4. Define domain events with schemas
5. Define repository interfaces (one per aggregate root)
6. Define domain services for cross-aggregate logic
7. Define application services and workflows mapping to HLD feature narratives
8. Document all conflicts and deviations from pure DDD
9. Create Architecture Decision Records for significant decisions
10. Tag all artifacts with `[HLD-REQ-NNN]` traceability

### Exit Criteria

- All aggregates defined with invariant lists
- All entities have identity rules
- All value objects have equality semantics
- All domain events have schemas
- All repository interfaces defined
- All cross-aggregate logic in domain services
- All use cases have application service workflows
- All artifacts have `[HLD-REQ-NNN]` traceability tags

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Aggregate Specifications | Markdown | `docs/ddd/aggregates/` (one file per aggregate) |
| Entity Specifications | Markdown | `docs/ddd/entities/` |
| Value Object Specifications | Markdown | `docs/ddd/value-objects/` |
| Domain Event Schemas | Markdown | `docs/ddd/events/` |
| Repository Contracts | Markdown | `docs/ddd/repositories/` |
| Domain Service Specs | Markdown | `docs/ddd/domain-services/` |
| Application Service Workflows | Markdown | `docs/ddd/application-services/` |
| Conflict/Deviation Log | Markdown | `docs/ddd/conflicts.md` |
| ADRs | Markdown | `docs/adr/` (numbered: `ADR-NNN-title.md`) |
| Phase 3 Completion Record | JSON | `.agents/state/phase-3-complete.json` |

---

## 5. Phase 4: Story Decomposition

**Owner Skill**: TDD-DDD Story Planner (`tdd-ddd-story-planner`)

### Entry Criteria

- Phase 3 complete with all exit criteria met
- All DDD specifications exist at prescribed paths
- All DDD artifacts have `[HLD-REQ-NNN]` traceability tags
- Ubiquitous language glossary finalized

### Activities

1. Inventory all DDD artifacts across all bounded contexts
2. Map DDD artifacts to HLD requirements via traceability tags
3. Apply MVP filter based on business goal MoSCoW priorities
4. Group MVP-in-scope DDD artifacts into implementation-ready stories
5. Determine strict sequential execution order
6. Generate testable acceptance criteria for each story
7. Write individual story files and backlog manifest
8. Document excluded features with rationale

### Exit Criteria

- All stories created with complete fields per the story schema in `11-story-decomposition.md`
- Every `[HLD-REQ-NNN]` tag in the DDD model is covered by at least one story
- Every story has at least one testable acceptance criterion
- Backlog manifest created with correct story count and ordering
- MVP scope document produced with inclusion/exclusion rationale
- No stories span multiple bounded contexts
- Sequential ordering respects dependency constraints

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Backlog Manifest | JSON | `docs/stories/backlog.json` |
| Individual Story Files | JSON | `docs/stories/STORY-NNN-title.json` |
| MVP Scope Document | Markdown | `docs/stories/mvp-scope.md` |
| Phase 4 Completion Record | JSON | `.agents/state/phase-4-complete.json` |

> **Full specification**: See `11-story-decomposition.md` for the complete decomposition algorithm, story schema, backlog format, and story-scoped iteration loop.

---

## 6. Phase 5: Test Specification (Story-Scoped)

**Owner Skill**: TDD-DDD Test Author (`tdd-ddd-test-author`)

> **Story Loop**: After Phase 4, Phases 5–8 are executed iteratively for each story in the backlog. The orchestrator dispatches each phase with a `storyScope` field in the handoff message, scoping the work to the current story's bounded context, aggregates, DDD artifacts, and acceptance criteria.

### Entry Criteria

- Phase 4 complete
- All DDD specifications exist

### Activities

1. Write failing unit tests for every aggregate invariant and value object
2. Write failing integration tests for cross-component interactions
3. Write failing contract tests for every bounded context interface
4. Write failing acceptance tests for every application workflow
5. Write failing property-based tests for value objects and invariants where applicable
6. Create test data builders and fixtures
7. Create traceability matrix mapping tests to `[HLD-REQ-NNN]` requirements

### Exit Criteria

- Every aggregate invariant has at least one unit test
- Every value object has equality and validation tests
- Every bounded context interface has a contract test
- Every application workflow has an acceptance test
- Every test has `[HLD-REQ-NNN]` traceability (via comment or attribute)
- All tests are in FAILING state (RED)
- Traceability matrix complete with no orphaned requirements

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Unit Test Files | Source code | `tests/unit/` mirroring `src/` structure |
| Integration Test Files | Source code | `tests/integration/` |
| Contract Test Files | Source code | `tests/contract/` |
| Acceptance Test Files | Source code | `tests/acceptance/` |
| Property-Based Test Files | Source code | `tests/property/` |
| Test Data Builders | Source code | `tests/builders/` |
| Traceability Matrix | Markdown | `docs/traceability-matrix.md` |
| Test Plan | Markdown | `docs/test-plan.md` |
| Phase 5 Completion Record | JSON | `.agents/state/phase-5-complete.json` |

### Iteration

Uses the red-green-refactor cycle internally — **RED only**. All tests must be written to fail. Tests must fail for the right reason (missing implementation, not syntax errors).

---

## 7. Phase 6: Implementation (Story-Scoped)

**Owner Skill**: TDD-DDD Implementer (`tdd-ddd-implementer`)

> **Story Loop**: Scoped to the current story's failing tests and DDD artifacts. The Implementer writes minimum code to pass the story's tests while ensuring all previously passing tests (from prior stories) continue to pass.

### Entry Criteria

- Phase 5 complete
- Failing test suite exists

### Activities

1. Write minimum production code to pass each failing test
2. Implement domain logic as specified by DDD model
3. Implement infrastructure adapters to fulfill repository contracts
4. Verify GREEN state after each implementation step

### Exit Criteria

- ALL tests pass (GREEN state)
- No speculative code added
- All production code traceable to a test

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Production Source Code | Source code | `src/` organized by bounded context |
| Build Configuration | Technology-specific | Project root |
| Phase 6 Completion Record | JSON | `.agents/state/phase-6-complete.json` |

### Iteration

Red-green cycle — implement one test at a time, verify GREEN, proceed to next. Do not batch implementations.

---

## 8. Phase 7: Refactoring (Story-Scoped)

**Owner Skill**: TDD-DDD Refactorer (`tdd-ddd-refactorer`)

> **Story Loop**: Scoped to the current story's production code. The Refactorer applies the REFACTOR checklist to code introduced by the current story, while ensuring all tests (current story and all prior stories) continue to pass.

### Entry Criteria

- Phase 6 complete
- All tests passing

### Activities

1. Apply REFACTOR checklist from `03-tdd-execution-model.md`
2. Align naming with ubiquitous language glossary
3. Evaluate aggregate boundaries for correctness
4. Ensure SOLID compliance
5. Log technical debt items with severity and effort estimates

### Exit Criteria

- All refactoring checklist items evaluated
- All tests still passing
- Technical debt logged
- Ubiquitous language alignment verified
- No naming mismatches with glossary

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Refactored Source Code | Source code | `src/` (modified in place) |
| Technical Debt Register | Markdown | `docs/tech-debt-register.md` |
| Refactoring Report | Markdown | `docs/refactoring-report.md` |
| Updated Glossary | Markdown | `docs/glossary.md` (if naming changes) |
| Phase 7 Completion Record | JSON | `.agents/state/phase-7-complete.json` |

### Iteration

Refactor one concern at a time. Verify GREEN after each change. If a refactoring breaks a test, revert and reassess.

---

## 9. Phase 8: Validation and Delivery (Story-Scoped + Final)

**Owner Skill**: TDD-DDD Validator (`tdd-ddd-validator`)

> **Story Loop**: Phase 8 is invoked twice: (1) **Per-story validation** — after each story's Phase 7, applying quality gates scoped to the story's tests, coverage, and traceability. (2) **Final full-product validation** — after all stories complete, applying quality gates across the entire codebase. See `11-story-decomposition.md` Section 7 for story-scoped quality gate behavior.
>
> **Git Commit on Story Completion**: After a story passes its per-story Phase 8 validation, the orchestrator commits all changes and pushes to the remote. See `11-story-decomposition.md` Section 7.5 for the commit procedure, message format, and rules.

### Entry Criteria

- Phase 7 complete (for current story, or for all stories in final validation)
- All tests passing
- Refactoring complete

### Activities

1. Run all test suites at all layers (unit, integration, contract, acceptance, property-based)
2. Enforce all quality gates (QG-01 through QG-05 from `03-tdd-execution-model.md`)
3. Generate coverage report
4. Generate mutation testing report
5. Validate traceability matrix completeness (no orphaned requirements or tests)
6. Compile final deliverables and delivery checklist

### Exit Criteria

- All quality gates pass
- Traceability matrix complete with no orphans
- Coverage and mutation thresholds met
- All documentation finalized

### Output Artifacts

| Artifact | Format | Path Convention |
|----------|--------|-----------------|
| Quality Gate Report | Markdown + JSON | `docs/reports/quality-gate-report.md` |
| Coverage Report | Technology-specific + Summary MD | `docs/reports/coverage-report.md` |
| Mutation Testing Report | Technology-specific + Summary MD | `docs/reports/mutation-report.md` |
| Final Traceability Matrix | Markdown | `docs/traceability-matrix.md` (validated) |
| ADR Collection | Markdown | `docs/adr/` (finalized) |
| Technical Debt Register | Markdown | `docs/tech-debt-register.md` (finalized) |
| Delivery Checklist | Markdown | `docs/delivery-checklist.md` |
| Phase 8 Completion Record | JSON | `.agents/state/phase-8-complete.json` |

### Failure

If any quality gate fails, the orchestrator routes back to the appropriate phase:
- **Missing tests** → Phase 5 (Test Author)
- **Failing tests** → Phase 6 (Implementer)
- **Quality/structure issues** → Phase 7 (Refactorer)

The orchestrator determines the correct routing based on the quality gate failure details.

---

## 10. Phase Completion Record Schema

Each phase produces a **completion record** in JSON format. This record serves as the gate artifact that the orchestrator validates before allowing phase advancement.

```json
{
  "phase": 1,
  "phaseName": "HLD Intake and Validation",
  "completedAt": "ISO-8601 timestamp",
  "ownerSkill": "tdd-ddd-analyst",
  "exitCriteriaResults": [
    {
      "criterion": "description",
      "status": "PASS|FAIL",
      "evidence": "artifact path or description"
    }
  ],
  "outputArtifacts": ["path1", "path2"],
  "notes": "any relevant observations"
}
```

**Rules**:
- Every exit criterion must have a `PASS` status for the phase to be considered complete
- If any criterion has `FAIL` status, the phase remains active and the orchestrator determines remediation
- The `evidence` field must point to a concrete artifact or provide a verifiable description
- The `outputArtifacts` array must list all artifacts produced during the phase
- The orchestrator appends the completion record to the audit log upon acceptance
