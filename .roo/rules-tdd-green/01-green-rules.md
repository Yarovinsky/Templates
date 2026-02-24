# TDD Green Phase Rules

You are operating in the **Green phase** of the TDD cycle. These rules are absolute.

---

## Your Only Job: Make the Skipped Test Pass with Minimum Code

You write the **least possible implementation** to turn the skipped test green. Nothing more.

---

## Procedure (Strictly in This Order)

### Step 1 — Read context
- Read `docs/architecture-spec.md` for: project structure, layer boundaries, naming conventions, dependency injection patterns, and coding standards.
- Read the target story file for: the scenario being implemented, technical notes, affected modules, and any implementation hints.

### Step 2 — Locate the skipped test
- Find the test file(s) modified in the Red phase for this story.
- Identify the specific test(s) marked with a skip marker.

### Step 3 — Remove the skip marker
- Delete the skip annotation/wrapper from the target test(s).
- Do NOT modify the test logic — only remove the skip.

### Step 4 — Run the test (now failing, not skipped)
- Execute the test suite.
- **Expected result:** the previously skipped test now FAILS (not skipped).
- If it is still skipped → you missed a skip marker. Find and remove it.
- If it passes immediately without any implementation → the test is not testing real behaviour. Stop and re-enter the Red phase.

### Step 5 — Write minimum implementation
Write only the code necessary to make the failing test pass:
- **Start with the simplest possible implementation** — even if it feels naive.
- Do not add methods, parameters, or logic that no current test requires.
- Do not anticipate future requirements.
- Do not optimise. Do not refactor. Do not add logging.
- Follow the layer/module structure defined in `docs/architecture-spec.md`.

### Step 6 — Run the full test suite
- Execute the full test suite.
- **Required:** ALL tests must pass. Zero failures. Zero unexpected skips.
- If a previously passing test now fails → you introduced a regression. Fix the regression before proceeding. Do not weaken existing tests to make them pass.

### Step 7 — Update story and commit
- Update the story file's `- [ ] Green (tests passing)` checkbox to `- [x]`.
- Stage ALL changes (unskipped test + implementation + story update):
  ```
  git add .
  git commit -m "feat(green): NNN — <description of what was implemented>"
  ```

---

## The Minimum Code Principle

Ask yourself after writing each line: *"Does a currently failing test require this line?"*

- If **yes** → keep it.
- If **no** → delete it.

Common violations to avoid:

| Violation | Example |
|-----------|---------|
| Implementing the next feature early | Adding pagination when only "get one item" is tested |
| Defensive coding beyond test scope | Adding null-checks for cases no test covers |
| Premature abstraction | Creating an interface when one concrete class suffices |
| Gold-plating | Adding logging, metrics, or caching nobody asked for |

---

## Handling Missing Infrastructure

If the implementation requires creating a new file, class, or module that doesn't exist yet:

- Create it with **only** what the test needs — no skeleton methods, no placeholder TODOs.
- Use the naming conventions from `docs/architecture-spec.md`.
- Place the file in the correct directory as specified in `docs/architecture-spec.md`.

---

## Forbidden Actions

- ❌ Modifying test assertions to make a test pass
- ❌ Deleting or weakening existing tests
- ❌ Writing code not required by the current failing test
- ❌ Committing with any test still failing or still skipped (from this story)
- ❌ Refactoring during the Green phase (save it for tdd-refactor)
- ❌ Adding `console.log`, `print()`, or debug statements
