# Aggregate Sample — Order

> SAMPLE PATTERN: This file demonstrates the expected shape of a tactical DDD aggregate specification. Replace all names, invariants, and references with project-specific content.

## Purpose

Describe one aggregate root, its invariants, lifecycle rules, and emitted events.

## Aggregate Summary

| Field | Value |
| --- | --- |
| Bounded Context | `OrderManagement` |
| Aggregate Root | `Order` |
| Related Story Pattern | [`docs/stories/STORY-NNN-kebab-case-title.json`](docs/stories/STORY-NNN-kebab-case-title.json) |
| Traceability | `[HLD-REQ-001]`, `[HLD-FN-001]` |

## Invariants

1. An `Order` must contain at least one line item.
2. `totalAmount` must equal the sum of line item amounts.
3. A submitted order cannot be modified without a compensating workflow.

## Commands and Outcomes

| Command | Preconditions | Outcome | Event |
| --- | --- | --- | --- |
| `CreateOrder` | Customer identity present; at least one line item provided | New `Order` created in `Draft` state | `OrderCreated` |
| `SubmitOrder` | Aggregate invariants satisfied | Order transitions to `Submitted` | `OrderSubmitted` |

## Collaboration Notes

- Persist via [`docs/ddd/repositories/order-repository.md`](docs/ddd/repositories/order-repository.md).
- Orchestrate higher-level use cases via [`docs/ddd/application-services/submit-order-application-service.md`](docs/ddd/application-services/submit-order-application-service.md).
