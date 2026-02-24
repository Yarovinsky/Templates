# TDD Refactor Phase Rules

You are operating in the **Refactor phase** of the TDD cycle. These rules are absolute.

---

## Your Only Job: Improve Code Quality Without Changing Behaviour

The tests are green. Your job is to make the code **better** — more readable, more maintainable, less duplicated — without changing what it does. One step at a time. Commit after each step.

---

## Procedure

### Step 1 — Establish a green baseline
- Run the full test suite before touching any code.
- **Required:** All tests must pass. If anything is failing, stop and report — do not refactor broken code.

### Step 2 — Identify refactor opportunities
Review the code introduced or modified in the Green phase. Look for:
- Duplicated logic that could be extracted into a shared function/method
- Long functions/methods that could be split
- Unclear variable or function names
- Magic numbers or strings that should be named constants
- Complex conditionals that could be simplified or extracted
- Missing type annotations (in typed languages)
- Structural misalignment with the architecture defined in `docs/architecture-spec.md`

### Step 3 — Apply ONE refactor at a time
- Choose the highest-value improvement.
- Make **only that one change**.
- Do not combine multiple improvements into a single edit.

### Step 4 — Run the full test suite immediately
- Execute the full test suite after every single refactor step.
- **Required:** All tests must still pass.
- If any test fails → **revert the last change immediately** using `git checkout -- <file>` or by undoing the edit. Do not proceed with a broken refactor.

### Step 5 — Commit the single refactor step
```
git add .
git commit -m "refactor: <concise description of what was improved>"
```

Examples:
- `refactor: extract validateEmail to EmailValidator class`
- `refactor: rename 'u' to 'currentUser' in AuthService`
- `refactor: replace magic number 3600 with TOKEN_EXPIRY_SECONDS constant`
- `refactor: simplify parseDate conditional using early return`

### Step 6 — Repeat from Step 2
Continue until no further meaningful improvements remain.

### Step 7 — Final story update commit
- Update the story file's `- [ ] Refactor (code cleaned up)` checkbox to `- [x]`.
- Commit: `git commit -m "chore: NNN — refactor phase complete"`

---

## Acceptable Refactors

| Category | Examples |
|----------|---------|
| **Extract** | Extract method, extract class, extract constant, extract module |
| **Rename** | Variables, functions, classes, files — for clarity |
| **Simplify** | Flatten nested conditionals, use early returns, reduce cyclomatic complexity |
| **DRY** | Remove duplicated logic by creating shared utilities |
| **Organise** | Move a function to the correct module/layer per architecture spec |
| **Types** | Add missing type annotations, tighten overly broad types |
| **Error handling** | Consolidate error handling patterns for consistency |

---

## Not Acceptable During Refactor

| Violation | Why |
|-----------|-----|
| Adding new behaviour | That requires a new story → new TDD cycle |
| Changing test assertions | Tests define the contract — don't move the goalposts |
| Removing tests | Every test is a specification — removal requires explicit story scope |
| Changing public interfaces | Breaks consumers — requires a story |
| Adding new dependencies | Scope creep — requires a story |
| Optimising for performance | Premature optimisation — measure first, story second |

---

## Atomic Commit Rule

**One refactor = one commit.** This is non-negotiable.

Atomic commits allow:
- Safe `git revert` of a single broken refactor
- Clear review history showing each improvement independently
- Bisectable history when something later breaks

---

## Forbidden Actions

- ❌ Combining multiple refactors into one commit
- ❌ Proceeding after a test failure without reverting
- ❌ Changing behaviour while "refactoring"
- ❌ Leaving the test suite in a failing state at any point
- ❌ Committing without running the full test suite first
