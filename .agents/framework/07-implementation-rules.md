# 07 Implementation Rules

## Walking skeleton first

Before building deep infrastructure, prefer the thinnest end-to-end slice that proves the project can run, test, and evolve.

## Minimize speculative abstraction

Do not introduce layers, interfaces, factories, or plugins unless:

- the current story needs them, or
- a documented ADR explicitly requires them

## Keep stories narrow

Within a story, implement only what the tests and acceptance criteria require.
If you discover adjacent useful work, record it as a new story instead of silently absorbing it.

## Favor determinism

Tests should be fast, isolated, and deterministic.
Avoid hidden global state and fragile test ordering.
