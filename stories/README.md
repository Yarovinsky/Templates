# Story Backlog

This file is the **single source of truth** for story status. The `tdd-orchestrator` reads this file to determine which story to work on next and updates it as each phase completes.

---

## How to Add a Story

1. Copy `stories/000-story-template.md` to `stories/NNN-short-title.md`.
2. Fill in all sections of the new story file.
3. Add a row to the table below.
4. Set Priority appropriately — the orchestrator works highest-priority-first (lowest number).

---

## Status Key

| Symbol | Meaning |
|--------|---------|
| — | Not started |
| ⏳ | In progress |
| ✅ | Complete |

---

## Backlog

| # | Priority | Story | Spec | Red | Green | Refactor | Review | Git Tag |
|---|----------|-------|------|-----|-------|----------|--------|---------|
| [001](001-example-story.md) | 🔴 1 | User Registration | ✅ | ✅ | — | — | — | — |
| [002](000-story-template.md) | 🔴 2 | User Login | — | — | — | — | — | — |
| [003](000-story-template.md) | 🔴 3 | Create Task | — | — | — | — | — | — |
| [004](000-story-template.md) | 🔴 4 | List Tasks | — | — | — | — | — | — |
| [005](000-story-template.md) | 🟡 5 | Update Task Status | — | — | — | — | — | — |
| [006](000-story-template.md) | 🟡 6 | Delete (Archive) Task | — | — | — | — | — | — |

> **Note:** Stories 002–006 are stubs. Create real story files by copying `000-story-template.md` and filling them in before the orchestrator reaches them.

---

## Completed Stories

> Stories are moved here once their Git Tag column is filled.

| # | Story | Git Tag | Completed |
|---|-------|---------|-----------|
| — | — | — | — |
