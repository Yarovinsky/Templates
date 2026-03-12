# Context Map Template

Use this document to describe how bounded contexts interact. Capture relationships, translation needs, integration styles, and ownership dynamics.

## Context Relationships Overview

| Upstream Context | Downstream Context | Relationship Pattern | Integration Style | Translation Needed | Notes |
| --- | --- | --- | --- | --- | --- |
| `<upstream>` | `<downstream>` | `<customer-supplier / conformist / partnership / anti-corruption / shared kernel / separate ways / open host service / published language>` | `<API / event / batch / file / manual>` | `<yes / no>` | `<notes>` |

## Interaction Detail Template

### `<Upstream>` -> `<Downstream>`

| Field | Value |
| --- | --- |
| Relationship Pattern | `<pattern>` |
| Dependency Type | `<runtime / data / organizational>` |
| Contract | `<interface or artifact>` |
| Failure Mode | `<what happens when integration fails>` |
| Change Coordination | `<how breaking changes are handled>` |
| Translation / ACL Strategy | `<mapping, anti-corruption layer, published language>` |

## Systemic Risks

| Risk | Affected Contexts | Trigger | Mitigation |
| --- | --- | --- | --- |
| `<risk>` | `<contexts>` | `<trigger>` | `<mitigation>` |

## Maintenance Notes

- Update this artifact when context boundaries or integration contracts change.
- Keep naming aligned with [`docs/ddd/bounded-contexts.md`](docs/ddd/bounded-contexts.md).
- Link conflicts and unresolved tensions in [`docs/ddd/conflicts.md`](docs/ddd/conflicts.md).
