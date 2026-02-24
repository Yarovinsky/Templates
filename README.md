# TaskFlow TDD Template

> A technology-agnostic TDD template for Roo Code — enforcing the Red → Green → Refactor cycle through custom AI modes, rules, and story-driven development.

---

## What Is This?

This repository is a **Roo Code TDD infrastructure template**. It provides:

- **6 custom AI modes** that each own one phase of the TDD cycle
- **Rules files** that enforce TDD discipline at the agent level
- **Story files** as discrete, trackable units of work
- **Git commit conventions** that make your history self-documenting
- **A PR template** that ensures nothing ships without completing the full cycle

Use it as a starting point for any new project. Replace the `docs/` files with your product and architecture, add your stories, and let the orchestrator drive.

---

## Quick Start

### 1. Set up your project context

Replace the template content in:

- [`docs/product-definition.md`](docs/product-definition.md) — your product name, users, features, and out-of-scope items
- [`docs/architecture-spec.md`](docs/architecture-spec.md) — your tech stack, test runner command, directory structure, and naming conventions

### 2. Create your first story

```bash
cp stories/000-story-template.md stories/001-your-feature.md
```

Fill in every section of the story file, then add a row to [`stories/README.md`](stories/README.md).

### 3. Start the TDD Orchestrator

In Roo Code, switch to the **🔄 TDD Orchestrator** mode and say:

> "Start the TDD cycle."

The orchestrator will read your backlog, pick the highest-priority incomplete story, and drive it through the full **Spec → Red → Green → Refactor → Review** cycle automatically.

---

## The TDD Cycle

```
Spec → Red → Green → Refactor → Review → Git Tag
```

| Phase | Mode | What Happens | Git Commit |
|-------|------|-------------|------------|
| **Spec** | 🧾 TDD Spec | User story → Given/When/Then scenarios | `spec: NNN — title` |
| **Red** | 🔴 TDD Red | Write test → confirm fail → skip | `test(red): NNN — description — PENDING` |
| **Green** | 🟢 TDD Green | Remove skip → minimum code → all pass | `feat(green): NNN — description` |
| **Refactor** | 🔵 TDD Refactor | One improvement → test → commit → repeat | `refactor: description` |
| **Review** | 🔍 TDD Review | Validate checklist → APPROVED or BLOCKED | — |
| **Tag** | 🔄 Orchestrator | Apply git tag, update backlog | `chore: story/NNN — cycle complete ✅` |

---

## Red Phase Strategy

This template uses the **Hybrid Red** approach:

1. Write the test **without** a skip marker.
2. Run it locally — confirm it **fails** for the right reason.
3. Add the skip marker (e.g. `test.skip`, `@pytest.mark.skip`).
4. Commit — CI stays green; the `PENDING` suffix in the commit message documents intent.

The Green phase removes the skip and writes the implementation.

---

## Story Files

All work is driven by story files in [`stories/`](stories/):

| File | Purpose |
|------|---------|
| [`stories/README.md`](stories/README.md) | Backlog index — priority-ordered table of all stories and their phase status |
| [`stories/000-story-template.md`](stories/000-story-template.md) | Template — copy this for every new story |
| [`stories/001-example-story.md`](stories/001-example-story.md) | Example story (TaskFlow user registration) — delete when using as a template |

Each story file contains: user story, acceptance criteria, scope boundaries, technical notes, and test scenarios (added by `tdd-spec`).

---

## Modes Reference

| Mode | Slug | Can Edit |
|------|------|---------|
| 🧾 TDD Spec | `tdd-spec` | `stories/*.md` only |
| 🔴 TDD Red | `tdd-red` | Test files + `stories/*.md` |
| 🟢 TDD Green | `tdd-green` | Source + test files |
| 🔵 TDD Refactor | `tdd-refactor` | Source + test files |
| 🔍 TDD Review | `tdd-review` | Read-only (reports only) |
| 🔄 TDD Orchestrator | `tdd-orchestrator` | `stories/*.md` + shell commands |

File restrictions are enforced by Roo Code — modes physically cannot edit files outside their allowed patterns.

---

## Git Conventions

| Phase | Prefix | Example |
|-------|--------|---------|
| Spec | `spec:` | `spec: 001 — user registration scenarios` |
| Red | `test(red):` + `— PENDING` | `test(red): 001 — register returns 201 — PENDING` |
| Green | `feat(green):` | `feat(green): 001 — implement registration endpoint` |
| Refactor | `refactor:` | `refactor: extract PasswordValidator class` |
| Cycle close | `chore:` + `— cycle complete ✅` | `chore: story/001 — cycle complete ✅` |

A completed story also gets a **git tag**: `story/001-user-registration`

---

## Customising This Template

When adopting this template for a new project:

1. ✅ **Replace** `docs/product-definition.md`
2. ✅ **Replace** `docs/architecture-spec.md`
3. ✅ **Delete** `stories/001-example-story.md`
4. ✅ **Update** `stories/README.md` with your real stories
5. ✅ **Keep** all `.roo/` rules files and `.roomodes` — they are technology-agnostic

---

## Architecture Documentation

See [`plans/tdd-infrastructure.md`](plans/tdd-infrastructure.md) for the full architecture document including design decisions, workflow diagrams, and component descriptions.

---

## Setting Up a New Project

See [`docs/new-project-setup.md`](docs/new-project-setup.md) for step-by-step instructions on how to configure this template for a real project — including what to replace, what to delete, what to fill in, and how to verify Roo is reading the correct context before starting the TDD cycle.
