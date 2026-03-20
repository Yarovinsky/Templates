# Roo Adapter Rules

This file maps Roo usage onto the generic `.agents` tool surface.
Generic policy remains in `.agents/policy/EXECUTION_RULES.md`.

## Use these entry points

Preferred:

- `.agents/scripts/dotnet.cmd`
- `.agents/scripts/docker.cmd`
- `.agents/scripts/git.cmd`
- `.agents/scripts/curl.cmd`
- `.agents/scripts/repo.cmd`

These are compatibility shims that forward to the canonical implementations in `.agents/tools/`.

## Do not do this

- do not invoke raw `dotnet`, `git`, `docker`, `curl`, `powershell`, or `cmd`
- do not bypass wrappers with shell chaining
- do not reinterpret generic policy locally; follow it exactly

## Suggested Roo phrasing

Before executing any repository command, use the approved `.agents/scripts/*.cmd` wrappers only.
If a capability is missing, extend a wrapper or add a new wrapper under `.agents/tools/`; do not call a raw binary directly.
