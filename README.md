# Templates

Reusable **TDD-DDD framework baseline** for starting and governing software projects with a strict, story-driven delivery model.

## What this repository is

This repository is a finished reusable baseline for the TDD-DDD delivery framework. It is not a placeholder shell and not just a folder scaffold: it packages the framework contract, Roo mode configuration, baseline project structure, and example/template artifacts needed to start a repository that follows the framework end to end.

The baseline defines a technology-agnostic development process built around:

- validated HLD intake
- strategic and tactical DDD modeling
- story decomposition at Phase 4
- strict red-green-refactor execution per story
- final validation and delivery reporting

## Authoritative assets

The following repository assets are authoritative and define how the framework operates:

- [`.agents/framework/`](.agents/framework/) — normative framework specification, with the index and authority statement in [`.agents/framework/00-overview.md`](.agents/framework/00-overview.md:1)
- [`.roomodes`](.roomodes) — enforced Roo custom mode definitions, responsibilities, and file restrictions for the framework skills
- [`.roo/rules.md`](.roo/rules.md:1) — repository-level execution and framework policy entry point that binds Roo behavior to the authoritative framework and execution rules

Read these as the contract first. Everything else in the repository either supports that contract, demonstrates its expected outputs, or provides a project baseline onto which real product work is added.

## High-level framework model

This baseline implements the framework as an **8-skill / 8-phase** model:

- **8 skills**: Orchestrator, Analyst, DDD Architect, Story Planner, Test Author, Implementer, Refactorer, and Validator
- **8 phases**: Phase 1 through Phase 8, with **Phase 4 Story Decomposition** between tactical modeling and test specification
- **story-scoped execution loop**: after Phase 4, the orchestrator drives Phases 5–8 once per ordered story until the backlog is complete

At a high level, the workflow is:

`Phase 1 → Phase 2 → Phase 3 → Phase 4 → [Phase 5 → Phase 6 → Phase 7 → Phase 8] × N stories`

The authoritative definition of that model is described in [`.roo/rules.md`](.roo/rules.md:22), [`.agents/framework/00-overview.md`](.agents/framework/00-overview.md:30), and [`.agents/framework/11-story-decomposition.md`](.agents/framework/11-story-decomposition.md:9).

## Repository layout

- [`docs/`](docs/) — framework-facing and project-facing documentation baseline, including HLD intake outputs, DDD artifacts, ADRs, traceability, reports, and story-layer artifacts
- [`plans/`](plans/) — implementation planning records for the framework/baseline itself; useful as repository history and design rationale, not as the runtime contract
- [`src/`](src/) — production source location for projects created from this baseline
- [`tests/`](tests/) — automated test location for projects created from this baseline

Within [`docs/`](docs/), the main subareas are:

- [`docs/hld/`](docs/hld/) — validated HLD and intake analysis artifacts
- [`docs/ddd/`](docs/ddd/) — strategic and tactical DDD outputs such as domains, bounded contexts, aggregates, entities, value objects, events, repositories, and services
- [`docs/stories/`](docs/stories/) — Phase 4 story backlog, ordered story files, and MVP scope artifacts
- [`docs/reports/`](docs/reports/) — quality-gate, coverage, and mutation reporting outputs
- [`docs/adr/`](docs/adr/) — architecture decision records

## Artifact categories and repository contract

This repository intentionally separates three kinds of content:

### 1. Normative framework documentation

These files define the enforceable rules of the framework and are the source of truth for behavior:

- [`.agents/framework/`](.agents/framework/)
- [`.roomodes`](.roomodes)
- [`.roo/rules.md`](.roo/rules.md:1)

If a repository consumer needs to know what is mandatory, these files are the answer.

### 2. Baseline templates and examples

These files provide the reusable starting structure and representative outputs expected in a project using the framework:

- documentation skeletons and baseline records under [`docs/`](docs/)
- baseline story artifacts under [`docs/stories/`](docs/stories/)
- empty project roots under [`src/`](src/) and [`tests/`](tests/)
- planning/background material under [`plans/`](plans/)

These are intended to be copied forward, filled in, or replaced by project-specific content while preserving the framework contract.

### 3. Runtime or generated artifacts

These are artifacts a real framework run produces or updates during delivery, such as:

- validated HLD outputs
- DDD specifications
- story backlog and story files
- traceability, delivery, and quality reports
- state/audit records under [`.agents/state/`](.agents/state/)

In this baseline repository, some of those artifacts are present as examples or scaffolding so the expected shape of the repository is explicit.

## Implementation status

This repository should be treated as a **completed framework baseline**:

- the framework contract is authored under [`.agents/framework/`](.agents/framework/)
- Roo mode registration is present in [`.roomodes`](.roomodes)
- repository policy entry points are present in [`.roo/rules.md`](.roo/rules.md:1)
- baseline scaffolding exists for documentation, planning, source, tests, and story artifacts

What remains intentionally open is **project-specific product content**, not framework definition. Teams using this baseline are expected to add or regenerate product artifacts within the established structure while keeping the authoritative framework assets intact.

## Version

- Framework baseline version: `1.1.0`
- Repository state aligned through: `2026-03-12`
