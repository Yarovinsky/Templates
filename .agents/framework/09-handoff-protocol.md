# 09 — Handoff Protocol

## Overview

This document defines the structured message format and validation rules for all skill-to-skill transitions. ALL handoffs are mediated by the orchestrator — no direct skill-to-skill communication is permitted.

### Dispatch Mechanism: Subtasks (`new_task`)

The orchestrator MUST dispatch to skill modes using the **`new_task` tool** (subtasks), NOT the `switch_mode` tool. This ensures:
- Each skill runs in an isolated subtask context
- The orchestrator retains control and receives the completion result
- Auto-approved subtask creation enables seamless workflow without manual approval prompts
- The handoff message JSON is passed as the `message` parameter of `new_task`

**Usage pattern**:
```
new_task(
  mode: "<target skill mode slug>",
  message: "<structured handoff JSON from the format below>"
)
```

When a skill completes, it uses `attempt_completion` to signal back. The orchestrator receives the result and proceeds with post-completion validation.

---

## Handoff Message Format

Every handoff MUST use this structured format:

```json
{
  "handoffId": "HO-NNN-timestamp",
  "type": "DISPATCH | COMPLETION | REJECTION | ESCALATION",
  "from": {
    "skill": "originating skill slug",
    "phase": "current phase number",
    "mode": "originating Roo mode slug"
  },
  "to": {
    "skill": "target skill slug",
    "phase": "target phase number",
    "mode": "target Roo mode slug"
  },
  "artifacts": [
    {
      "name": "artifact name",
      "path": "relative file path",
      "type": "MARKDOWN | JSON | SOURCE_CODE | TEST_CODE | REPORT",
      "status": "CREATED | MODIFIED | VALIDATED"
    }
  ],
  "traceability": ["HLD-REQ-NNN tags covered by this handoff"],
  "preconditions": [
    {
      "condition": "description of what must be true",
      "status": "MET | NOT_MET",
      "evidence": "path or description proving the condition"
    }
  ],
  "storyScope": {
    "storyId": "STORY-NNN (required when storyLoop is active, omitted otherwise)",
    "storyTitle": "string",
    "storyFilePath": "docs/stories/STORY-NNN-title.json",
    "boundedContext": "PascalCase bounded context name",
    "targetAggregates": ["PascalCase aggregate names"],
    "targetDddArtifacts": ["relative paths to DDD spec documents"],
    "acceptanceCriteria": ["AC-NNN IDs from the story"]
  },
  "summary": "Human-readable summary of what was accomplished and what the target skill should do next",
  "blockers": ["any known blockers for the target skill"]
}
```

> **`storyScope` field**: This field is **required** when the orchestrator's story iteration loop is active (i.e., `storyLoop.active = true` in `phase-state.json`). It scopes Phases 4–7 to the current story. It is **omitted** during Phases 1–3, Phase 3.5, and the final full-product validation. See `11-story-decomposition.md` Section 8 for the complete specification.

---

## Handoff Types

### DISPATCH (Orchestrator → Skill via `new_task`)

- Orchestrator sends when activating a skill for a phase, using the `new_task` tool with the target skill's mode slug and the handoff JSON as the message.
- MUST include: all input artifacts the skill needs, phase number, traceability tags for scope, preconditions that have been validated.
- Skill MUST verify all preconditions before accepting work.

### COMPLETION (Skill → Orchestrator via `attempt_completion`)

- Skill sends when it has finished its assigned work, using `attempt_completion` to return the result to the orchestrator.
- MUST include: all output artifacts produced, traceability tags covered, summary of what was done.
- Orchestrator receives the subtask result and validates output artifacts against phase exit criteria.

### REJECTION (Skill → Orchestrator, or Orchestrator → Skill)

- Sent when preconditions are not met or output validation fails.
- MUST include: which preconditions/criteria failed, what is missing, suggested remediation.
- The originating side must address the deficiency before retry.

### ESCALATION (Skill → Orchestrator)

- Sent when a skill encounters work outside its scope.
- MUST include: description of out-of-scope work, suggested target skill, blocking artifacts.
- Orchestrator routes to appropriate skill.

---

## Handoff Validation Rules

### Pre-dispatch validation (Orchestrator performs before DISPATCH)

- Current phase state is valid.
- All input artifacts exist at their expected paths.
- Previous phase completion record exists and shows PASS.
- No unresolved clarification requests blocking the target scope.

### Pre-acceptance validation (Target skill performs after receiving DISPATCH)

- All listed artifacts are readable.
- Artifact contents match expected format.
- Traceability tags are resolvable to HLD requirements.
- If any check fails: send REJECTION back to orchestrator.

### Post-completion validation (Orchestrator performs after receiving COMPLETION)

- All expected output artifacts exist.
- Phase exit criteria are met.
- No regressions in previously validated artifacts.
- If any check fails: send REJECTION back to skill with deficiency list.

---

## Handoff Flow Sequence

```
Orchestrator                          Skill (subtask)
    |                                   |
    |--- new_task(mode, handoff JSON) -->|  [subtask created]
    |                                   |-- validates preconditions
    |                                   |-- [if invalid] attempt_completion(REJECTION) -->|
    |<-- subtask result (REJECTION) ----|
    |    [address deficiencies]          |
    |--- new_task(mode, retry JSON) --->|  [new subtask]
    |                                   |-- [if valid] accepts work
    |                                   |-- performs skill activities
    |                                   |-- [if out-of-scope] attempt_completion(ESCALATION) -->|
    |<-- subtask result (ESCALATION) ---|
    |    [routes to correct skill]       |
    |                                   |-- completes work
    |                                   |-- attempt_completion(COMPLETION JSON)
    |<-- subtask result (COMPLETION) ---|
    |-- validates outputs                |
    |-- [if invalid] new_task(mode, REJECTION JSON) -->|
    |                                   |-- addresses deficiencies
    |<-- subtask result (COMPLETION) ---|
    |-- [if valid] advances phase        |
    |--- new_task(next mode, JSON) ---->|  [next subtask]
```

---

## Handoff Log Integration

Every handoff message is logged to the audit log (`.agents/state/audit.jsonl`) with event type `SKILL_DISPATCH`, `SKILL_COMPLETION`, `HANDOFF_ACCEPTED`, or `HANDOFF_REJECTED`.
