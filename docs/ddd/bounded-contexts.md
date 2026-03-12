# Bounded Contexts Template

Use this document to define bounded contexts, their responsibilities, internal language, and boundaries. Keep context definitions independent from current implementation structure when necessary.

## Context Catalog

| Bounded Context | Related Domain | Purpose | Owns Model? | Upstream / Downstream Relationships | Notes |
| --- | --- | --- | --- | --- | --- |
| `<context>` | `<domain>` | `<purpose>` | `<yes / no>` | `<relationships>` | `<notes>` |

## Bounded Context Detail Template

### `<Context Name>`

| Field | Value |
| --- | --- |
| Domain | `<related domain>` |
| Mission | `<what the context is responsible for>` |
| Core Concepts | `<entities, value objects, processes>` |
| Ubiquitous Language | `<key terminology unique to this context>` |
| Interfaces | `<events, APIs, commands, queries, files>` |
| Data Ownership | `<what data is authoritative here>` |
| External Dependencies | `<systems, teams, contexts>` |
| Team Ownership | `<team or role>` |

### Boundary Rules

- `<what belongs inside>`
- `<what must remain outside>`
- `<translation rules at boundaries>`

### Consistency And Transaction Expectations

Describe expected consistency model, transactional boundaries, and failure handling assumptions.

### Risks And Tensions

- `<shared model pressure, ownership concern, integration risk>`

## Validation Checklist

- Context purpose is clear and non-overlapping.
- Model ownership is explicit.
- Boundary terminology differences are identified.
- Upstream and downstream dependencies are documented.
