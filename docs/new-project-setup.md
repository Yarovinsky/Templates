# New Project Setup — Instructions for Roo

> This file is read by Roo when a user says something like:
> *"Set up this template for my new project"* or *"Configure this repo for [product]"*
>
> Follow every step in order. Do not skip steps. Do not make assumptions — ask the user
> for any missing information before proceeding.

---

## Prerequisites

Before starting, confirm you have the following information from the user:

| # | Information Needed | Example |
|---|-------------------|---------|
| 1 | **Product name** | "ShipFast" |
| 2 | **One-sentence product description** | "A logistics tracking API for small couriers" |
| 3 | **Programming language** | Python, TypeScript, Go, Java, C# … |
| 4 | **Framework** | FastAPI, Express, Gin, Spring Boot … |
| 5 | **Test runner** | pytest, Vitest, Jest, go test, JUnit … |
| 6 | **Database / ORM** (if any) | PostgreSQL + SQLAlchemy, MongoDB + Mongoose … |
| 7 | **Package manager** | pip/poetry, pnpm/npm/yarn, go modules, Maven … |
| 8 | **First 3–5 user stories** (high level) | "User can register", "User can log in", "User can create a shipment" |

If any of these are missing, ask the user before touching any file.

---

## Step 1 — Replace `docs/product-definition.md`

**Action:** Overwrite the entire file with content specific to the new project.

**Required sections (keep all headings, replace all values):**

- `## Product Overview` — product name, tagline, problem statement, vision
- `## Target Users` — 2–4 personas with name and description
- `## Core Features (MVP)` — feature list with priorities (🔴 MVP / 🟡 MVP+ / 🟢 Post-MVP)
- `## User Stories (Backlog Seed)` — 4–8 high-level stories ("As a X, I want Y, so that Z")
- `## Out of Scope` — explicit list of things that must never be implemented without a new story
- `## Acceptance Criteria (Production-Ready)` — measurable conditions for "done"
- `## API Response Conventions` (or equivalent) — error/success response shapes

**Rules:**
- Every persona named here must be reused in story files.
- Every "Out of Scope" item here is a hard block — no mode may implement it.
- Be specific. Vague product definitions produce vague test scenarios.

---

## Step 2 — Replace `docs/architecture-spec.md`

**Action:** Overwrite the entire file with the real technology stack and conventions.

**Required sections (keep all headings, replace all values):**

### 2a — Technology Stack table
Fill in every row:

```
Language, Runtime, Framework, ORM/DB client, Database,
Test runner, Assertion library, HTTP test client, Mock library,
Linter, Formatter, Package manager
```

### 2b — How to Run the Test Suite
Provide the **exact shell commands** for:
- Run all tests
- Run tests in watch mode (if applicable)
- Run tests with coverage
- Run a single test file

> These commands are used verbatim by `tdd-red`, `tdd-green`, `tdd-refactor`, and `tdd-review`.
> If they are wrong, no mode can verify test results. Get these right.

### 2c — Project Directory Structure
Show the full intended directory tree including:
- Where source files live (e.g. `src/`, `app/`, `pkg/`)
- Where test files live (co-located or separate `tests/` directory)
- Where integration and e2e tests live
- Any infrastructure files (migrations, config, etc.)

### 2d — Test File Naming Conventions
One table per test type:
- Unit test pattern + example
- Integration test pattern + example
- End-to-end test pattern + example

### 2e — Skip Marker Syntax
The exact syntax to skip a test in the chosen test runner. Examples:

| Runner | Skip Syntax |
|--------|-------------|
| pytest | `@pytest.mark.skip(reason="Red phase — PENDING")` |
| Vitest/Jest | `test.skip('...', () => {})` |
| Go test | `t.Skip("Red phase — PENDING")` |
| JUnit 5 | `@Disabled("Red phase — PENDING")` |
| RSpec | `xit` / `xdescribe` |

### 2f — Layer Architecture
Describe the module/layer boundaries and rules (e.g. "services must not import from routes").

### 2g — Naming Conventions
Table of conventions for: files, classes, functions, constants, test files, test descriptions.

### 2h — Environment Setup
Step-by-step commands to install dependencies and get a working local environment.

### 2i — External Dependencies
Table of third-party services or libraries with their purpose and any required env vars.

---

## Step 3 — Update `stories/README.md`

**Action:** Replace the backlog table rows with the new project's stories.

**Keep:**
- The file header and "How to Add a Story" instructions
- The Status Key table
- The Completed Stories section at the bottom

**Replace:**
- All rows in the `## Backlog` table

**Format for each row:**
```markdown
| [NNN](NNN-short-title.md) | 🔴 N | Story Title | — | — | — | — | — | — |
```

**Rules:**
- Story 001 is always the first story the orchestrator will work on.
- Priorities follow the feature priority list in `docs/product-definition.md`.
- Only create story file links for stories that have a real file. Use `(000-story-template.md)` for stubs.

---

## Step 4 — Create Story File for Story 001

**Action:** Copy `stories/000-story-template.md` to `stories/001-<short-title>.md` and fill it in completely.

**Every section must be filled in — no placeholder text:**

- `## Status` — all checkboxes unchecked `[ ]`
- `## Metadata` — story number, priority, estimate (S/M/L/XL), dependencies
- `## User Story` — "As a [persona], I want [capability], so that [benefit]"
  - Persona must match one from `docs/product-definition.md`
- `## Acceptance Criteria` — 3–6 specific, testable criteria (unchecked `[ ]`)
- `## Scope — In Scope` — bullet list of exactly what this story covers
- `## Scope — Out of Scope` — bullet list of what is explicitly excluded (reference future stories where applicable)
- `## Technical Notes` — affected files, mocks needed, key types/interfaces, edge cases, error response formats
- `## Demonstrability` — **required before the Spec phase begins** — fill in:
  - The exact shell command(s) a human runs to see the feature working end-to-end
  - The expected observable output (status code, printed text, UI element)
  - Prerequisites checklist (service running, DB seeded, env vars set)
  - See [`stories/001-example-story.md`](../stories/001-example-story.md) for a filled-in example
- `## Test Scenarios` — leave the placeholder comment; `tdd-spec` will populate this
- `## Git Tag` — `story/NNN-short-title`

**Quality bar for Acceptance Criteria:**
Each criterion must be:
- Observable (can be asserted in a test)
- Specific (includes concrete values, status codes, or data shapes)
- Unambiguous (no "should work correctly" — say exactly what correct means)

---

## Step 5 — Create Story Files for Stories 002+ (Optional)

**Action:** Optionally create stub story files for stories 002 and beyond.

If creating stubs, copy `000-story-template.md` and fill in at minimum:
- `## Metadata`
- `## User Story`
- `## Acceptance Criteria`

The `tdd-spec` mode will complete the rest when the orchestrator reaches them.

**If not creating stubs:** leave the `stories/README.md` rows pointing to `000-story-template.md` — the orchestrator will prompt the user to create the story file before starting that story.

---

## Step 6 — Update `README.md`

**Action:** Replace the product name "TaskFlow" and its description with the new project name and description.

**Lines to update:**
- Title (line 1): `# <New Product Name>`
- Tagline (line 3): replace with new one-line description
- Story files section: update the example story file name/description

**Do not change:**
- The TDD Cycle table
- The Red Phase Strategy section
- The Modes Reference table
- The Git Conventions table
- The Customising This Template checklist

---

## Step 7 — Delete Unneeded Files

**Action:** Remove template example files that should not be in the new project.

| File | Action | Condition |
|------|--------|-----------|
| `stories/001-example-story.md` | **Delete** | Always — replace with your real story 001 |
| `training/` directory | **Delete** | If it exists and is not part of the new project |
| `plans/tdd-infrastructure.md` | **Keep** — it documents this infrastructure | — |
| `docs/new-project-setup.md` | **Keep or delete** — keep if the team wants it as reference | User's choice |

To delete:
```bash
# PowerShell
Remove-Item stories/001-example-story.md

# bash
rm stories/001-example-story.md
```

---

## Step 8 — Verify the Setup

Before starting the TDD cycle, do a final sanity check:

### 8a — Test the test command
Run the test suite command from `docs/architecture-spec.md`. It should:
- Execute without error
- Report 0 tests (or only pre-existing tests) with 0 failures

If it errors, fix the environment before proceeding.

### 8b — Check Roo context loading
Switch to `🔄 TDD Orchestrator` mode and say:
> "Read the project context and tell me what story you will start with."

Roo should respond with:
- The correct product name
- The correct tech stack
- Story 001's title and a summary of its acceptance criteria

If Roo describes TaskFlow or the wrong product, re-check that `docs/product-definition.md` was saved correctly.

### 8c — Confirm story 001 is ready for Spec
The orchestrator will only enter Spec phase if the story file:
- Exists at `stories/001-<slug>.md`
- Has `## User Story`, `## Acceptance Criteria`, and `## Scope` sections filled in
- Has `## Test Scenarios` as an empty placeholder

---

## Step 9 — Start the TDD Cycle

Switch to **🔄 TDD Orchestrator** mode and say:

> "Start the TDD cycle."

The orchestrator will:
1. Read `stories/README.md` to find story 001
2. Read the story 001 file
3. Delegate to `tdd-spec` to generate Given/When/Then scenarios
4. Proceed through Red → Green → Refactor → Review automatically

---

## Checklist Summary

```
[ ] docs/product-definition.md             — replaced with real product info
[ ] docs/architecture-spec.md              — replaced with real tech stack + test command
[ ] stories/README.md                      — backlog updated with real story titles
[ ] stories/001-*.md                       — story 001 file created and fully filled in
[ ] stories/001-*.md § Demonstrability     — run command + expected output filled in
[ ] README.md                              — product name/tagline updated
[ ] stories/001-example-story.md           — deleted (or replaced)
[ ] Test suite command verified            — runs without error locally
[ ] Demo command verified                  — observable output matches expected
[ ] Roo context check passed               — orchestrator describes correct product and story
```

---

## Common Mistakes to Avoid

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Leaving the test command as `pnpm test` when the project uses `pytest` | All modes will run wrong command, fail to verify tests | Update `docs/architecture-spec.md` Section 2b |
| Vague acceptance criteria ("should handle errors") | `tdd-spec` generates vague scenarios; `tdd-red` writes weak tests | Rewrite criteria with specific status codes, field names, and values |
| Not listing mocks in Technical Notes | `tdd-red` may try to hit real DB or external APIs | Add mock requirements to `## Technical Notes` in the story file |
| Forgetting "Out of Scope" section in product definition | Modes may implement unrequested features | Always fill in the Out of Scope list before starting |
| Starting TDD without a working local environment | Green phase cannot verify tests pass | Complete environment setup and run test suite before firing the orchestrator |
| Leaving `## Demonstrability` blank or with placeholder text | `tdd-review` will BLOCK and orchestrator will not tag | Fill in exact run command and expected output before starting the Spec phase |
| Demo command requires manual setup not documented in Prerequisites | Human cannot reproduce the demo; review fails | List every prerequisite (env vars, seed data, running services) in the checklist |
