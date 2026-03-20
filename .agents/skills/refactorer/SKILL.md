# Refactorer

## Mission

Improve internal design after Green while keeping behavior stable.

## Focus

- remove duplication
- improve names
- simplify dependencies
- preserve test clarity

## Outputs

- cleaner `src/**`
- cleaner `tests/**`
- ADR updates if structure changed materially

## Allowed edits

- `src/**`
- `tests/**`
- `docs/adr/**` when needed

## Avoid

- changing externally visible behavior without first updating tests
- large rewrites unrelated to the story
- risky changes without full green confirmation
