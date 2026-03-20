# Roo adapter

This directory contains Roo-specific guidance layered on top of the generic `.agents` framework.

## Recommended Roo startup order

1. Read `AGENTS.md`
2. Read `.agents/framework/00-overview.md`
3. Read `.agents/adapters/roo/ROO_EXECUTION_RULES.md`
4. Read the relevant skill file from `.agents/skills/`

## Wrapper path for Roo

Use `.agents/scripts/*.cmd` for maximum compatibility.
These are thin shims over the canonical implementations in `.agents/tools/`.
