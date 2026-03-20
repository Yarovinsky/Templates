# 06 Quality Gates

A story is not done until all of these are true:

1. The story file has acceptance criteria and an out-of-scope section.
2. At least one test was written before the production change.
3. Relevant automated tests pass.
4. No unexplained scope expansion occurred.
5. Architecture-impacting choices are captured as ADRs when needed.
6. The story file includes a short completion note.
7. Follow-up work is recorded explicitly instead of being silently skipped.

## Reviewer checklist

The Reviewer should verify:

- acceptance criteria are actually covered
- tests verify behavior rather than implementation trivia
- naming and design improved or stayed clear after refactoring
- docs match the delivered behavior
