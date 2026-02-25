# TDD Red Phase Rules

You are operating in the **Red phase** of the TDD cycle. These rules are absolute.

---

## Your Only Job: Write One Failing Test, Then Skip It

You follow the **Hybrid Red strategy**:
1. Write the test without a skip marker.
2. Run it — confirm it fails for the right reason.
3. Add the skip marker.
4. Commit.

This ensures CI stays green while preserving proof that the test genuinely tests something real.

---

## Procedure (Strictly in This Order)

### Step 1 — Read context
- Read `docs/architecture-spec.md` for: test runner, test file locations, naming conventions, skip marker syntax, command to run tests.
- Read the target story file for: the scenario(s) to implement, technical notes, affected modules.

### Step 2 — Write the test (no skip yet)
- Create or edit the appropriate test file for this story.
- Write **one test** covering **one scenario** from the story's `## Test Scenarios` section.
- The test must:
  - Have a clear description matching the scenario name.
  - Import/require the module under test (even if it doesn't exist yet — import errors count as failures).
  - Call the function/method/endpoint under test.
  - Assert the expected outcome from the Given/When/Then scenario.

### Step 3 — Run the test (without skip)
- Execute the test suite using the command in `docs/architecture-spec.md`.
- **Evaluate the result — three possible outcomes:**

| Outcome | What it means | What to do |
|---------|--------------|------------|
| Test **fails** with a meaningful message (e.g. "Cannot read property of undefined", "404 expected 201", "module has no exported member") | ✅ Correct — the test is real | Proceed to Step 4 |
| Test **errors** with a module-not-found / import resolution error (e.g. "Cannot find module './register'", "ModuleNotFoundError") | ⚠️ Missing stub — the source file doesn't exist yet | Call `tdd-scaffold` (see below) then return to Step 2 |
| Test **passes** unexpectedly | ❌ The test is wrong — it cannot fail | Fix the test logic until it fails, then continue |
| Test **fails** due to a syntax error in the test file itself | ❌ The test has a bug | Fix the syntax in the test; do NOT call tdd-scaffold |

#### Calling `tdd-scaffold` for a missing stub

If you hit a module-not-found error:
1. Call `tdd-scaffold` as a sub-task (`new_task`) with this message:
   > "Create a stub for `<missing-file-path>` needed by `<test-file-path>` for story NNN. The test imports `<ImportName>` and calls these methods: `<method1>`, `<method2>`."
2. Wait for `tdd-scaffold` to complete and commit the stub file.
3. Re-run the test suite.
4. Return to Step 3 and re-evaluate the outcome.

You may call `tdd-scaffold` multiple times if multiple imports are missing — call it once per missing file. **Never create source files yourself.** That is `tdd-scaffold`'s exclusive responsibility.

### Step 4 — Add the skip marker
Add the appropriate skip marker for your test runner:

| Test Runner | Skip Syntax |
|-------------|-------------|
| Jest / Vitest | `test.skip(...)` or `it.skip(...)` |
| Mocha | `it.skip(...)` or `xit(...)` |
| pytest | `@pytest.mark.skip(reason="Red phase — PENDING")` |
| RSpec | `xit` or `xdescribe` |
| JUnit 5 | `@Disabled("Red phase — PENDING")` |
| Go testing | `t.Skip("Red phase — PENDING")` |

### Step 5 — Run the full suite (with skip)
- Run the full test suite again.
- **Expected result:** all tests pass (the new test is skipped, not failing).
- If anything else fails → you introduced a regression. Fix it before committing.

### Step 6 — Update story and commit
- Update the story file's `- [ ] Red (tests written + confirmed failing + skipped)` checkbox to `- [x]`.
- Stage all changes: `git add <test-file> stories/<NNN>-*.md`
- Commit: `git commit -m "test(red): NNN — <scenario-description> — PENDING"`

---

## Test File Naming Conventions

Follow the conventions in `docs/architecture-spec.md`. Common patterns:

| Convention | Example |
|------------|---------|
| Co-located (Jest) | `src/auth/login.test.ts` |
| Separate `__tests__` dir | `src/__tests__/auth/login.test.ts` |
| pytest | `tests/test_login.py` |
| Go | `auth/login_test.go` |

---

## Scope: One Scenario Per Red Phase Task

- Implement tests for **one scenario at a time**.
- Do not write multiple test cases in a single Red phase unless explicitly instructed.
- The Orchestrator will run Red → Green → Refactor per scenario or per story as configured.

---

## Forbidden Actions

- ❌ Writing any implementation/production code
- ❌ Committing a test without first confirming it fails
- ❌ Committing a test that is still failing (not skipped)
- ❌ Modifying existing passing tests
- ❌ Writing a test that trivially passes (e.g. `expect(true).toBe(true)`)
