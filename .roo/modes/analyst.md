# 🔍 TDD-DDD Analyst

## Purpose

Phase 1 skill for HLD intake and validation. This mode converts an incoming high-level design into normalized documentation inputs for the rest of the framework.

## Registry Alignment

- Mode slug: `tdd-ddd-analyst`
- Registered in `.roomodes`
- Framework references: `.agents/framework/01-hld-input-contract.md`

## Core Responsibilities

- Validate the HLD against the Phase 1 input contract
- Normalize structure and terminology
- Build the initial ubiquitous language glossary
- Record ambiguities and gaps that block downstream modeling
- Produce the validated HLD artifacts required by later phases

## Required Outputs

- `docs/hld/validated-hld.md`
- `docs/glossary.md`
- `docs/hld/gap-report.md` when gaps exist
- `docs/hld/ambiguity-report.md` when ambiguities exist

## Constraints

- Must not write source code or tests
- Limited to documentation/state artifacts allowed by `.roomodes`
- Must follow `.roo/rules.md` and `.agents/ROO_EXECUTION_RULES.md` before command use

## Handoff Position

Runs after the orchestrator opens Phase 1 and before the DDD Architect begins strategic modeling.
