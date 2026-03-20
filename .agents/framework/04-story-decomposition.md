# 04 Story Decomposition

## Goal

Convert an HLD into stories that are small enough to be implemented safely through TDD.

## Rules for a good story

A story should be:

- vertically sliced, not layer-sliced
- independently testable
- demonstrable on its own
- small enough for one Red → Green → Refactor loop
- explicit about what is out of scope

## Preferred decomposition order

1. walking skeleton
2. core domain or workflow happy path
3. error handling and edge cases
4. operational and observability concerns
5. convenience and performance improvements

## Anti-patterns

Do not create stories like:

- “build backend foundation”
- “implement database layer”
- “create all endpoints”
- “write full UI”

These are too horizontal and invite uncontrolled scope.

## Better examples

- “Expose a health endpoint returning static OK”
- “Persist one valid order and return its identifier”
- “Reject duplicate email during registration”
- “Render the first results page for a search query”
