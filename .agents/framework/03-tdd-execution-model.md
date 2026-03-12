# 03 — TDD Execution Model

> **Framework Document**: 03 of 10  
> **Authority**: [00-overview.md](00-overview.md)  
> **Phase Association**: Phase 4 (Test Specification), Phase 5 (Implementation), Phase 6 (Refactoring)

---

## 1. Sole Development Cadence

The **red-green-refactor** cycle is the **ONLY** permitted development cadence in this framework. There are no exceptions.

### Inviolable Rules:

1. **No production code may exist without a prior failing test.** Every line of production code must have been written to make a specific, previously failing test pass.
2. **No test may be written without traceability to a DDD artifact and HLD requirement.** Every test must reference at least one `[HLD-REQ-NNN]` tag and correspond to a specific DDD artifact (aggregate invariant, entity behavior, value object validation, domain event, etc.).
3. **The cycle must not be short-circuited.** Writing production code before writing a test, or skipping the refactor phase, are framework violations logged in the audit trail.

### Cycle Diagram:

```
RED (failing test) → GREEN (minimum code) → REFACTOR (mandatory cleanup)
      ↑                                              |
      └──────────── next behavior ←──────────────────┘
```

---

## 2. RED Phase — Write Failing Test

**Executor**: Test Author mode (only)  
**Prohibited**: Implementer, Refactorer, and all other modes may NOT write tests

### Requirements:

1. **Before ANY implementation artifact is created**, produce a failing test that encodes expected behavior derived from the DDD model
2. The test MUST be **traceable** to an HLD requirement via an `[HLD-REQ-NNN]` tag in a comment, attribute, or test metadata
3. The test MUST reference the specific **DDD artifact** it validates (aggregate, entity, value object, domain service, etc.)
4. The test MUST **fail for the RIGHT reason**:
   - ✅ Correct: fails because the class/method does not exist yet (compilation error or `NotImplementedException`)
   - ✅ Correct: fails because the method returns a wrong/default value (assertion failure)
   - ❌ Incorrect: fails because of a syntax error in the test itself
   - ❌ Incorrect: fails because of a missing test dependency or configuration error
5. The test MUST validate **exactly one logical behavior** — no multi-assertion tests that verify unrelated behaviors

### Test Method Naming Convention:

All test methods MUST follow this pattern:

```
should_ExpectedBehavior_When_Condition
```

**Examples:**

```
should_RejectOrder_When_NoOrderLinesPresent
should_CalculateTotal_When_MultipleOrderLinesExist
should_EmitOrderPlaced_When_OrderIsSubmitted
should_BeEqual_When_AllPropertiesMatch          (value object)
should_TransitionToShipped_When_CurrentStateIsConfirmed
```

### Test Traceability Comment Format:

```
// Traces: [HLD-REQ-042] — Order must contain at least one line item
// DDD Artifact: Order aggregate, Invariant INV-002
```

---

## 3. GREEN Phase — Minimum Implementation

**Executor**: Implementer mode (only)  
**Prohibited**: Test Author, Refactorer, and all other modes may NOT write production code during GREEN

### Requirements:

1. Write the **MINIMUM** code necessary to make the failing test pass — nothing more
2. **NO speculative implementation** — do not add code for anticipated future tests
3. **NO additional public API** beyond what the current failing test requires
4. If the minimum implementation is a hardcoded return value, that is acceptable — a subsequent RED phase will force generalization
5. **All previously passing tests MUST still pass** after the GREEN implementation:
   - If a prior test breaks, this is a GREEN phase failure → see [08-failure-handling.md](08-failure-handling.md)
   - The Implementer MUST revert and re-analyze before proceeding

### GREEN Phase Completion Criteria:

- [ ] The previously failing test now passes
- [ ] All previously passing tests still pass
- [ ] No code was written beyond what the failing test required
- [ ] No new public API was introduced beyond what the test exercises

---

## 4. REFACTOR Phase — Mandatory Cleanup

**Executor**: Refactorer mode (only)  
**Prohibited**: Test Author and Implementer modes may NOT participate in refactoring

### Mandatory Nature:

Refactoring is **MANDATORY** after every GREEN phase. It is not optional, not "if time permits", and not "if the code looks messy." Every GREEN → REFACTOR transition must occur.

### Refactoring Checklist:

All items MUST be evaluated. Not all items will require action every cycle, but all must be reviewed:

- [ ] **Duplication removal** (DRY principle) — Extract shared logic into methods, classes, or value objects
- [ ] **Naming alignment with ubiquitous language** — All names (classes, methods, variables) match the glossary terms exactly
- [ ] **Aggregate boundary re-evaluation** — Is this code in the right aggregate? Should it be moved?
- [ ] **Single Responsibility Principle (SRP)** — Each class has one reason to change
- [ ] **Open/Closed Principle (OCP)** — Open for extension, closed for modification
- [ ] **Liskov Substitution Principle (LSP)** — Subtypes are substitutable for base types
- [ ] **Interface Segregation Principle (ISP)** — No client depends on methods it doesn't use
- [ ] **Dependency Inversion Principle (DIP)** — Depend on abstractions, not concretions

### Post-Refactoring Validation:

1. **All tests MUST still pass** after refactoring
2. If ANY test fails during refactoring:
   - **UNDO immediately** — revert all refactoring changes
   - Log the failure as a risky refactoring attempt
   - Decompose the intended refactoring into smaller, safer steps
   - Re-attempt each smaller step with test validation between steps
3. No test expectations may be modified during refactoring — the Refactorer mode cannot change test assertions

### Refactoring Scope:

- ✅ Rename classes, methods, and variables to align with ubiquitous language
- ✅ Extract methods, classes, or value objects to reduce duplication
- ✅ Reorganize internal implementation structure
- ✅ Simplify conditional logic
- ✅ Introduce design patterns where they reduce complexity
- ❌ Add new public API
- ❌ Change externally observable behavior
- ❌ Modify test assertions or expectations
- ❌ Add new functionality (this requires a new RED phase)

---

## 5. Test Layer Granularity

Tests are organized into 5 layers, each with a defined scope, purpose, and ownership. All layers follow the same RED-GREEN-REFACTOR cycle.

### Layer 1: Unit Tests

| Property          | Specification                                                    |
|-------------------|------------------------------------------------------------------|
| **Scope**         | Individual entities, value objects, aggregates, domain services   |
| **Purpose**       | Enforce invariants, validate business rules, verify domain logic  |
| **Characteristics** | No I/O, no external dependencies, fast execution, deterministic |
| **Isolation**     | All dependencies mocked or stubbed                               |
| **Coverage Target** | ≥ 90% on domain layer (configurable via quality gate settings) |
| **Executor**      | Test Author mode (write), Validator mode (run)                   |

**What to test:**
- Aggregate invariants (every stated invariant gets at least one test)
- Entity state transitions (valid and invalid transitions)
- Value object construction validation (valid and invalid inputs)
- Value object equality semantics
- Domain service cross-aggregate logic
- Domain event emission on state changes

### Layer 2: Integration Tests

| Property          | Specification                                                    |
|-------------------|------------------------------------------------------------------|
| **Scope**         | Repository implementations, anticorruption layers, infrastructure adapters |
| **Purpose**       | Verify infrastructure correctly implements domain contracts       |
| **Characteristics** | May use test databases, message brokers, file systems          |
| **Isolation**     | Real infrastructure components in test configuration             |
| **Executor**      | Test Author mode (write), Validator mode (run)                   |

**Must verify:**
- Data round-trips correctly (save then load produces equivalent aggregate)
- ACL translations are accurate (upstream model → downstream model mapping)
- Adapter contracts are met (infrastructure implements repository interface faithfully)
- Connection/resource cleanup occurs properly

### Layer 3: Contract Tests

| Property          | Specification                                                    |
|-------------------|------------------------------------------------------------------|
| **Scope**         | Bounded context interfaces, inter-context communication          |
| **Purpose**       | Verify consumer expectations match provider capabilities         |
| **Characteristics** | Consumer-driven, version-aware                                |
| **Applicability** | Must exist for EVERY bounded context that exposes an API to another context |
| **Executor**      | Test Author mode (write), Validator mode (run)                   |

**Must verify:**
- Consumer's expected request format is accepted by provider
- Provider's response format matches consumer's expectations
- Error responses are handled correctly by consumer
- Contract versioning is compatible

### Layer 4: Acceptance Tests

| Property          | Specification                                                    |
|-------------------|------------------------------------------------------------------|
| **Scope**         | Application workflows / use cases (application services)         |
| **Purpose**       | Verify end-to-end behavior matching HLD use cases                |
| **Mapping**       | One acceptance test suite per HLD feature narrative `[HLD-FN-NNN]` |
| **Characteristics** | May use in-memory infrastructure, test against application service layer |
| **Executor**      | Test Author mode (write), Validator mode (run)                   |

**Must verify:**
- The full workflow from command to domain events produces expected outcomes
- All acceptance criteria from the HLD feature narrative are covered
- Error and edge cases specified in the HLD are handled

### Layer 5: Property-Based Tests

| Property          | Specification                                                    |
|-------------------|------------------------------------------------------------------|
| **Scope**         | Value objects, stateless domain logic                            |
| **Purpose**       | Verify that properties hold across random input distributions    |
| **Applicability** | Required when value objects have mathematical properties or domain logic is stateless and deterministic |
| **Executor**      | Test Author mode (write), Validator mode (run)                   |

**Applicable when:**
- Value objects have mathematical properties (commutativity, associativity, identity element)
- Domain logic is stateless and deterministic (same input always produces same output)
- Invariants should hold for ALL valid inputs, not just selected examples

**Framework selection** (technology-specific):

| Platform | Framework     |
|----------|---------------|
| .NET     | FsCheck       |
| Java     | jqwik         |
| Python   | Hypothesis    |
| JavaScript/TypeScript | fast-check |
| Kotlin   | kotest-property |

---

## 6. Quality Gates

Quality gates are mandatory checkpoints that MUST pass before any artifact or phase can be marked complete. Gate configurations are stored in [`.agents/state/quality-gates.json`](../state/quality-gates.json) with overridable thresholds.

### QG-01: No Skipped Tests

No test may be skipped, ignored, or marked pending without a linked blocking-issue identifier.

**Format**: `BLOCKED-BY: [ISSUE-NNN]`

```
// BLOCKED-BY: [ISSUE-042] — PaymentGateway sandbox not yet provisioned
[Skip("BLOCKED-BY: ISSUE-042")]
public void should_ProcessPayment_When_ValidCardProvided() { ... }
```

**Rules:**
- Every skipped test MUST have a `BLOCKED-BY` reference
- Skipped tests without a `BLOCKED-BY` reference are a quality gate violation
- The Orchestrator tracks all `BLOCKED-BY` references and includes them in progress reports

### QG-02: Code Coverage Threshold

Code coverage MUST meet or exceed the configurable threshold on domain and application layers.

| Layer            | Default Threshold | Gated? |
|------------------|-------------------|--------|
| Domain Layer     | 90%               | Yes    |
| Application Layer | 90%              | Yes    |
| Infrastructure Layer | Tracked       | No (tracked but not gated) |

**Rules:**
- Coverage is measured after ALL tests at ALL layers have run
- Only line/statement coverage is gated; branch coverage is tracked and reported
- The threshold is configurable in `quality-gates.json`
- Falling below the threshold blocks phase advancement

### QG-03: Mutation Testing

Mutation testing MUST be applied to **aggregate invariant tests**. This verifies that tests actually detect when business rules are violated.

| Property              | Specification                                   |
|-----------------------|-------------------------------------------------|
| **Scope**             | All tests covering aggregate invariants          |
| **Minimum Kill Rate** | 85%                                              |
| **Surviving Mutants** | Must be analyzed and either killed with new tests or documented as equivalent mutants |

**Equivalent Mutant Documentation:**
```
MUTANT-NNN: [mutation description]
Classification: Equivalent
Rationale: [why this mutation does not change observable behavior]
Reviewed-By: Validator mode
```

### QG-04: All Tests Pass

**ALL** tests at **ALL** layers MUST pass before any artifact is marked complete. There are no exceptions.

- Unit tests: all pass
- Integration tests: all pass
- Contract tests: all pass
- Acceptance tests: all pass
- Property-based tests: all pass

A single failing test at any layer blocks phase completion.

### QG-05: Test-to-Requirement Traceability

Traceability must be **complete** in both directions:

| Check                    | Description                                               |
|--------------------------|-----------------------------------------------------------|
| **No orphaned tests**    | Every test has at least one `[HLD-REQ-NNN]` traceability tag |
| **No orphaned requirements** | Every `[HLD-REQ-NNN]` requirement has at least one test |

**Traceability Matrix Format:**

```
| HLD Requirement | DDD Artifact | Test(s)                          | Status |
|-----------------|--------------|----------------------------------|--------|
| [HLD-REQ-001]   | Order.INV-001 | should_RejectOrder_When_Empty   | ✅ Pass |
| [HLD-REQ-002]   | Order.INV-002 | should_CalculateTotal_When_...  | ✅ Pass |
| [HLD-REQ-003]   | —             | —                                | ❌ No test |
```

- Requirements with no tests are reported as gaps
- Tests with no requirements are reported as orphans
- Both conditions block phase completion

### Quality Gate Configuration Schema:

Quality gate thresholds are stored in `.agents/state/quality-gates.json`:

```json
{
  "version": "1.0.0",
  "gates": {
    "QG-01": {
      "name": "No Skipped Tests",
      "enabled": true,
      "allowBlockedBy": true
    },
    "QG-02": {
      "name": "Code Coverage",
      "enabled": true,
      "thresholds": {
        "domainLayer": 90,
        "applicationLayer": 90,
        "infrastructureLayer": null
      },
      "metric": "line"
    },
    "QG-03": {
      "name": "Mutation Testing",
      "enabled": true,
      "minimumKillRate": 85,
      "scope": "aggregate-invariants"
    },
    "QG-04": {
      "name": "All Tests Pass",
      "enabled": true,
      "layers": ["unit", "integration", "contract", "acceptance", "property"]
    },
    "QG-05": {
      "name": "Traceability Completeness",
      "enabled": true,
      "noOrphanedTests": true,
      "noOrphanedRequirements": true
    }
  }
}
```
