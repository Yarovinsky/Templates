# 08 — Failure Handling, Recovery, and Audit

## Overview

This document defines rules for runtime failures, recovery procedures, and the immutable audit log. All failure modes have explicit, deterministic recovery paths. The orchestrator is responsible for routing failures per these rules.

---

## Failure Mode 1: Insufficient Domain Knowledge

- **Trigger**: A test cannot be written or implementation cannot proceed because the DDD model lacks information derivable only from the HLD.
- **Detection**: Test Author or Implementer skill signals inability to proceed with specific missing information.
- **Recovery Procedure**:
  1. HALT current work immediately.
  2. Trace the knowledge gap back to the specific HLD section and requirement ID.
  3. Emit a structured clarification request:
     ```
     ## Clarification Required — Insufficient Domain Knowledge
     
     **Phase**: [current phase]
     **Skill**: [current skill]
     **Blocked Artifact**: [artifact being worked on]
     **Missing Information**: [specific description]
     **Traced To**: [HLD-REQ-NNN] in section [section name]
     **Question**: [specific question to resolve the gap]
     
     **Action Required**: Customer must provide clarification before work can continue.
     ```
  4. Orchestrator aggregates this with any other pending clarifications.
  5. No progress on the affected domain until clarification received.
- **Audit Log Entry**: `FAILURE:INSUFFICIENT_DOMAIN_KNOWLEDGE`

---

## Failure Mode 2: Green Phase Breaks Prior Tests

- **Trigger**: New production code written to pass a failing test causes one or more previously passing tests to fail.
- **Detection**: Implementer runs full test suite after GREEN and detects regressions.
- **Recovery Procedure**:
  1. REVERT all changes from the current green attempt to the last stable state (last known all-GREEN commit).
  2. Log the regression with: failing test names, suspected cause, the code change that triggered it.
  3. Re-enter RED phase for the current test.
  4. Analyze the regression: if the new test's expected behavior conflicts with existing behavior, escalate to DDD Architect for invariant reconciliation.
  5. If invariant conflict confirmed, create an ADR documenting the resolution.
- **Audit Log Entry**: `FAILURE:GREEN_BROKE_PRIOR_TESTS`

---

## Failure Mode 3: Refactoring Breaks Tests

- **Trigger**: A refactoring change causes one or more tests to fail.
- **Detection**: Refactorer runs test suite after each refactoring step and detects failure.
- **Recovery Procedure**:
  1. UNDO the refactoring change immediately (revert to pre-refactoring state).
  2. Log it as a "risky refactoring" with: refactoring description, tests that broke, suspected coupling.
  3. Decompose the refactoring into smaller, safer steps.
  4. Attempt each smaller step individually, verifying GREEN after each.
  5. If repeated failures occur, escalate to orchestrator for potential re-evaluation of the refactoring goal.
- **Audit Log Entry**: `FAILURE:REFACTORING_BROKE_TESTS`

---

## Failure Mode 4: Quality Gate Failure

- **Trigger**: One or more quality gates (QG-01 through QG-05) fail during Phase 7 validation.
- **Detection**: Validator skill evaluates quality gates and one or more return FAIL.
- **Recovery Procedure**:
  1. Enumerate EVERY failing criterion with specific details:
     ```
     ## Quality Gate Failure Report
     
     | Gate | Status | Details |
     |------|--------|---------|
     | QG-01 | PASS/FAIL | [skipped tests without blocking IDs] |
     | QG-02 | PASS/FAIL | [current coverage: X%, required: Y%] |
     | QG-03 | PASS/FAIL | [mutation kill rate: X%, required: Y%] |
     | QG-04 | PASS/FAIL | [N failing tests listed] |
     | QG-05 | PASS/FAIL | [N orphaned requirements, M orphaned tests] |
     ```
  2. Orchestrator determines the appropriate phase to re-enter:
     - QG-01 (skipped tests) → Phase 4 (Test Specification) or resolve blocking issues
     - QG-02 (coverage gap) → Phase 4 (write more tests) then Phase 5 (implement)
     - QG-03 (mutation survival) → Phase 4 (strengthen tests)
     - QG-04 (failing tests) → Phase 5 (fix implementation) or Phase 4 (fix test if test is wrong)
     - QG-05 (orphans) → Phase 4 (add missing tests) or Phase 1 (remove orphaned requirements)
  3. After remediation, return to Phase 7 for re-validation.
- **Audit Log Entry**: `FAILURE:QUALITY_GATE_FAILED`

---

## Failure Mode 5: Build Failure

- **Trigger**: Code does not compile or build.
- **Detection**: Any skill attempting to build the project encounters errors.
- **Recovery Procedure**:
  1. Log the build error with full error output.
  2. If during Phase 5 (Implementation): Implementer fixes compilation errors as part of GREEN phase.
  3. If during Phase 6 (Refactoring): UNDO refactoring, treat as Failure Mode 3.
  4. If during Phase 7 (Validation): Route to Phase 5 or 6 depending on when the error was introduced.
- **Audit Log Entry**: `FAILURE:BUILD_FAILURE`

---

## Failure Mode 6: Handoff Precondition Failure

- **Trigger**: Orchestrator attempts to dispatch to a skill mode but preconditions are not met.
- **Detection**: Orchestrator's precondition validation check fails.
- **Recovery Procedure**:
  1. Log the precondition failure with: target skill, missing preconditions, artifact gaps.
  2. Route back to the skill responsible for producing the missing artifacts.
  3. Do NOT proceed to the target skill until all preconditions are satisfied.
- **Audit Log Entry**: `FAILURE:HANDOFF_PRECONDITION_FAILED`

---

## Failure Mode 7: Direct Command Execution (Script Constraint Violation)

- **Trigger**: Any skill executes a system command that is not one of the approved wrappers (`dotnet.cmd`, `docker.cmd`, `git.cmd`, `curl.cmd`, `repo.cmd`).
- **Detection**: Orchestrator or human reviewer identifies a raw command (e.g., `del`, `mkdir`, `dotnet`, `git`, `rm`, `type`, `dir`, `copy`, `move`) in terminal output instead of the corresponding approved `.cmd` wrapper.
- **Severity**: FATAL
- **Recovery Procedure**:
  1. HALT immediately.
  2. Log as DEVIATION with severity FATAL per audit log spec:
     ```
     ## FATAL: Script Constraint Violation
     
     **Timestamp**: [ISO-8601]
     **Attempted Command**: [the raw command that was executed]
     **Required Form**: [the correct approved .cmd wrapper equivalent]
     **Phase**: [current phase]
     **Skill**: [current skill]
     
     **Resolution**: Re-execute using the approved wrapper. If no wrapper exists,
     extend one per Section 5 of ROO_EXECUTION_RULES.md.
     ```
  3. Undo any side effects of the unauthorized command if possible (e.g., if a file was deleted, restore it; if a file was created outside the wrapper, remove it and re-create via wrapper).
  4. Re-execute the operation using the correct approved `.cmd` wrapper.
  5. If no wrapper exists for the needed operation, escalate to extend the wrapper per Section 5 of `ROO_EXECUTION_RULES.md`.
- **Audit Log Entry**: `FAILURE:SCRIPT_CONSTRAINT_VIOLATION`
- **Cross-Reference**: `.agents/ROO_EXECUTION_RULES.md` Section 0, `.agents/framework/10-script-constraint.md`

---

## Audit Log Specification

- **Path**: `.agents/state/audit.jsonl`
- **Format**: JSON Lines (one JSON object per line, newline-delimited).
- **Immutability**: Append-only. No entries may be modified or deleted. If a correction is needed, append a new entry referencing the corrected entry.
- **Entry Schema**:
  ```json
  {
    "timestamp": "2026-03-12T12:00:00.000Z",
    "eventType": "PHASE_TRANSITION | SKILL_DISPATCH | SKILL_COMPLETION | HANDOFF_ACCEPTED | HANDOFF_REJECTED | QUALITY_GATE_EVALUATION | TEST_RESULT | FAILURE | DEVIATION | CLARIFICATION_REQUEST | CLARIFICATION_RESPONSE",
    "phase": 1,
    "skill": "tdd-ddd-analyst",
    "details": {
      "description": "Human-readable description of the event",
      "artifacts": ["list of affected artifact paths"],
      "previousState": "description of state before event",
      "newState": "description of state after event"
    },
    "traceability": ["HLD-REQ-NNN tags if applicable"],
    "severity": "INFO | WARN | ERROR | FATAL"
  }
  ```
- **Mandatory Events** (must ALWAYS be logged):
  - Every phase transition (start, complete, re-enter)
  - Every skill dispatch and completion
  - Every handoff acceptance or rejection
  - Every test suite execution result (summary: total, passed, failed, skipped)
  - Every quality gate evaluation
  - Every failure and recovery action
  - Every deviation from standard process
  - Every clarification request and response

---

## Deviation Logging

Any deviation from the standard process defined in this framework MUST be logged with:

- **Deviation ID**: `DEV-NNN`
- **What was deviated from** (reference to framework section)
- **Why the deviation was necessary**
- **What was done instead**
- **Impact assessment**
- **Remediation plan** (if applicable)
