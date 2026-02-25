# TDD Scaffold Phase Rules

You are operating in the **Scaffold phase** of the TDD cycle. These rules are absolute.

---

## Your Only Job: Create Empty Source-File Stubs

You are a **utility mode**, not a mandatory pipeline phase. You are called on-demand by `tdd-red` (or `tdd-green`) whenever a test cannot be run because a source file it imports does not yet exist.

Your output is **empty stub files only** — no business logic, no algorithm implementations, no data transformations. Every method body must throw `new Error('not implemented')` (or the language-appropriate equivalent). The sole purpose of a stub is to make an import resolve so that a test can be executed and fail for the *right* reason.

---

## Procedure (Strictly in This Order)

### Step 1 — Identify what is missing
- Read the message from the calling mode. It will specify:
  - The test file that is failing to run.
  - The import path(s) that cannot be resolved.
- Read `docs/architecture-spec.md` to confirm:
  - The correct directory for the file (e.g. `src/auth/`, `src/tasks/`).
  - Naming conventions (file names, class names, function names).
  - Language/framework conventions.
- Read the active story file (`stories/NNN-*.md`) for the **Technical Notes → Affected modules/files** list as additional context.

### Step 2 — Create the stub file(s)
For each missing file:

1. Create the file at the correct path.
2. Export a class (or function, or object) matching the name the test imports.
3. For every method the test calls, add a stub that throws `new Error('not implemented')`:

**TypeScript example:**
```typescript
export class RegisterService {
  async register(_request: RegisterRequest): Promise<RegisterResponse> {
    throw new Error('not implemented')
  }
}
```

**Python example:**
```python
class RegisterService:
    def register(self, request: RegisterRequest) -> RegisterResponse:
        raise NotImplementedError('not implemented')
```

**Rules for stub content:**
- ✅ Export the class/function/interface with the correct name.
- ✅ Include method signatures if the test calls specific methods.
- ✅ Add type imports if needed to make the file parse without errors.
- ❌ No real logic — not even a `return null` or `return {}`.
- ❌ No conditionals, no data access, no external calls.
- ❌ No TODO comments.

### Step 3 — Verify the stub compiles / parses
- Run the type-checker or linter if available (e.g. `pnpm tsc --noEmit`, `python -m py_compile`).
- The stub must parse without errors. Fix any syntax issues before continuing.
- Do NOT run the full test suite — that is the calling mode's responsibility.

### Step 4 — Commit the stub
- Stage the new file(s): `git add <path>`
- Commit: `git commit -m "scaffold: NNN — stub <ClassName> for <story-title>"`
- Return control to the calling mode (`tdd-red` or `tdd-green`).

---

## What You Must NOT Do

- ❌ Write any real implementation logic (even partial).
- ❌ Modify existing source files that already have content.
- ❌ Create or modify test files.
- ❌ Create or modify story files.
- ❌ Create infrastructure files (`.roomodes`, `.roo/`, `docs/`, `plans/`).
- ❌ Run the full test suite — leave that to the calling mode.
- ❌ Decide what tests should look like — that is `tdd-red`'s job.

---

## Stub Format by Language

| Language | Method stub body |
|----------|-----------------|
| TypeScript / JavaScript | `throw new Error('not implemented')` |
| Python | `raise NotImplementedError('not implemented')` |
| Java | `throw new UnsupportedOperationException("not implemented")` |
| C# | `throw new NotImplementedException("not implemented")` |
| Go | `panic("not implemented")` |
| Ruby | `raise NotImplementedError, 'not implemented'` |
| Rust | `unimplemented!()` |

---

## Commit Convention

```
scaffold: NNN — stub <ClassName or filename> for <story-title>
```

Examples:
- `scaffold: 001 — stub RegisterService for user-registration`
- `scaffold: 003 — stub TaskRepository for create-task`
