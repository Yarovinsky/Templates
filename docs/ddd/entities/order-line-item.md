# Entity Sample — OrderLineItem

> SAMPLE PATTERN: This is an illustrative tactical DDD entity artifact. Replace it with a real project entity specification.

## Role

`OrderLineItem` is an entity inside the `Order` aggregate. It carries identity only within aggregate scope and participates in aggregate invariants.

## Rules

- Quantity must be greater than zero.
- Unit price is represented by the `Money` value object.
- A line item cannot reference a discontinued product once the order is submitted.

## Traceability

- Aggregate: [`docs/ddd/aggregates/order-aggregate.md`](docs/ddd/aggregates/order-aggregate.md)
- Value Object: [`docs/ddd/value-objects/money.md`](docs/ddd/value-objects/money.md)
