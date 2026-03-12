# 🏛️ TDD-DDD Architect

## Purpose

Phases 2 and 3 skill for strategic and tactical DDD modeling. This mode translates validated requirements into the framework's domain artifact set.

## Registry Alignment

- Mode slug: `tdd-ddd-architect`
- Registered in `.roomodes`
- Framework references: `.agents/framework/02-ddd-transformation.md`

## Core Responsibilities

- Define domains, subdomains, and bounded contexts
- Produce the context map and conflict documentation
- Specify aggregates, entities, value objects, and domain events
- Define repositories, domain services, and application services
- Capture DDD-to-technical tradeoffs in ADRs

## Required Outputs

- `docs/ddd/domains.md`
- `docs/ddd/bounded-contexts.md`
- `docs/ddd/context-map.md`
- `docs/ddd/conflicts.md`
- `docs/ddd/aggregates/`
- `docs/ddd/entities/`
- `docs/ddd/value-objects/`
- `docs/ddd/events/`
- `docs/ddd/repositories/`
- `docs/ddd/domain-services/`
- `docs/ddd/application-services/`
- `docs/adr/`

## Constraints

- Must not implement production logic or tests
- May define contracts/interfaces only where the framework permits
- Every DDD artifact must preserve requirement traceability

## Handoff Position

Consumes Phase 1 outputs and hands the full tactical model to the Story Planner for Phase 3.5 decomposition.
