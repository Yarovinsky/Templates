# Capability Model

The execution surface is intentionally capability-based rather than shell-based.
Each wrapper exposes a narrow, explicit capability.

## Principles

- prefer bounded verbs over arbitrary command passthrough
- validate repo paths before execution
- separate generic policy from adapter-specific conventions
- design for TDD workflows: fast test loops, targeted reads, explicit edits

## Capabilities

### repo

Repo-local file system capability.
This is the only approved general write surface.

### dotnet

Build, run, restore, and test capability for .NET repositories.
This wrapper is intentionally not a generic `dotnet anything` passthrough.

### git

Version control capability with an allowlist of common development verbs.
Hooks are disabled to avoid arbitrary code execution.

### docker

Container orchestration capability for common local development flows.
Host path access is constrained to repo-local paths.

### curl

Local HTTP probe capability for localhost services.
This is not a general outbound network client.

## Why this matters for TDD

A TDD-friendly agent should be able to:

- read and write source files predictably
- run focused tests safely
- inspect local application endpoints
- build and run the app without escaping the repo sandbox

A TDD-friendly agent should not need:

- arbitrary shell chaining
- unrestricted external network access
- direct execution of hidden hooks or scripts
