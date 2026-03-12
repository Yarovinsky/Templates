# Value Object Sample — Money

> SAMPLE PATTERN: This file shows the minimum expected structure for a tactical DDD value object specification.

## Definition

`Money` encapsulates an amount plus currency and is immutable.

## Validation Rules

- Amount precision follows the currency minor unit.
- Currency must be an approved ISO-style code for the domain.
- Arithmetic across mismatched currencies is rejected.

## Example Testable Behaviors

- Constructing `Money(10.00, "USD")` succeeds.
- Adding two `Money` instances with the same currency returns a new value object.
- Adding mismatched currencies fails fast.
