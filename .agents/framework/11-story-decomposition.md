# 11 — Story Decomposition

> **Framework Document**: 11 of 11
> **Authority**: [00-overview.md](00-overview.md)
> **Phase Association**: Phase 4 — Story Decomposition

---

## 1. Purpose

This document defines the **Story Planner** skill and the **Phase 4: Story Decomposition** process. After the DDD Architect completes tactical domain modeling (Phase 3), the Story Planner decomposes the validated DDD architecture into an **ordered backlog of MVP-scoped, implementation-ready user stories**. Each story then drives a complete TDD red-green-refactor cycle through Phases 5–8, executed iteratively — one story at a time.

### Pipeline Position

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → [Phase 4 → Phase 5 → Phase 6 → Phase 7] × N stories
```

Phase 4 transforms the DDD model (a static architecture) into an **executable plan** (an ordered sequence of implementation units). This bridges the gap between "what to build" (DDD model) and "in what order to build it" (story backlog).

---

## 2. Skill: Story Planner

**Mode Slug**: `tdd-ddd-story-planner`
**Mode Name**: 📋 TDD-DDD Story Planner
**Skill Number**: 8

### 2.1 Responsibilities

1. **DDD Model Analysis** — Read and interpret all DDD artifacts from Phases 2–3 (domains, bounded contexts, aggregates, entities, value objects, events, repositories, domain services, application services)
2. **HLD Cross-Reference** — Map DDD artifacts back to HLD requirements, feature narratives, and business goals via `[HLD-REQ-NNN]` traceability tags
3. **MVP Scope Determination** — Apply MVP scoping principles to identify the minimum set of stories that deliver core business value
4. **Story Decomposition** — Break the DDD model into implementation-ready stories, each scoped to a cohesive set of DDD artifacts within a single bounded context
5. **Acceptance Criteria Generation** — Derive testable acceptance criteria from DDD invariants, value object validation rules, entity lifecycle states, and HLD requirements
6. **Execution Order Determination** — Determine the optimal strict sequential execution order for the story backlog
7. **Backlog Construction** — Produce the ordered backlog manifest and individual story files
8. **Exclusion Documentation** — Explicitly document features excluded from MVP scope with rationale and HLD requirement references

### 2.2 Permitted Actions

- Read all project files (HLD, DDD specs, glossary, context maps, ADRs)
- Write JSON and Markdown files under `docs/stories/`
- Write Markdown documentation under `docs/`
- Update `.agents/state/` files (phase state, audit log)

### 2.3 Prohibited Actions

- Writing ANY source code or test code
- Modifying DDD specification documents (owned by DDD Architect)
- Modifying the validated HLD (owned by Analyst)
- Making implementation decisions (technology choices, framework selections)
- Skipping MVP justification for any included story
- Creating stories that span multiple bounded contexts (must be split)
- Reordering stories after the backlog is finalized

### 2.4 Input Artifacts

| Artifact | Path | From Phase |
|----------|------|------------|
| Validated HLD | `docs/hld/validated-hld.md` | Phase 1 |
| Glossary | `docs/glossary.md` | Phase 1 |
| Domain Model | `docs/ddd/domains.md` | Phase 2 |
| Bounded Contexts | `docs/ddd/bounded-contexts.md` | Phase 2 |
| Context Map | `docs/ddd/context-map.md` | Phase 2 |
| Aggregate Specs | `docs/ddd/aggregates/*.md` | Phase 3 |
| Entity Specs | `docs/ddd/entities/*.md` | Phase 3 |
| Value Object Specs | `docs/ddd/value-objects/*.md` | Phase 3 |
| Event Schemas | `docs/ddd/events/*.md` | Phase 3 |
| Repository Contracts | `docs/ddd/repositories/*.md` | Phase 3 |
| Domain Service Specs | `docs/ddd/domain-services/*.md` | Phase 3 |
| Application Service Workflows | `docs/ddd/application-services/*.md` | Phase 3 |
| ADRs | `docs/adr/*.md` | Phase 3 |

### 2.5 Output Artifacts

| Artifact | Path | Format |
|----------|------|--------|
| Backlog Manifest | `docs/stories/backlog.json` | JSON |
| Individual Story Files | `docs/stories/STORY-NNN-title.json` | JSON |
| MVP Scope Document | `docs/stories/mvp-scope.md` | Markdown |
| Phase 4 Completion Record | `.agents/state/phase-4-complete.json` | JSON |

### 2.6 Preconditions for Activation

- Phase 3 must be complete with all exit criteria met
- Phase 3 completion record exists at `.agents/state/phase-3-complete.json` with all criteria PASS
- All DDD specifications must exist at their prescribed paths
- All DDD artifacts must have `[HLD-REQ-NNN]` traceability tags
- Ubiquitous language glossary must exist at `docs/glossary.md`

### 2.7 Exit Criteria

- All stories created with complete fields per the story schema (Section 4)
- Every `[HLD-REQ-NNN]` tag in the DDD model is covered by at least one story
- Every story has at least one testable acceptance criterion
- Backlog manifest created with correct story count and ordering
- MVP scope document produced with inclusion/exclusion rationale
- No stories span multiple bounded contexts
- All story `dependsOn` references are valid (reference existing story IDs)
- Sequential ordering respects dependency constraints (no story depends on a later-sequenced story)
- Phase 4 completion record created at `.agents/state/phase-4-complete.json`

---

## 3. Story Decomposition Algorithm

The Story Planner MUST follow this exact 7-step sequence. No step may be skipped or reordered.

### Step 1: Inventory DDD Artifacts

Read all DDD specifications and build a complete inventory:

```
For each bounded context:
  → List all aggregates with their invariants
  → For each aggregate:
    → List child entities with identity rules and lifecycle states
    → List value objects with validation rules and equality semantics
    → List domain events with schemas and causality chains
    → List the repository interface contract
  → List domain services with input/output contracts
  → List application services with workflow steps
```

Record the total count of each artifact type. This inventory drives all subsequent steps.

### Step 2: Map to HLD Requirements

Cross-reference every DDD artifact with its `[HLD-REQ-NNN]` traceability tags:

1. Build a requirement-to-artifact mapping: `{ [HLD-REQ-NNN]: [list of DDD artifacts] }`
2. Build an artifact-to-requirement mapping: `{ [artifact]: [list of HLD-REQ-NNN tags] }`
3. Verify no orphaned requirements exist (every `[HLD-REQ-NNN]` maps to at least one artifact)
4. If orphans found, HALT and escalate to the orchestrator — the DDD model is incomplete

### Step 3: Apply MVP Filter

For each HLD business goal (`[HLD-BG-NNN]`):

1. Read its MoSCoW priority from the validated HLD
2. Classify as `must` (MVP-essential) or `should`/`could` (post-MVP)
3. Trace `must` goals to their feature narratives (`[HLD-FN-NNN]`)
4. Trace those narratives to their DDD artifacts via `[HLD-REQ-NNN]` tags
5. Mark those DDD artifacts as **MVP-in-scope**
6. Apply transitive dependency inclusion: if an MVP-in-scope artifact depends on another artifact (e.g., a value object used by an aggregate, a domain service invoked by a workflow), that dependency is also MVP-in-scope

**MVP Inclusion Rules (in priority order):**

| Rule | Condition | Action |
|------|-----------|--------|
| R1 | Business goal priority = `must` | Goal and all its feature narratives → IN scope |
| R2 | Feature narrative serves an in-scope goal | All DDD artifacts implementing the narrative → IN scope |
| R3 | DDD artifact is depended upon by an in-scope artifact | Dependency → IN scope (transitive closure) |
| R4 | All other artifacts | → OUT of scope |

**Exclusion Documentation:**

For every OUT-of-scope feature, document:
- Feature/artifact name
- HLD requirement references
- Reason for exclusion
- Which business goal it serves (with priority)
- Suggested post-MVP phase

### Step 4: Group into Stories

Group MVP-in-scope DDD artifacts into stories following these **mandatory grouping rules**:

| Rule | Description |
|------|-------------|
| G1 | **One bounded context per story** — A story NEVER spans bounded contexts |
| G2 | **Aggregate cohesion** — An aggregate root, its child entities, its value objects, and its invariants belong together in one story |
| G3 | **Repository inclusion** — Each aggregate story includes its repository interface |
| G4 | **Event coupling** — Domain events emitted by an aggregate are included with the aggregate's story |
| G5 | **Service separation** — Domain services that coordinate multiple aggregates get their own story (with dependencies on the aggregate stories) |
| G6 | **Workflow separation** — Application service workflows get their own story (with dependencies on the aggregate and service stories they orchestrate) |

**Story Granularity Guidance:**

- A story should be implementable in a single TDD red-green-refactor sequence (potentially multiple cycles within)
- If an aggregate has more than 5 invariants, consider splitting into a "core aggregate" story and an "aggregate extensions" story
- Cross-bounded-context integration stories (ACLs, event consumers) should be separate from the bounded context's core stories

### Step 5: Determine Execution Order

Assign a strict sequential `sequenceNumber` (1-based) to each story using these priority rules, applied in order:

| Priority | Rule | Rationale |
|----------|------|-----------|
| P1 | **Shared value objects first** | Value objects used across aggregates must exist before aggregates |
| P2 | **Foundation aggregates before dependent aggregates** | Aggregates referenced by other aggregates (via ID) come first |
| P3 | **Aggregate stories before service stories in the same context** | Domain services depend on aggregates they coordinate |
| P4 | **Domain service stories before application service stories** | Workflows depend on services and aggregates |
| P5 | **Intra-context stories before cross-context stories** | Complete one bounded context before integrating with another |
| P6 | **Core bounded contexts before peripheral bounded contexts** | Contexts serving `must` goals directly come before contexts that support them |

The resulting order is **fixed** once the backlog is created. It does not change during execution.

### Step 6: Generate Acceptance Criteria

For each story, derive testable acceptance criteria from the DDD model:

| DDD Source | Acceptance Criterion Derivation |
|------------|-------------------------------|
| Aggregate invariant | Each invariant → one or more AC stating the rule must hold |
| Value object validation rule | Each validation rule → AC for valid and invalid construction |
| Entity lifecycle state transition | Each valid transition → AC; each invalid transition → AC |
| Domain event emission | Each event → AC stating when it is emitted and with what data |
| Repository contract method | Each query method → AC for found/not-found behavior |
| Domain service contract | Input/output contracts → AC for success and failure cases |
| Application workflow step | Each step → AC for expected outcome |
| HLD feature narrative AC | Each HLD-level AC → mapped directly to story AC |

Each acceptance criterion MUST:
- Have a unique ID within the story (`AC-NNN`)
- Be stated as a testable boolean condition
- Be marked `testable: true` (or `testable: false` for NFRs that require runtime measurement)

### Step 7: Write Story Files and Backlog

1. Generate individual story JSON files per the schema in Section 4
2. Generate the backlog manifest per the schema in Section 5
3. Generate the MVP scope document per the template in Section 6
4. Create the Phase 4 completion record

**Validation before completion:**
- Every story file validates against the story schema
- Backlog story count matches the number of story files
- No story references a `dependsOn` story that does not exist
- No story depends on a story with a higher sequence number
- The union of all story traceability tags covers all MVP-in-scope `[HLD-REQ-NNN]` tags
- Every story has at least one acceptance criterion

---

## 4. Individual Story Schema

Each story is stored as a JSON file at `docs/stories/STORY-NNN-kebab-case-title.json`.

### Naming Convention

- `NNN`: Zero-padded to 3 digits, sequential starting at 001
- `kebab-case-title`: Derived from the story title, lowercase with hyphens, max 50 characters
- Example: `STORY-001-create-order-aggregate.json`

### Schema Definition

```json
{
  "$schema": "story-schema-v1",
  "storyId": "STORY-NNN",
  "sequenceNumber": 1,
  "title": "string — concise descriptive title",
  "userStory": "As a [persona], I want [capability] so that [benefit]",
  "boundedContext": "PascalCase bounded context name",
  "aggregates": ["PascalCase aggregate names targeted by this story"],
  "dddArtifacts": [
    {
      "type": "aggregate | entity | value-object | event | repository | domain-service | application-service",
      "name": "PascalCase artifact name",
      "specPath": "relative path to DDD specification document"
    }
  ],
  "acceptanceCriteria": [
    {
      "id": "AC-NNN",
      "criterion": "testable boolean condition statement",
      "testable": true
    }
  ],
  "traceability": {
    "hldRequirements": ["HLD-REQ-NNN"],
    "hldFeatureNarratives": ["HLD-FN-NNN"],
    "hldBusinessGoals": ["HLD-BG-NNN"]
  },
  "complexity": "XS | S | M | L | XL",
  "mvpJustification": "string — why this story is in the MVP scope",
  "dependsOn": ["STORY-NNN"],
  "status": "pending | in-progress | completed | blocked",
  "phaseProgress": {
    "phase4": "pending | in-progress | completed | failed",
    "phase5": "pending | in-progress | completed | failed",
    "phase6": "pending | in-progress | completed | failed",
    "phase7": "pending | in-progress | completed | failed"
  },
  "createdAt": "ISO-8601 timestamp",
  "completedAt": "ISO-8601 timestamp | null"
}
```

### Field Definitions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `$schema` | string | Yes | Always `"story-schema-v1"` |
| `storyId` | string | Yes | Unique identifier: `STORY-NNN` (zero-padded) |
| `sequenceNumber` | integer | Yes | Execution order position (1-based, unique, no gaps) |
| `title` | string | Yes | Concise descriptive title using ubiquitous language |
| `userStory` | string | Yes | Standard format: "As a [persona], I want [capability] so that [benefit]" — persona from HLD `[HLD-UP-NNN]` |
| `boundedContext` | string | Yes | PascalCase name of the single bounded context this story targets |
| `aggregates` | string[] | Yes | PascalCase names of aggregates this story implements or modifies (may be empty for service-only stories) |
| `dddArtifacts` | object[] | Yes | References to DDD specification documents this story implements |
| `acceptanceCriteria` | object[] | Yes | Numbered, testable acceptance criteria (minimum 1) |
| `traceability` | object | Yes | HLD requirement, feature narrative, and business goal tags |
| `complexity` | enum | Yes | Relative sizing: `XS`, `S`, `M`, `L`, `XL` |
| `mvpJustification` | string | Yes | Explanation of why this story is in the MVP scope |
| `dependsOn` | string[] | Yes | Story IDs this story depends on (empty array if no dependencies) |
| `status` | enum | Yes | Current status: `pending`, `in-progress`, `completed`, `blocked` |
| `phaseProgress` | object | Yes | Per-phase status within the story's TDD cycle |
| `createdAt` | string | Yes | ISO 8601 creation timestamp |
| `completedAt` | string/null | Yes | ISO 8601 completion timestamp; `null` until completed |

### Complexity Scale

| Level | Label | Scope Indicator |
|-------|-------|-----------------|
| `XS` | Extra Small | Single value object or simple entity with no invariants |
| `S` | Small | Single entity with 1–2 invariants, no cross-aggregate logic |
| `M` | Medium | Full aggregate with invariants, events, and repository |
| `L` | Large | Multiple aggregates within a bounded context, with domain service |
| `XL` | Extra Large | Cross-bounded-context integration, ACL, complex workflows |

---

## 5. Backlog Manifest Schema

The backlog manifest is stored at `docs/stories/backlog.json`.

```json
{
  "$schema": "backlog-schema-v1",
  "version": "1.1.0",
  "projectName": "string — derived from HLD",
  "createdAt": "ISO-8601 timestamp",
  "updatedAt": "ISO-8601 timestamp",
  "totalStories": 0,
  "completedStories": 0,
  "currentStoryId": null,
  "mvpScope": {
    "description": "string — summary of MVP scope rationale",
    "includedBoundedContexts": ["PascalCase bounded context names"],
    "excludedFeatures": [
      {
        "feature": "string — feature name",
        "reason": "string — why excluded from MVP",
        "hldRequirements": ["HLD-REQ-NNN"],
        "suggestedPhase": "string — suggested post-MVP implementation phase"
      }
    ]
  },
  "stories": [
    {
      "storyId": "STORY-NNN",
      "sequenceNumber": 1,
      "title": "string",
      "boundedContext": "PascalCase",
      "complexity": "XS | S | M | L | XL",
      "status": "pending | in-progress | completed | blocked",
      "filePath": "docs/stories/STORY-NNN-title.json"
    }
  ]
}
```

### Backlog Update Rules

- The orchestrator updates `updatedAt`, `completedStories`, `currentStoryId`, and individual story `status` fields as stories progress through the TDD cycle
- Story entries in the backlog are never removed or reordered
- The `stories` array is always sorted by `sequenceNumber`

---

## 6. MVP Scope Document Template

The MVP scope document is stored at `docs/stories/mvp-scope.md`:

```markdown
# MVP Scope — [Project Name]

> **Generated**: [ISO-8601 timestamp]
> **Phase**: 4 — Story Decomposition
> **Story Count**: [N] stories
> **Estimated Complexity**: [sum of complexity points]

---

## 1. MVP Definition

[One-paragraph summary of what the MVP delivers and why this scope was chosen]

## 2. Included Business Goals

| Goal ID | Description | Priority | Feature Narratives |
|---------|-------------|----------|--------------------|
| [HLD-BG-NNN] | [description] | must | [HLD-FN-NNN, ...] |

## 3. Included Bounded Contexts

| Bounded Context | Domain | Stories | Aggregate Count |
|----------------|--------|---------|-----------------|
| [Name] | [Domain] | STORY-001, STORY-002 | [N] |

## 4. Story Summary

| # | Story ID | Title | Bounded Context | Complexity | Dependencies |
|---|----------|-------|----------------|------------|--------------|
| 1 | STORY-001 | [title] | [context] | M | — |
| 2 | STORY-002 | [title] | [context] | S | STORY-001 |

## 5. Excluded Features

| Feature | Reason | HLD Requirements | Suggested Phase |
|---------|--------|-------------------|-----------------|
| [name] | [reason] | [HLD-REQ-NNN] | Post-MVP Phase 1 |

## 6. Traceability Coverage

- Total HLD requirements: [N]
- MVP-covered requirements: [M]
- Excluded requirements: [N - M]
- Coverage percentage: [M/N × 100]%
```

---

## 7. Story-Scoped Iteration Loop

After Phase 4 completes, the orchestrator enters a **story iteration loop** that executes Phases 5–8 for each story in backlog order.

### 7.1 Loop Procedure

```
1. Read docs/stories/backlog.json
2. Set storyLoop.active = true in phase-state.json
3. For sequenceNumber = 1 to totalStories:
   a. Load the story file for the current sequenceNumber
   b. Set currentStoryId in phase-state.json and backlog.json
   c. Update story status to "in-progress"
   d. Dispatch Phase 4 (Test Author) with story scope via storyScope handoff field
   e. Validate Phase 4 exit criteria for this story's acceptance criteria
   f. Dispatch Phase 5 (Implementer) with story scope
   g. Validate Phase 5 exit criteria — all story tests pass
   h. Dispatch Phase 6 (Refactorer) with story scope
   i. Validate Phase 6 — all tests still pass, refactoring checklist applied
   j. Dispatch Phase 7 (Validator) with story scope
   k. If story quality gates pass:
      - Update story status to "completed"
      - Set story completedAt timestamp
      - Increment completedStories in backlog.json
      - Update story phaseProgress fields
      - **Git commit and push** — Stage all changes, commit with message `feat(STORY-NNN): <story title>`, and push to the remote (see Section 7.5)
      - **Pause check** — If `storyLoop.pauseAfterStory` is `true` in `phase-state.json`, HALT and present the customer with a summary of the completed story (story ID, title, commit hash, tests passed). Wait for explicit customer approval before proceeding to the next story. If `false`, proceed automatically to the next story.
   l. If story quality gates fail:
      - Route to appropriate phase per 08-failure-handling.md
      - Re-attempt from the routed phase for this story
4. After ALL stories complete:
   a. Dispatch Phase 8-Final (Validator) for full product validation
   b. Apply ALL quality gates (QG-01 through QG-05) across the entire codebase
   c. Validate the complete traceability matrix
5. Set storyLoop.active = false
```

### 7.2 Story-Scoped Quality Gates

During the per-story Phase 7, quality gates are applied with **story scope**:

| Gate | Story-Scoped Behavior |
|------|----------------------|
| QG-01 | No skipped tests within the story's test suite |
| QG-02 | Coverage threshold on the bounded context code this story touches |
| QG-03 | Mutation testing on aggregate invariant tests for this story's aggregates |
| QG-04 | All tests pass (both story tests AND all previously passing tests — no regressions) |
| QG-05 | Traceability complete for this story's `[HLD-REQ-NNN]` tags |

### 7.3 Regression Protection

When executing a story, the orchestrator MUST verify that **all previously passing tests continue to pass** after each story's implementation. This is critical because later stories may modify code in bounded contexts that earlier stories already tested.

If a regression is detected:
1. HALT the current story
2. Identify which prior story's tests broke
3. Route to Failure Mode 2 (Green Breaks Prior Tests) per `08-failure-handling.md`
4. The Implementer must fix the regression before proceeding

### 7.4 Phase State Extension

The orchestrator's phase-state.json gains a `storyLoop` section:

```json
{
  "currentPhase": "4",
  "currentSkill": "tdd-ddd-test-author",
  "currentStoryId": "STORY-003",
  "storyLoop": {
    "active": true,
    "backlogPath": "docs/stories/backlog.json",
    "totalStories": 12,
    "completedStories": 2,
    "currentStorySequence": 3,
    "pauseAfterStory": false
  },
  "phaseHistory": [],
  "pendingClarifications": [],
  "auditLogPath": ".agents/state/audit.jsonl",
  "artifactRegistry": {}
}
```

#### `pauseAfterStory` Field

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `pauseAfterStory` | boolean | `false` | When `true`, the orchestrator halts after each story's commit/push and waits for explicit customer approval before proceeding to the next story. When `false`, the orchestrator advances automatically. The customer may change this value at any time in `phase-state.json`; the orchestrator reads it before each story iteration. |

### 7.5 Git Commit and Push on Story Completion

After a story passes its per-story Phase 7 validation (all quality gates pass), the orchestrator MUST commit and push the story's work to version control. This ensures each completed story is a discrete, traceable checkpoint in the repository history.

#### Procedure

1. **Stage all changes**: Run `git.cmd add -A` to stage all modified, added, and deleted files
2. **Commit**: Run `git.cmd commit -m "feat(STORY-NNN): <story title>"` where `STORY-NNN` and `<story title>` are taken from the completed story file
3. **Push**: Run `git.cmd push` to push the commit to the remote

#### Commit Message Format

```
feat(STORY-NNN): <story title>
```

- `STORY-NNN` — the story ID (e.g., `STORY-003`)
- `<story title>` — the story's `title` field from the story JSON file

Examples:
- `feat(STORY-001): Create Order aggregate`
- `feat(STORY-005): Implement Pricing domain service`

#### Rules

| Rule | Description |
|------|-------------|
| GR-01 | Commit and push occurs **only** after the per-story Phase 7 quality gates pass — never on failure |
| GR-02 | All git operations MUST be invoked via `git.cmd` — direct `git` invocation is forbidden per `10-script-constraint.md` |
| GR-03 | If `git push` fails (e.g., network error), the orchestrator MUST retry once; if the retry also fails, log the failure to the audit log and continue to the next story — the commit is preserved locally |
| GR-04 | The commit includes **all** project files changed during the story's Phases 5–8 (tests, source, docs, state files) |
| GR-05 | The orchestrator appends a `STORY_COMMITTED` event to the audit log (`.agents/state/audit.jsonl`) with the story ID, commit hash (from git output), and timestamp |

#### Audit Log Event

```json
{
  "event": "STORY_COMMITTED",
  "timestamp": "ISO-8601",
  "storyId": "STORY-NNN",
  "commitMessage": "feat(STORY-NNN): <story title>",
  "pushStatus": "SUCCESS | FAILED_RETRIED_SUCCESS | FAILED_LOCAL_ONLY",
  "notes": "optional details"
}
```

#### Final Full-Product Commit

After the Phase 8-Final full-product validation passes (step 4 in the loop procedure), the orchestrator performs one additional commit and push:

```
feat: complete MVP — all stories delivered
```

This final commit captures any remaining state updates from the full-product validation.

---

## 8. Handoff Protocol Extension

### 8.1 Story Scope Field

During the story iteration loop, all handoff messages MUST include a `storyScope` field:

```json
{
  "storyScope": {
    "storyId": "STORY-NNN",
    "storyTitle": "string",
    "storyFilePath": "docs/stories/STORY-NNN-title.json",
    "boundedContext": "PascalCase",
    "targetAggregates": ["PascalCase"],
    "targetDddArtifacts": ["relative paths to DDD spec documents"],
    "acceptanceCriteria": ["AC-NNN IDs from the story"]
  }
}
```

This field is:
- **Required** when `storyLoop.active = true` in phase-state.json
- **Omitted** when not in the story loop (Phases 1–3, Phase 4, Phase 8-Final)

### 8.2 Story Planner Handoff Messages

**DISPATCH to Story Planner (Orchestrator → Story Planner):**

```json
{
  "handoffId": "HO-NNN-timestamp",
  "type": "DISPATCH",
  "from": { "skill": "tdd-ddd-orchestrator", "phase": "4", "mode": "tdd-ddd-orchestrator" },
  "to": { "skill": "tdd-ddd-story-planner", "phase": "4", "mode": "tdd-ddd-story-planner" },
  "artifacts": [
    { "name": "Validated HLD", "path": "docs/hld/validated-hld.md", "type": "MARKDOWN", "status": "VALIDATED" },
    { "name": "Glossary", "path": "docs/glossary.md", "type": "MARKDOWN", "status": "VALIDATED" },
    { "name": "Domain Model", "path": "docs/ddd/domains.md", "type": "MARKDOWN", "status": "VALIDATED" },
    { "name": "Bounded Contexts", "path": "docs/ddd/bounded-contexts.md", "type": "MARKDOWN", "status": "VALIDATED" },
    { "name": "Context Map", "path": "docs/ddd/context-map.md", "type": "MARKDOWN", "status": "VALIDATED" }
  ],
  "traceability": ["all HLD-REQ-NNN tags"],
  "preconditions": [
    { "condition": "Phase 3 complete", "status": "MET", "evidence": ".agents/state/phase-3-complete.json" },
    { "condition": "All DDD specs exist", "status": "MET", "evidence": "docs/ddd/" },
    { "condition": "All DDD artifacts have traceability tags", "status": "MET", "evidence": "Verified by orchestrator" }
  ],
  "summary": "Decompose the validated DDD architecture into MVP-scoped user stories. Apply the 7-step decomposition algorithm from 11-story-decomposition.md.",
  "blockers": []
}
```

**COMPLETION from Story Planner (Story Planner → Orchestrator):**

```json
{
  "handoffId": "HO-NNN-timestamp",
  "type": "COMPLETION",
  "from": { "skill": "tdd-ddd-story-planner", "phase": "4", "mode": "tdd-ddd-story-planner" },
  "to": { "skill": "tdd-ddd-orchestrator", "phase": "4", "mode": "tdd-ddd-orchestrator" },
  "artifacts": [
    { "name": "Backlog Manifest", "path": "docs/stories/backlog.json", "type": "JSON", "status": "CREATED" },
    { "name": "MVP Scope Document", "path": "docs/stories/mvp-scope.md", "type": "MARKDOWN", "status": "CREATED" }
  ],
  "traceability": ["all HLD-REQ-NNN tags covered by stories"],
  "preconditions": [],
  "summary": "Created N stories covering M HLD requirements. MVP scope includes X bounded contexts. Execution order determined. Ready for story-scoped TDD iteration.",
  "blockers": []
}
```

---

## 9. Phase 4 Completion Record

```json
{
  "phase": "4",
  "phaseName": "Story Decomposition",
  "completedAt": "ISO-8601 timestamp",
  "ownerSkill": "tdd-ddd-story-planner",
  "exitCriteriaResults": [
    {
      "criterion": "All stories have complete fields per schema",
      "status": "PASS",
      "evidence": "docs/stories/ — N story files validated"
    },
    {
      "criterion": "All HLD-REQ-NNN tags covered by at least one story",
      "status": "PASS",
      "evidence": "M requirements covered, 0 orphans"
    },
    {
      "criterion": "Every story has at least one testable acceptance criterion",
      "status": "PASS",
      "evidence": "Minimum AC count: 1, average: 4.2"
    },
    {
      "criterion": "Backlog manifest created with correct count and ordering",
      "status": "PASS",
      "evidence": "docs/stories/backlog.json — N stories, ordered 1–N"
    },
    {
      "criterion": "MVP scope document produced",
      "status": "PASS",
      "evidence": "docs/stories/mvp-scope.md"
    },
    {
      "criterion": "No stories span multiple bounded contexts",
      "status": "PASS",
      "evidence": "All stories checked — single BC per story"
    },
    {
      "criterion": "No story depends on a later-sequenced story",
      "status": "PASS",
      "evidence": "Dependency order validated"
    }
  ],
  "outputArtifacts": [
    "docs/stories/backlog.json",
    "docs/stories/mvp-scope.md",
    "docs/stories/STORY-001-*.json",
    "..."
  ],
  "notes": "N stories total, complexity distribution: XS=a, S=b, M=c, L=d, XL=e"
}
```

---

## 10. Escalation Rules

When the Story Planner encounters issues:

| Issue | Action |
|-------|--------|
| Orphaned HLD requirement (no DDD artifact maps to it) | ESCALATE to orchestrator → route to DDD Architect for Phase 3 rework |
| Ambiguous MVP scope (cannot determine if a feature is `must`) | ESCALATE to orchestrator → route to customer for clarification |
| Circular dependency between stories | HALT → merge the dependent stories or restructure grouping |
| DDD artifact lacks traceability tag | ESCALATE to orchestrator → route to DDD Architect to add tag |
| Aggregate too large to fit in a single story | Split aggregate into core + extensions using Step 4 guidance |

---

## 11. Cross-Reference

This document works in conjunction with:

- [01-hld-input-contract.md](01-hld-input-contract.md) — Defines HLD structure and requirement numbering that stories trace to
- [02-ddd-transformation.md](02-ddd-transformation.md) — Defines DDD artifacts that stories decompose
- [04-skill-definitions.md](04-skill-definitions.md) — Story Planner listed as Skill 8
- [05-phase-definitions.md](05-phase-definitions.md) — Phase 4 definition
- [07-acceptance-criteria.md](07-acceptance-criteria.md) — Story-level acceptance criteria and per-story Definition of Done
- [08-failure-handling.md](08-failure-handling.md) — Failure modes apply during story-scoped TDD cycles
- [09-handoff-protocol.md](09-handoff-protocol.md) — `storyScope` field in handoff messages

