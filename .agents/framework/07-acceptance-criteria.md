# 07 — Acceptance Criteria and Definition of Done

> **Status**: Normative
> **Audience**: TDD-DDD Orchestrator, Validator, all skill modes
> **Purpose**: Define per-artifact acceptance criteria and the product-level Definition of Done

---

## 1. Per-Artifact Acceptance Criteria

### DDD Artifacts

Applies to: domains, bounded contexts, aggregates, entities, value objects, events, repositories, services.

- MUST have at least one `[HLD-REQ-NNN]` traceability tag
- MUST use names from the ubiquitous language glossary
- MUST have a complete specification document in the prescribed format

### Aggregates (additional)

- MUST have ALL stated invariants documented as numbered rules
- MUST have at least one test per invariant
- MUST specify the consistency boundary
- MUST list all commands handled and events emitted

### Value Objects (additional)

- MUST document immutability contract
- MUST document equality semantics
- MUST have property-based tests where applicable

### Bounded Context Interfaces

- MUST have a contract test
- MUST specify the integration pattern (ACL, shared kernel, etc.)
- MUST document data flow direction

### Tests

- MUST assert a single logical behavior per test method
- MUST have `[HLD-REQ-NNN]` traceability (via comment or attribute)
- MUST follow `should_ExpectedBehavior_When_Condition` naming
- MUST be independent — no test may depend on another test's state
- MUST be deterministic — same input always produces same result

### Application Workflows

- MUST have an end-to-end acceptance test
- MUST map 1:1 to an HLD feature narrative `[HLD-FN-NNN]`
- MUST document transaction boundaries

### Production Code

- MUST have a corresponding failing test that motivated its creation
- MUST not contain speculative code (code not required by any test)
- MUST align with ubiquitous language naming

### Stories

Applies to: individual story files produced in Phase 3.5.

- MUST be scoped to a single bounded context
- MUST reference at least one DDD artifact with a valid `specPath`
- MUST have at least one testable acceptance criterion (`testable: true`)
- MUST have at least one `[HLD-REQ-NNN]` traceability tag
- MUST include an MVP justification explaining why the story is in scope
- MUST have a valid `complexity` value (`XS`, `S`, `M`, `L`, or `XL`)
- MUST have a `userStory` in "As a [persona], I want [capability] so that [benefit]" format
- MUST NOT depend on a story with a higher sequence number
- MUST use ubiquitous language terms from the glossary in the title and user story

### Per-Story Definition of Done

All of the following MUST be true for a single story to be marked `completed`:

- [ ] Phase 4 complete: All acceptance criteria have corresponding failing tests
- [ ] Phase 5 complete: All story tests pass (GREEN state)
- [ ] Phase 6 complete: Refactoring checklist applied, all tests still pass
- [ ] Phase 7 complete: Story-scoped quality gates pass (QG-01 through QG-05)
- [ ] All previously passing tests (from prior stories) continue to pass — no regressions
- [ ] Story status updated to `completed` in `docs/stories/backlog.json`
- [ ] Story `completedAt` timestamp set
- [ ] Story `phaseProgress` fields all set to `completed`

---

## 2. Definition of Done — Entire Product

All of the following MUST be true for the product to be considered complete:

- [ ] All 8 phases completed in prescribed order (Phase 1 → Phase 2 → Phase 3 → Phase 3.5 → Phase 4 → Phase 5 → Phase 6 → Phase 7)
- [ ] All quality gates passed (QG-01 through QG-05):
  - [ ] QG-01: No skipped/pending tests without blocking-issue ID
  - [ ] QG-02: Code coverage ≥ threshold (default 90%) on domain/application layers
  - [ ] QG-03: Mutation kill rate ≥ 85% on aggregate invariant tests
  - [ ] QG-04: Zero failing tests across all layers
  - [ ] QG-05: Complete traceability — no orphaned requirements or tests
- [ ] Traceability matrix complete and validated:
  - Every `[HLD-REQ-NNN]` has at least one test
  - Every test traces to at least one `[HLD-REQ-NNN]`
- [ ] Ubiquitous language glossary reviewed and finalized
- [ ] All Architecture Decision Records (ADRs) complete and documenting every DDD-to-technical compromise
- [ ] Technical debt register complete with prioritized remediation plan:
  - Each item has severity (critical/high/medium/low)
  - Each item has estimated effort
  - Each item traces to a CONFLICT-NNN if applicable
  - Items are prioritized by business impact
- [ ] Audit log complete with no gaps in phase transitions
- [ ] All documentation artifacts exist at prescribed paths
- [ ] Deliverable artifacts are buildable and deployable

---

## 3. Partial Completion Tracking

The orchestrator maintains a Definition of Done checklist in `.agents/state/definition-of-done.json`. This file is updated as each criterion is evaluated during Phase 7 (Validation and Delivery) and may be partially populated during earlier phases.

```json
{
  "items": [
    {
      "id": "DOD-01",
      "description": "All 8 phases completed in order, including Phase 3.5",
      "status": "PASS|FAIL|PENDING",
      "evidence": "path to proof or description",
      "evaluatedAt": "ISO-8601 timestamp"
    },
    {
      "id": "DOD-02",
      "description": "QG-01: No skipped/pending tests without blocking-issue ID",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-03",
      "description": "QG-02: Code coverage ≥ 90% on domain/application layers",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-04",
      "description": "QG-03: Mutation kill rate ≥ 85% on aggregate invariant tests",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-05",
      "description": "QG-04: Zero failing tests across all layers",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-06",
      "description": "QG-05: Complete traceability — no orphaned requirements or tests",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-07",
      "description": "Traceability matrix complete and validated",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-08",
      "description": "Ubiquitous language glossary reviewed and finalized",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-09",
      "description": "All ADRs complete",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-10",
      "description": "Technical debt register complete with prioritized remediation plan",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-11",
      "description": "Audit log complete with no gaps",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-12",
      "description": "All documentation artifacts exist at prescribed paths",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    },
    {
      "id": "DOD-13",
      "description": "Deliverable artifacts are buildable and deployable",
      "status": "PENDING",
      "evidence": "",
      "evaluatedAt": ""
    }
  ]
}
```

**Rules**:
- The `status` field must be one of: `PASS`, `FAIL`, or `PENDING`
- `PENDING` items have not yet been evaluated
- `FAIL` items must be addressed before the product can be delivered
- The `evidence` field must point to a concrete artifact or provide a verifiable description
- The `evaluatedAt` field uses ISO-8601 timestamps
- The orchestrator updates this file as criteria are evaluated
- The Validator skill populates most items during Phase 7
