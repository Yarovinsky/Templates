# Story: [NNN] — [Short Title]

> Copy this file to `stories/NNN-short-title.md` and fill in every section.
> Add a row for this story in `stories/README.md` before starting.

---

## Status

- [ ] Spec written
- [ ] Red (tests written + confirmed failing + skipped)
- [ ] Green (tests passing)
- [ ] Refactor (code cleaned up)
- [ ] Committed & tagged

---

## Metadata

| Field | Value |
|-------|-------|
| **Story #** | NNN |
| **Priority** | 🔴 High / 🟡 Medium / 🟢 Low |
| **Estimate** | S / M / L / XL |
| **Depends on** | Story NNN (or — if none) |

---

## User Story

> As a **[persona from docs/product-definition.md]**,
> I want **[capability]**,
> so that **[benefit / value]**.

---

## Acceptance Criteria

> Each criterion will be expanded into Given/When/Then scenarios by `tdd-spec`.

- [ ] AC1: [Describe the first required behaviour]
- [ ] AC2: [Describe the second required behaviour]
- [ ] AC3: [Describe the edge/error case]

---

## Scope

### In Scope
- [What this story covers — be specific]

### Out of Scope
- [What is explicitly NOT part of this story — prevents scope creep]
- [Refer to related future stories if applicable: "see story/NNN"]

---

## Technical Notes

> Optional hints for `tdd-red` and `tdd-green` modes.

- **Affected modules/files:** [e.g. `src/auth/login.ts`, `src/auth/login.test.ts`]
- **Dependencies/mocks needed:** [e.g. "mock the UserRepository — do not hit real DB in unit tests"]
- **Key types/interfaces:** [e.g. "use the `LoginRequest` and `AuthToken` types from `src/shared/types.ts`"]
- **Edge cases to test:** [e.g. "empty string password, password > 72 chars (bcrypt limit)"]
- **Error responses:** [e.g. "return HTTP 401 with body `{ error: 'Invalid credentials' }` — do NOT distinguish between bad email and bad password"]

---

## Test Scenarios

> This section is filled in by `tdd-spec` during the Spec phase. Do not fill in manually.

<!-- tdd-spec will populate this section -->

---

## Git Tag

`story/NNN-short-title`
