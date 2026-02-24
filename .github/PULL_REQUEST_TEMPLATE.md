## Story Reference

**Story file:** <!-- e.g. stories/001-user-registration.md -->

**Git tag:** <!-- e.g. story/001-user-registration -->

---

## TDD Cycle Checklist

> All boxes must be checked before this PR can be merged.

### Phase Completion
- [ ] **Spec** — Given/When/Then scenarios written and committed (`spec: NNN —`)
- [ ] **Red** — Failing tests written, confirmed failing locally, then skipped (`test(red): NNN — PENDING`)
- [ ] **Green** — Skip markers removed, implementation committed, all tests pass (`feat(green): NNN —`)
- [ ] **Refactor** — Code cleaned up, each step committed separately (`refactor: ...`)
- [ ] **Review** — `tdd-review` mode ran and output `✅ REVIEW APPROVED`

### Test Suite
- [ ] All tests pass locally (`pnpm test` or equivalent — see `docs/architecture-spec.md`)
- [ ] Zero failing tests
- [ ] Zero skipped tests (no lingering `test.skip` / `xit` / `@pytest.mark.skip` from the Red phase)
- [ ] No test was deleted or weakened to achieve green status

### Code Quality
- [ ] No `console.log`, `print()`, `debugger`, or equivalent debug statements
- [ ] No `TODO`, `FIXME`, or `HACK` comments in production code
- [ ] No dead code introduced
- [ ] File and function names follow conventions in `docs/architecture-spec.md`

### Git History
- [ ] Commit history contains: `spec:` → `test(red):` → `feat(green):` → `refactor:` → `chore: ... cycle complete ✅`
- [ ] Git tag `story/NNN-<slug>` has been applied and pushed

### Story Bookkeeping
- [ ] Story file status checkboxes are all checked (Spec, Red, Green, Refactor, Committed & tagged)
- [ ] `stories/README.md` row for this story is fully ✅

---

## Summary of Changes

<!-- Briefly describe what was implemented in this PR -->

## Out of Scope Confirmation

<!-- Confirm that no out-of-scope behaviour was implemented. Reference the story's "Out of Scope" section. -->

> I confirm that this PR implements only what is described in the story file and does not include any out-of-scope behaviour.

---

## Reviewer Notes

<!-- Anything specific you want the reviewer to look at or be aware of -->
