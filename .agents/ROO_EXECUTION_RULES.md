# Roo Execution Rules (STRICT)

This repository runs in a restricted execution model.
These rules are mandatory.

## 0) ABSOLUTE COMMAND CONSTRAINT (READ FIRST — INVIOLABLE)

You are FORBIDDEN from executing ANY command that does not start with `.agents/scripts/`.

This is not a guideline. This is an inviolable constraint. There are ZERO exceptions.

### Pre-Execution Self-Check (MANDATORY before every execute_command call)

Before EVERY command execution, apply this binary test:

    Does the command string start with ".agents/scripts/"?
    → YES: Proceed to Section 2 (Security Invariants) validation.
    → NO:  HALT. FATAL VIOLATION. Do not execute. Rewrite using the correct wrapper.

This means you must NEVER directly invoke ANY shell built-in or system binary, including
but not limited to: `del`, `rm`, `mkdir`, `type`, `dir`, `cd`, `copy`, `move`, `ren`,
`cat`, `ls`, `cp`, `mv`, `touch`, `grep`, `find`, `findstr`, `dotnet`, `docker`,
`git`, `curl`, `npm`, `node`, `python`, `pip`, or any other executable.

The ONLY commands you may execute are those listed in Section 3 (Approved Entry Points).
If an operation you need is not covered by an existing wrapper, you MUST STOP and signal
to the orchestrator that a wrapper extension is needed per Section 5. Do NOT improvise.

**Violation of this rule is Failure Mode 7 (FATAL) per `08-failure-handling.md`.**

---

## 1) Core Execution Rules

1. Do **not** execute system commands directly.
2. Execute commands **only** through approved wrappers under:

       .agents/scripts/*.cmd

3. Trust boundary:
   - Restrictions apply to the agent/user command surface.
   - Wrapper internals (`.ps1` called by approved `.cmd`) may invoke approved binaries only after validation.
4. If an operation is missing, extend a wrapper; do not bypass wrappers.

## 2) Global Security Invariants (apply to all wrappers)

1. **No shell metacharacters** in arguments:
   - `|`, `;`, `&`, `` ` ``, `>`, `<`, `&&`, `||`
2. **No path escaping** on validated path args:
   - must be relative
   - no `..`
   - must resolve inside repo root
   - must not traverse symlink/junction/reparse-point escapes
3. **No direct executables**:
   - never invoke binaries directly; use wrappers only
4. **No pipe workarounds**:
   - use wrapper parameters for filtering/last-lines behavior
5. **Flag-form parity**:
   - wrappers must validate both `--flag value` and `--flag=value` when path-bearing flags exist

## 3) Approved Entry Points

Use only:

    .agents/scripts/dotnet.cmd
    .agents/scripts/docker.cmd
    .agents/scripts/git.cmd
    .agents/scripts/curl.cmd
    .agents/scripts/repo.cmd

## 4) Wrapper Contracts

### 4.1 dotnet.cmd

Script: `.agents/scripts/dotnet.cmd`

Syntax:

    .agents/scripts/dotnet.cmd <Action> [dotnet args...] [-MatchPattern <regex>] [-LastLines <N>]

- `Action` (required): `test`, `run`, `build`, `restore`, `format`, `help`
- Path-bearing flags validated as repo-relative:
  - `--project`, `--solution`, `--startup-project`, `--results-directory`, `--output`, `-o`
- Output controls:
  - `-MatchPattern` (regex filter)
  - `-LastLines` (tail N lines)

Examples:

    .agents/scripts/dotnet.cmd test --no-build --filter "FullyQualifiedName~MyTests"
    .agents/scripts/dotnet.cmd test -MatchPattern "failed" -LastLines 50

### 4.2 git.cmd

Script: `.agents/scripts/git.cmd`

Syntax:

    .agents/scripts/git.cmd <Subcommand> [git args...]

- Any git subcommand is allowed.
- Path-bearing flags validated as repo-relative:
  - `-C <path>`
  - `--git-dir <path>`, `--git-dir=<path>`
  - `--work-tree <path>`, `--work-tree=<path>`

Examples:

    .agents/scripts/git.cmd status
    .agents/scripts/git.cmd diff HEAD~1

### 4.3 docker.cmd

Script: `.agents/scripts/docker.cmd`

Syntax:

    .agents/scripts/docker.cmd <Subcommand> [docker args...]

- Any docker subcommand is allowed.
- File flags validated as repo-relative:
  - `-f <path>`, `--file <path>`, `--file=<path>`
  - `--env-file <path>`, `--env-file=<path>`
- Mount constraints:
  - `-v`, `--volume`, `--volume=`: bind host paths must be relative and inside repo
  - `--mount`, `--mount=`: `type=bind` sources must be relative and inside repo
  - Windows absolute host paths are rejected (`C:\...`, `\\server\share\...`)
  - named volumes are allowed

Examples:

    .agents/scripts/docker.cmd compose up --build -d
    .agents/scripts/docker.cmd compose -f docker-compose.dev.yml up -d

### 4.4 curl.cmd

Script: `.agents/scripts/curl.cmd`

Syntax:

    .agents/scripts/curl.cmd [curl args...]

- All URL targets must be localhost only:
  - `localhost`, `127.0.0.1`, `::1`
  - `http` / `https` only

Example:

    .agents/scripts/curl.cmd http://localhost:5000/health

### 4.5 repo.cmd

Script: `.agents/scripts/repo.cmd`

Syntax:

    .agents/scripts/repo.cmd <Action> [args...]

Allowed actions:

| Action | Contract |
|---|---|
| `ls` | `ls <path> [-Recurse] [-Depth N]` |
| `cat` | `cat <path>` |
| `write` | `write <path> -- <text...>` |
| `append` | `append <path> -- <text...>` |
| `mkdir` | `mkdir <path>` |
| `rm` | `rm <path> [-Recurse] [-Force]` |
| `mv` | `mv <src> <dst>` |
| `cp` | `cp <src> <dst> [-Recurse]` |
| `grep` | `grep <pattern> <path> [-Recurse]` |
| `touch` | `touch <path>` |
| `help` | `help` |

Path policy for all file-system actions:
- relative only
- no absolute paths
- no `..`
- no resolution outside repo root

Examples:

    .agents/scripts/repo.cmd ls src -Recurse -Depth 2
    .agents/scripts/repo.cmd cat src/Program.cs
    .agents/scripts/repo.cmd grep "TODO" src -Recurse

## 5) Extension Rules

If functionality is missing:
1. modify the relevant `.ps1` wrapper
2. add validated parameters/subcommands
3. preserve all security invariants
4. do not add ad-hoc direct-exec paths

## 6) Validation Requirements for Wrapper Changes

Required negative checks:
- metacharacter rejection
- path escape rejection (absolute, `..`, reparse-point traversal)
- `--flag value` and `--flag=value` parity
- non-localhost URL rejection in `curl.cmd`
- absolute/drive-letter/UNC bind source rejection in `docker.cmd`
- invalid bind source rejection in `--mount`

Required positive checks:
- valid relative repo-internal paths accepted
- named docker volumes accepted
- localhost HTTP/HTTPS URLs accepted

## 7) Non-Compliance

Using forbidden command paths or bypassing wrappers is a policy violation.

### 7.1) Mode File Restriction Bypass Prohibition (INVIOLABLE)

Mode-level file restrictions (defined in `.roomodes` `fileRegex` patterns) apply to ALL file operations,
regardless of mechanism. This means:

- If a mode's `fileRegex` does not permit writing to `src/`, then that mode MUST NOT create, modify,
  or write files under `src/` using `repo.cmd write`, `repo.cmd mkdir`, `repo.cmd touch`, `repo.cmd cp`,
  `repo.cmd mv`, or any other wrapper command.
- The `execute_command` tool does NOT exempt a mode from its file restrictions.
- Wrappers are for executing approved operations within the mode's permitted scope, not for
  circumventing mode boundaries.
- **Violation of this rule is Failure Mode 7 (FATAL) per `08-failure-handling.md`.**

Example: The Test Author mode (`test-author`) may write to `tests/`, `docs/`, `.agents/state/`, and may
create project scaffolding under `src/` (solution files, project files, empty stub classes with no
implementation). However, using `repo.cmd write src/MyClass.cs` to write a file containing method bodies
or implementation logic is a FATAL violation — stubs must contain only namespace + empty type declarations.

Example: The Validator mode (`validator`) may only write to `docs/` and `.agents/state/`.
Using `repo.cmd write src/...` or `repo.cmd write tests/...` from the Validator mode is a FATAL violation.

## 8) TDD-DDD Framework Cross-Reference

This execution rules document governs script security and command execution.
For the complete TDD-DDD development framework — including phase definitions,
skill roles, handoff protocols, quality gates, and naming conventions — see:

    .agents/framework/

The framework specification documents (00 through 10) define the authoritative
process rules for building software using Test-Driven Development and
Domain-Driven Design. The framework index is at:

    .agents/framework/00-overview.md

Key integration points:

1. **Script constraint**: The framework enforces that all scripts must reside
   under `.agents/scripts/` (see `.agents/framework/10-script-constraint.md`).
   This aligns with and extends Section 2 (Approved Entry Points) of this document.

2. **Skill modes**: Custom Roo modes defined in `.roomodes` enforce file-level
   access restrictions per skill role. See `.agents/framework/04-skill-definitions.md`.

3. **Validation**: The Validator skill uses approved wrappers from Section 4
   to execute test suites and generate reports.

Both this document and the framework are mandatory and complementary.
In case of conflict, the more restrictive rule applies.
