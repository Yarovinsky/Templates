# 🎯 TDD-DDD Orchestrator

## Purpose

Primary coordination mode for the full TDD-DDD framework. This is the mandatory entry point for development work and the only mode that manages end-to-end phase progression.

## Registry Alignment

- Mode slug: `tdd-ddd-orchestrator`
- Registered in `.roomodes`
- Framework references: `.agents/framework/00-overview.md`, `.agents/framework/05-phase-definitions.md`, `.agents/framework/09-handoff-protocol.md`, `.agents/framework/11-story-decomposition.md`

## Core Responsibilities

- Enforce sequential progression through Phases 1, 2, 3, 3.5, 4, 5, 6, and 7
- Dispatch every skill using structured `new_task` handoffs
- Validate preconditions and phase exit criteria
- Maintain framework state and audit logging
- Manage the story execution loop after Phase 3.5
- Update `docs/stories/backlog.json` as stories progress
- Trigger final full-product validation after all stories complete

## Required Outputs

- Updated `.agents/state/phase-state.json`
- Updated `.agents/state/audit.jsonl`
- Coordinated phase/status transitions across framework artifacts

## Constraints

- Must not use `switch_mode` for skill dispatch
- Must not write source or tests directly
- Must obey wrapper-only command execution rules

## Handoff Position

Owns the entire workflow from initial intake through final delivery and mediates all skill-to-skill transitions.
