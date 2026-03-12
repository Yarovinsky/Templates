# Repository Sample — Order Repository

> SAMPLE PATTERN: This repository contract demonstrates how to document persistence boundaries for an aggregate.

## Contract

- `save(order)` persists a valid aggregate root.
- `findById(orderId)` returns the aggregate root or an explicit not-found result.
- `nextIdentity()` returns a new aggregate identifier when identity is repository-generated.

## Constraints

- Repository methods must preserve aggregate invariants.
- Partial aggregate persistence is prohibited.
- Integration behavior should be covered by repository-focused integration tests.
