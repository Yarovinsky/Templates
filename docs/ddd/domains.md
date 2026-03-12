# Domain Decomposition Template

Use this document to describe the major business domains relevant to the solution space. Focus on domain language, responsibilities, and boundaries rather than implementation detail.

## Purpose

- Identify the problem space at a domain level.
- Separate core, supporting, and generic domains.
- Provide input to [`docs/ddd/bounded-contexts.md`](docs/ddd/bounded-contexts.md) and [`docs/ddd/context-map.md`](docs/ddd/context-map.md).

## Domain Inventory

| Domain | Classification | Business Goal | Primary Capabilities | Key Actors | Notes |
| --- | --- | --- | --- | --- | --- |
| `<domain>` | `<core / supporting / generic>` | `<goal>` | `<capabilities>` | `<actors>` | `<notes>` |

## Per-Domain Detail Template

### `<Domain Name>`

| Field | Value |
| --- | --- |
| Classification | `<core / supporting / generic>` |
| Business Outcome | `<what success looks like>` |
| In Scope | `<capabilities included>` |
| Out Of Scope | `<explicit exclusions>` |
| Key Concepts | `<important nouns, verbs, rules>` |
| Measures Of Effectiveness | `<how value is assessed>` |

### Invariants And Policies

- `<rule or policy>`

### Known Risks Or Open Questions

- `<risk or question>`

## Review Prompts

- Does each domain reflect a distinct business concern?
- Are core domains clearly distinguished from commodity capabilities?
- Are responsibilities consistent with the ubiquitous language?
