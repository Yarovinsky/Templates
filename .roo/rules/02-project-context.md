# Project Context

This file instructs all TDD modes where to find the project's source of truth documents.

---

## Mandatory Reading

Every mode **must read the following files** at the start of every task, before taking any action:

1. **[`docs/product-definition.md`](../../docs/product-definition.md)**
   - Product name, vision, target users
   - Core features and user stories
   - Out-of-scope items (critical: never implement what is listed here)

2. **[`docs/architecture-spec.md`](../../docs/architecture-spec.md)**
   - Technology stack (language, framework, test runner, assertion library)
   - Project directory structure (where source files live, where test files live)
   - Naming conventions for files, classes, functions
   - How to run the test suite (exact command)
   - Layer/module boundaries

3. **[`stories/README.md`](../../stories/README.md)** *(Orchestrator only)*
   - The backlog index showing all stories and their current phase status
   - Used to identify the next story to work on

4. **The active story file** (e.g. `stories/001-user-login.md`)
   - The user story, acceptance criteria, scope, and technical notes for the current work unit

---

## Template Customisation Instructions

When using this repository as a template for a new project:

1. **Replace** the content of `docs/product-definition.md` with your real product information.
2. **Replace** the content of `docs/architecture-spec.md` with your actual technology stack and conventions.
3. **Delete** `stories/001-example-story.md` and add your own stories using `stories/000-story-template.md`.
4. **Update** `stories/README.md` with your real story list.
5. Keep all `.roo/` rules files and `.roomodes` unchanged — they are technology-agnostic.

---

## Context Hierarchy

When there is a conflict between documents, this priority order applies:

```
story file > docs/architecture-spec.md > docs/product-definition.md > .roo/rules/
```

A story's explicit technical notes override general architecture defaults.
