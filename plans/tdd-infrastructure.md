# TDD Infrastructure — Architecture Document

## Overview

This repository is a **technology-agnostic TDD template** for use with [Roo Code](https://roocode.com) (VS Code extension). It defines a structured, agent-driven Test-Driven Development workflow enforced through custom Roo Code modes, rules, and story files.

The infrastructure turns the classic Red → Green → Refactor cycle into a **codified, repeatable process** that any project can adopt by filling in two configuration documents.

---

## System Components

### 1. Custom Modes (`.roomodes`)

Seven custom Roo Code modes form the agent team:

| Mode | Slug | Responsibility | Invoked By |
|------|------|----------------|------------|
| 🧾 TDD Spec | `tdd-spec` | Decomposes user stories into Given/When/Then test scenarios | Orchestrator |
| 🏗️ TDD Scaffold | `tdd-scaffold` | Creates empty source-file stubs on demand so tests can import them | `tdd-red` / `tdd-green` |
| 🔴 TDD Red | `tdd-red` | Writes failing tests (hybrid: run→confirm fail→skip→commit PENDING) | Orchestrator |
| 🟢 TDD Green | `tdd-green` | Writes minimum code to make skipped tests pass | Orchestrator |
| 🔵 TDD Refactor | `tdd-refactor` | Improves code quality one step at a time, commit per step | Orchestrator |
| 🔍 TDD Review | `tdd-review` | Validates story completion checklist before git tag | Orchestrator |
| 🔄 TDD Orchestrator | `tdd-orchestrator` | Coordinates the full cycle across all stories in the backlog | User |

Each mode has **restricted file access** enforced by Roo Code's `fileRegex` groups:

- `tdd-spec` → can only edit `stories/*.md`
- `tdd-scaffold` → can only create **new** source files (no test files, no story files, no infrastructure)
- `tdd-red` → can only edit test files (`*.test.*`, `*.spec.*`, etc.) and `stories/*.md`
- `tdd-green` → can edit source and test files (not infrastructure files)
- `tdd-refactor` → can edit source and test files (not infrastructure files)
- `tdd-review` → read-only except `stories/*.md` for status updates
- `tdd-orchestrator` → can run commands and edit `stories/*.md`

#### On-Demand Scaffold Pattern

`tdd-scaffold` is **not a mandatory pipeline phase**. It is a utility mode called via `new_task` by `tdd-red` (or `tdd-green`) whenever a test fails with a module-not-found / import resolution error — meaning the source file being tested does not yet exist.

```
tdd-red writes test
      │
      ▼
run test suite
      │
      ├─ fails with import error? ──► call tdd-scaffold (new_task)
      │                                  │
      │                               creates stub file
      │                               commits: scaffold: NNN — stub ClassName
      │                                  │
      │◄─────────────────────────────────┘
      │
      └─ fails for right reason? ──► add skip → commit PENDING
```

`tdd-scaffold` creates the stub, commits it with a `scaffold: NNN` prefix, and returns. `tdd-red` then re-runs the test and proceeds normally.

### 2. Global Rules (`.roo/rules/`)

Applied to all modes automatically by Roo Code:

| File | Purpose |
|------|---------|
| `01-tdd-principles.md` | The Three Laws of TDD, cycle definition, commit conventions, forbidden practices |
| `02-project-context.md` | Instructs every mode to read `docs/` and `stories/` before acting; context hierarchy |

### 3. Mode-Specific Rules (`.roo/rules-{slug}/`)

Each mode has its own rules directory loaded only when that mode is active:

| Directory | Key Rules |
|-----------|-----------|
| `.roo/rules-tdd-spec/` | Given/When/Then format, one behaviour per scenario, observable outcomes only |
| `.roo/rules-tdd-red/` | Hybrid Red procedure: write→run→confirm fail→skip→commit PENDING |
| `.roo/rules-tdd-green/` | Minimum code principle, no gold-plating, run full suite before commit |
| `.roo/rules-tdd-refactor/` | One refactor per commit, revert-on-fail, atomic commit rule |
| `.roo/rules-tdd-review/` | 6-section checklist, APPROVED/BLOCKED output format, no tag authority |
| `.roo/rules-tdd-orchestrator/` | Story selection logic, phase delegation, tag application, resume logic |

### 4. Project Context Documents (`docs/`)

Two documents every project must customise:

| File | Purpose |
|------|---------|
| `docs/product-definition.md` | Product name, personas, feature list, user stories, out-of-scope items |
| `docs/architecture-spec.md` | Tech stack, test runner command, directory structure, naming conventions, layer architecture |

These are read by every mode at task start to provide project-specific context.

### 5. Story Files (`stories/`)

The backlog — discrete TDD work units, one per feature or behaviour:

| File | Purpose |
|------|---------|
| `stories/README.md` | Backlog index with priority and phase status columns; orchestrator reads this first |
| `stories/000-story-template.md` | Canonical template — copy this for every new story |
| `stories/NNN-*.md` | Individual story files with user story, acceptance criteria, scope, technical notes |

Each story progresses through status checkboxes:
```
- [ ] Spec written
- [ ] Red (tests written + confirmed failing + skipped)
- [ ] Green (tests passing)
- [ ] Refactor (code cleaned up)
- [ ] Committed & tagged
```

### 6. GitHub Integration (`.github/`)

| File | Purpose |
|------|---------|
| `.github/PULL_REQUEST_TEMPLATE.md` | PR checklist enforcing story reference, TDD phase completion, test health, and bookkeeping |

---

## Workflow

```
Developer creates story file
         │
         ▼
tdd-orchestrator reads stories/README.md
         │
         ▼
┌─────────────────────────────────────────┐
│           TDD Cycle per Story            │
│                                         │
│  tdd-spec   → commit: spec: NNN         │
│     │                                   │
│  tdd-red    → run test (no skip)        │
│             → confirm FAIL              │
│             → add skip                  │
│             → commit: test(red): PENDING│
│     │                                   │
│  tdd-green  → remove skip               │
│             → write min. code           │
│             → all tests pass            │
│             → commit: feat(green): NNN  │
│     │                                   │
│  tdd-refactor → one step at a time      │
│               → test after each step    │
│               → commit: refactor: ...   │
│     │                                   │
│  tdd-review → run checklist             │
│             → APPROVED or BLOCKED       │
│     │                                   │
│  orchestrator → git tag story/NNN       │
│              → update stories/README.md │
│              → commit: chore: cycle ✅  │
└─────────────────────────────────────────┘
         │
         ▼
   Next story in backlog
```

---

## Git Commit History Per Story

A completed story produces this commit sequence:

```
chore: story/001 — cycle complete ✅
refactor: simplify password validation with early return
refactor: extract PasswordValidator from RegisterService
chore: 001 — refactor phase complete
feat(green): 001 — implement user registration endpoint
test(red): 001 — register returns 409 for duplicate email — PENDING
test(red): 001 — register returns 201 for valid input — PENDING
spec: 001 — user registration scenarios
```

And a git tag: `story/001-user-registration`

---

## How to Use This Template

### Setting Up a New Project

1. **Fork or copy** this repository.
2. **Replace** `docs/product-definition.md` with your real product information.
3. **Replace** `docs/architecture-spec.md` with your actual tech stack and conventions.
4. **Delete** `stories/001-example-story.md`.
5. **Create your first story** by copying `stories/000-story-template.md` to `stories/001-your-feature.md` and filling it in.
6. **Update** `stories/README.md` with your story.
7. **Start** `tdd-orchestrator` in Roo Code and say: *"Start the TDD cycle."*

### Adding Stories Mid-Project

1. Copy `stories/000-story-template.md` to `stories/NNN-feature-name.md`.
2. Fill in all required sections.
3. Add a row to `stories/README.md`.
4. The orchestrator will pick it up automatically on next invocation.

### Using Individual Modes Standalone

You don't need the orchestrator. You can invoke any mode directly:

- Open Roo Code → switch to `🔴 TDD Red` → *"Write a failing test for the login endpoint returning 401 for wrong password."*
- Open Roo Code → switch to `🟢 TDD Green` → *"Make the failing test in `src/auth/login.test.ts` pass."*

---

## Design Decisions

### Why Hybrid Red (not pure failing commits)?

Committing a failing test breaks CI pipelines. The Hybrid approach:
1. Confirms the test genuinely fails locally (preserving TDD discipline).
2. Adds a skip marker before committing (keeping CI green).
3. The `PENDING` suffix in the commit message makes the intent explicit in git history.

### Why file restrictions per mode?

Roo Code's `fileRegex` group restriction prevents modes from doing things outside their role:
- `tdd-red` cannot accidentally write implementation code.
- `tdd-spec` cannot accidentally write test code.
- This makes accidental scope violations impossible, not just against the rules.

### Why a dedicated `tdd-review` mode?

The Review phase catches issues that slip through during fast-paced cycles:
- Missing test coverage for edge cases.
- Skipped tests never unskipped.
- Story bookkeeping not completed.
- It acts as a quality gate — the git tag is the reward for passing, not a default action.

### Why `stories/README.md` as the orchestrator index?

A single markdown table is:
- Human-readable and editable without tooling.
- Diff-friendly in git — each status change is a one-cell update.
- Easy for the orchestrator to parse by reading the file and finding rows where not all columns are ✅.

---

## File Structure Reference

```
.roomodes                                    Custom mode definitions
.roo/
  rules/
    01-tdd-principles.md                     Global TDD laws + commit conventions
    02-project-context.md                    Mandatory context reading instructions
  rules-tdd-spec/
    01-spec-rules.md
  rules-tdd-red/
    01-red-rules.md
  rules-tdd-green/
    01-green-rules.md
  rules-tdd-refactor/
    01-refactor-rules.md
  rules-tdd-review/
    01-review-rules.md
  rules-tdd-orchestrator/
    01-orchestrator-rules.md
docs/
  product-definition.md                      ← REPLACE with your product info
  architecture-spec.md                       ← REPLACE with your tech stack
stories/
  README.md                                  Backlog index (orchestrator entry point)
  000-story-template.md                      Copy this for each new story
  001-example-story.md                       Example story (delete when using as template)
.github/
  PULL_REQUEST_TEMPLATE.md                   PR checklist enforcing TDD compliance
plans/
  tdd-infrastructure.md                      This document
README.md                                    Project usage guide
```
