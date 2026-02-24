# TDD Core Principles & Commit Conventions

These rules apply to **all modes** in this repository at all times.

---

## The Three Laws of TDD

1. **You may not write production code unless it is to make a failing test pass.**
2. **You may not write more of a failing test than is sufficient to fail** (compilation failures count as failures).
3. **You may not write more production code than is sufficient to make the one failing test pass.**

These laws are non-negotiable. No exceptions.

---

## The TDD Cycle

Every unit of work follows this mandatory sequence:

```
Spec → Red → Green → Refactor → Review → Git Tag
```

- **Spec**: Decompose a user story into testable Given/When/Then scenarios.
- **Red**: Write a failing test for one scenario. Confirm it fails. Then skip it for safe commit.
- **Green**: Remove the skip. Write minimal code to make the test pass.
- **Refactor**: Improve code quality without changing behaviour. Tests must stay green.
- **Review**: Validate all acceptance criteria are covered, all tests pass, no dead code.
- **Git Tag**: Applied only after Review approves.

---

## Git Commit Conventions

Every phase ends with a mandatory Git commit. Use these exact prefixes:

| Phase | Prefix | Suffix | Example |
|-------|--------|--------|---------|
| Spec | `spec:` | — | `spec: 001 — user can register with email` |
| Red | `test(red):` | `— PENDING` | `test(red): 001 — register returns 201 — PENDING` |
| Green | `feat(green):` | — | `feat(green): 001 — implement user registration endpoint` |
| Refactor | `refactor:` | — | `refactor: extract UserValidator from RegisterController` |
| Review/Close | `chore:` | `— cycle complete ✅` | `chore: story/001 — cycle complete ✅` |

### Rules for commits

- **Never commit with failing tests** — except during the Red phase where tests must be skipped before committing.
- **Never commit skipped tests** — except during the Red phase.
- **Always run the full test suite** before committing in Green, Refactor, and Review phases.
- **One logical change per commit** — especially during Refactor (one refactor step = one commit).
- **Commit messages must reference the story number** (e.g. `001`).

---

## Forbidden Practices

- ❌ Writing implementation code before a failing test exists
- ❌ Writing tests that are impossible to fail
- ❌ Skipping the Refactor phase ("we'll clean it up later")
- ❌ Applying a git tag without a passing Review
- ❌ Merging a PR that does not reference a story
- ❌ Committing debug code, `console.log`, `print()`, or `TODO` comments
- ❌ Leaving any test permanently skipped after the Green phase

---

## Story-Driven Development

All work must be traceable to a story file in `stories/`.

- Every feature, fix, or behaviour change starts with a story.
- No code is written without a corresponding story being in progress.
- Story files are the single source of truth for scope — if it's not in the story, it's out of scope.
