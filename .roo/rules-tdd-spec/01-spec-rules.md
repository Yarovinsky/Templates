# TDD Spec Phase Rules

You are operating in the **Spec phase** of the TDD cycle. These rules are absolute.

---

## Your Only Output: Testable Scenarios

Your job is to transform the user story and acceptance criteria in the story file into a precise, unambiguous list of **Given/When/Then scenarios** that a developer can implement as tests without asking any questions.

---

## Procedure

1. **Read** `docs/product-definition.md` — understand product goals and user personas.
2. **Read** `docs/architecture-spec.md` — understand technical constraints (e.g. HTTP status codes, data formats, auth mechanisms).
3. **Read** the target story file — focus on the **Acceptance Criteria** and **Technical Notes** sections.
4. **Decompose** each acceptance criterion into one or more Given/When/Then scenarios.
5. **Write** the expanded scenarios back into the story file under a new `## Test Scenarios` section.
6. **Check** that every edge case mentioned in Technical Notes is covered by at least one scenario.
7. **Mark** the story's `- [ ] Spec written` checkbox as `- [x] Spec written`.
8. **Commit**: `git add stories/<NNN>-*.md && git commit -m "spec: NNN — <story-title>"`

---

## Given/When/Then Format

Each scenario must follow this exact structure:

```
### Scenario N: <short description>
- **Given** <the precondition / system state>
- **When** <the action performed>
- **Then** <the expected observable outcome>
- **And** <additional assertions if needed> (optional)
```

---

## Quality Rules for Scenarios

- **One behaviour per scenario** — do not combine multiple assertions into one scenario.
- **Observable outcomes only** — "Then" must describe something a test can assert (return value, HTTP status, database state, emitted event, error message).
- **No implementation details** — do not specify function names, class names, or internal structure. Describe behaviour, not code.
- **Cover the unhappy path** — for every happy-path scenario, consider: What happens with invalid input? What happens when a dependency fails? What happens at boundary values?
- **Reference the persona** — use the persona name from `docs/product-definition.md` (e.g. "Given a logged-in Reader...").

---

## Scope Enforcement

- If an acceptance criterion is ambiguous or missing detail, **make a reasonable assumption and document it** in the scenario's description. Do not ask the user — use the product definition and architecture spec to infer the correct behaviour.
- If a requested behaviour falls under the story's **Out of Scope** section — **do not generate a scenario for it**. Add a comment: `> Out of scope for this story — see story/NNN`.

---

## Forbidden Actions

- ❌ Writing any test code (`.test.`, `.spec.`, `_test`, `test_`)
- ❌ Writing any implementation code
- ❌ Modifying any source file
- ❌ Committing without updating the story's Spec checkbox
