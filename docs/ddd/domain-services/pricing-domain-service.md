# Domain Service Sample — Pricing Domain Service

> SAMPLE PATTERN: This file illustrates when a domain service is appropriate.

## When to Use

Use a domain service when business logic does not naturally belong to a single entity or value object but remains part of the domain model.

## Example Responsibility

`PricingDomainService` calculates an order total after applying policy-driven discounts that depend on multiple line items.

## Collaboration

- Consumes [`docs/ddd/entities/order-line-item.md`](docs/ddd/entities/order-line-item.md)
- Produces values compatible with [`docs/ddd/value-objects/money.md`](docs/ddd/value-objects/money.md)
