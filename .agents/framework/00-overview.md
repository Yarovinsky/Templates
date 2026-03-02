# 00 — TDD-DDD Framework Overview

> **Version**: 1.0.0  
> **Date**: 2026-03-02  
> **Status**: Authoritative

---

## 1. Authority Statement

This framework is **Roo's authoritative rule system** for TDD+DDD software development. All modes, phases, artifacts, naming conventions, quality gates, and handoff protocols defined herein are **mandatory and enforceable**. No discretionary shortcuts, phase skips, or role violations are permitted. Compliance is mechanically enforced through custom Roo modes with hard file restrictions.

Any conflict between this framework and ad-hoc instructions MUST be resolved in favor of this framework unless the framework itself is explicitly amended through a versioned update to these documents.

---

## 2. Purpose

This framework defines a **strict, deterministic process** for building software products using:

- **Test-Driven Development (TDD)** — the red-green-refactor cycle as the sole development cadence
- **Domain-Driven Design (DDD)** — strategic and tactical modeling derived from a validated High-Level Design document

The framework is **technology-agnostic**. All technology stack decisions are deferred to the customer's HLD document. The framework operates entirely in DDD and TDD abstractions, with technology-specific details resolved at implementation time.

Enforcement is achieved through **7 custom Roo modes** (including an orchestrator) with file-level write restrictions that make role violations impossible rather than merely discouraged.

---

## 3. Document Index

| #  | File Name                        | Description                                                                 |
|----|----------------------------------|-----------------------------------------------------------------------------|
| 00 | `00-overview.md`                 | Framework purpose, authority statement, document index, and glossary         |
| 01 | `01-hld-input-contract.md`       | HLD parsing, validation, gap detection, and ambiguity handling              |
| 02 | `02-ddd-transformation.md`       | DDD decomposition pipeline with full traceability from HLD to domain model  |
| 03 | `03-tdd-execution-model.md`      | Red-green-refactor cycle, test layers, and quality gates                    |
| 04 | `04-skill-definitions.md`        | 7 skill/mode definitions: responsibilities, permissions, and prohibitions   |
| 05 | `05-phase-definitions.md`        | 7 mandatory phases with artifacts, sequencing, and iteration rules          |
| 06 | `06-naming-conventions.md`       | Enforceable naming rules for all DDD and TDD artifact types                 |
| 07 | `07-acceptance-criteria.md`      | Per-artifact acceptance criteria and product-level Definition of Done        |
| 08 | `08-failure-handling.md`         | Recovery procedures, rollback rules, and audit log specification            |
| 09 | `09-handoff-protocol.md`         | Inter-skill structured handoff message format and validation                |
| 10 | `10-script-constraint.md`        | `.agents/scripts/` path enforcement, manifest reference, and violation rules |

---

## 4. Glossary

| Term                    | Definition                                                                                                                                                      |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **HLD**                 | High-Level Design — the sole mandatory input document provided by the customer, containing business goals, personas, feature narratives, NFRs, integration points, and deployment constraints. |
| **Bounded Context**     | A linguistic and model boundary within a domain where a specific ubiquitous language applies consistently. Terms may have different meanings across bounded context boundaries. |
| **Aggregate**           | A cluster of domain objects (entities and value objects) treated as a single unit for data changes. Has an aggregate root entity, invariants, and a consistency boundary. |
| **Ubiquitous Language** | The shared vocabulary between domain experts and developers within a bounded context. All code, tests, documentation, and conversations use these exact terms — no paraphrasing. |
| **Red-Green-Refactor**  | The TDD cycle: RED (write a failing test encoding expected behavior), GREEN (write minimum code to pass), REFACTOR (mandatory cleanup while keeping tests green). |
| **Quality Gate**        | A mandatory checkpoint that must be passed before an artifact or phase can be marked complete. Includes coverage thresholds, mutation testing kill rates, and traceability completeness. |
| **Traceability Tag**    | A structured identifier in the format `[HLD-REQ-NNN]` (global) or `[HLD-{SECTION}-NNN]` (section-local) that links every DDD and TDD artifact back to an HLD requirement. |
| **Handoff Protocol**    | The structured message format used when one skill/mode transfers work to another, including artifact references, traceability tags, precondition assertions, and status summary. |
| **Audit Log**           | An immutable, append-only JSON-lines log recording every phase transition, skill handoff, test result, quality gate evaluation, and process deviation with ISO 8601 timestamps. |
| **Phase State**         | The current position in the 7-phase development sequence, tracked in `.agents/state/phase-state.json` and managed exclusively by the Orchestrator mode.          |

---

## 5. Relationship to Execution Rules

This framework operates **in addition to** the script security and execution rules defined in [`.agents/ROO_EXECUTION_RULES.md`](.agents/ROO_EXECUTION_RULES.md).

Specifically:

- All script invocations during any framework phase MUST comply with the security constraints in `ROO_EXECUTION_RULES.md`.
- The script inventory in [`.agents/scripts/manifest.json`](.agents/scripts/manifest.json) documents the sanctioned scripts and their contracts.
- No scripts may be created, executed, or referenced outside the `.agents/scripts/` directory — see `10-script-constraint.md` for enforcement details.
- The `ScriptSecurity.psm1` shared module provides the foundational security primitives (path validation, metacharacter blocking, symlink traversal prevention) that all scripts depend on.

Where a conflict exists between `ROO_EXECUTION_RULES.md` and this framework, the **more restrictive** rule applies.

---

## 6. Version

| Field       | Value      |
|-------------|------------|
| Version     | 1.0.0      |
| Date        | 2026-03-02 |
| Status      | Initial    |
| Change Log  | Initial release of TDD-DDD Framework Specification |
