# Generic Execution Policy

This document defines the generic execution policy for the `.agents` runtime surface.
It is adapter-neutral and must not contain Roo-specific assumptions.

## Core rule

Agents may execute only the approved wrapper entry points.
Direct invocation of raw binaries, shells, or arbitrary scripts is not allowed.

## Approved tool entry points

Preferred Windows entry points:

- `.agents/tools/bin/windows/dotnet.cmd`
- `.agents/tools/bin/windows/docker.cmd`
- `.agents/tools/bin/windows/git.cmd`
- `.agents/tools/bin/windows/curl.cmd`
- `.agents/tools/bin/windows/repo.cmd`

Compatibility aliases:

- `.agents/scripts/dotnet.cmd`
- `.agents/scripts/docker.cmd`
- `.agents/scripts/git.cmd`
- `.agents/scripts/curl.cmd`
- `.agents/scripts/repo.cmd`

## Repo root

The repository root is resolved in this order:

1. `AGENTS_REPO_ROOT`, if set and valid
2. nearest ancestor directory containing `.agents`
3. nearest ancestor directory containing `.git` and `.agents`

The current working directory is never treated as the source of truth for repo root.

## Global argument restrictions

These restrictions apply to user-supplied wrapper arguments unless a tool document explicitly narrows them further.

Rejected shell metacharacters:

- `` ` ``
- `>`
- `<`
- `&&`
- `||`

Notes:

- single `;`, `|`, and `&` are allowed in argument arrays because wrappers invoke native processes directly rather than through a shell
- tool-specific logic may still reject values containing those symbols when they are unsafe in context

## Global path policy

User-supplied repo paths must:

- be relative
- not contain `..`
- stay within the resolved repo root after normalization
- not traverse symlinks or junctions on any existing segment of the resolved path

## Tool policy overview

### dotnet

Allowed actions:

- `test`
- `run`
- `build`
- `restore`
- `format`
- `sln`
- `help`

Path-bearing flags are validated.
For `test`, `build`, `run`, `restore`, and `format`, positional project or solution paths are validated when path-like.
For `sln`, the solution path and `add` / `remove` project paths are validated.

### docker

Allowed top-level subcommands:

- `build`
- `compose`
- `run`
- `ps`
- `logs`
- `exec`
- `stop`
- `rm`
- `images`
- `pull`
- `help`

Validated values:

- file-bearing flags such as `-f`, `--file`, `--env-file`, `--cidfile`, `--iidfile`, `--metadata-file`
- bind mount host paths in `-v`, `--volume`, and `--mount`
- local build contexts for `docker build`

### git

Allowed top-level subcommands:

- `status`
- `diff`
- `log`
- `show`
- `add`
- `restore`
- `rm`
- `mv`
- `branch`
- `switch`
- `checkout`
- `commit`
- `fetch`
- `pull`
- `push`
- `tag`
- `stash`
- `reset`
- `help`

Extra rules:

- user-supplied `-c` and `--config-env` are rejected
- hooks are disabled through an internal empty hooks path
- `--no-pager` is enforced

### curl

Extra rules:

- only localhost HTTP(S) URLs are allowed
- `-K`, `--config`, proxy flags, and similar escape hatches are rejected
- output files must stay within the repo
- logs should redact credentials and authorization headers

### repo

This is the file-system wrapper for repo-local operations.
Use `write-base64` or `append-base64` for deterministic multi-line content writes.

## Testing expectation

Every wrapper change should come with contract tests that verify:

- path containment
- repo-root resolution
- mount validation
- URL validation
- command allowlists
- compatibility aliases
- no drift between policy and manifest
