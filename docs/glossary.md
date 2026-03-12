# Glossary Template

Use this document as the project glossary baseline. Keep entries short, testable, and aligned with domain language used across requirements, architecture, implementation, and delivery artifacts.

## Purpose

- Define shared terminology used by business and engineering stakeholders.
- Reduce ambiguity between product language and implementation language.
- Provide a reference point for [`docs/ddd/domains.md`](docs/ddd/domains.md), [`docs/ddd/bounded-contexts.md`](docs/ddd/bounded-contexts.md), and [`docs/traceability-matrix.md`](docs/traceability-matrix.md).

## How To Use This Template

1. Add one entry per important business, technical, or delivery term.
2. Prefer project language over generic textbook definitions.
3. Record synonyms, prohibited terms, and context-specific meaning where relevant.
4. Update this file whenever requirements or domain models introduce new vocabulary.

## Entry Format

Use the structure below for each term.

| Term | Definition | Category | Source Artifact | Synonyms / Aliases | Notes / Misuse Warnings |
| --- | --- | --- | --- | --- | --- |
| `<term>` | `<clear definition in project language>` | `<business / domain / technical / delivery / testing>` | `<artifact or decision where term originates>` | `<optional alternate names>` | `<optional ambiguity, exclusions, or cautions>` |

## Suggested Sections

### Business Terms

Capture vocabulary used by sponsors, users, operators, or downstream consumers.

### Domain Terms

Capture ubiquitous language used in domain analysis and DDD artifacts.

### Technical Terms

Capture implementation-specific terms that appear in architecture or code.

### Delivery Terms

Capture terms related to releases, environments, support, quality gates, or operational readiness.

## Review Checklist

- Terms match language used in requirements and architecture artifacts.
- Definitions avoid circular wording.
- Ambiguous terms have clear disambiguation notes.
- Deprecated or discouraged terms are explicitly called out.
- Cross-references remain consistent with current domain documentation.
