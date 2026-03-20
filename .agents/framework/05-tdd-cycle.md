# 05 TDD Cycle

## Red

The Test Writer creates the smallest test that expresses the story intent.
A good Red phase:

- fails for the right reason
- names the behavior clearly
- avoids over-specifying internals

## Green

The Implementer makes the smallest production change needed for the failing test to pass.
A good Green phase:

- solves the current test, not future imagined stories
- prefers clarity over premature abstraction
- keeps the code obviously correct

## Refactor

The Refactorer improves structure while keeping all tests green.
A good Refactor phase:

- removes duplication
- improves names and design seams
- clarifies dependencies and boundaries
- does not alter expected behavior

## Rule of discipline

If tests are red, do not refactor.
If behavior changed, go back to tests first.
