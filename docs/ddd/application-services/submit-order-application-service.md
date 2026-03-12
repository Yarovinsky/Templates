# Application Service Sample — Submit Order

> SAMPLE PATTERN: This file demonstrates how to document an application service workflow that orchestrates domain objects without owning domain invariants.

## Workflow Intent

Coordinate the `SubmitOrder` use case for a single bounded context.

## Workflow Steps

1. Load `Order` from [`docs/ddd/repositories/order-repository.md`](docs/ddd/repositories/order-repository.md).
2. Invoke aggregate behavior to submit the order.
3. Persist the updated aggregate.
4. Publish [`docs/ddd/events/order-submitted.md`](docs/ddd/events/order-submitted.md).

## Story Mapping Pattern

This type of workflow typically maps to a later story that depends on the underlying aggregate and repository stories, such as [`docs/stories/STORY-NNN-kebab-case-title.json`](docs/stories/STORY-NNN-kebab-case-title.json).
