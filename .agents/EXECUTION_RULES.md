# Execution Rules

Canonical policy lives in `.agents/policy/EXECUTION_RULES.md`.
This compatibility copy exists because some agent setups still look for `.agents/EXECUTION_RULES.md` by convention.

## Mandatory rule

The agent must not invoke `powershell`, `cmd`, `dotnet`, `git`, `docker`, `curl`, or any other executable directly.
The agent may invoke only the approved wrapper entry points described below.

## Approved entry points

Preferred:

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

## Safety model

- all repo paths must be relative and stay inside the repository root
- the repository root is discovered from the `.agents` marker or `AGENTS_REPO_ROOT`
- path traversal through `..`, absolute paths, symlinks, and junctions is rejected
- user-supplied shell metacharacters `` ` ``, `>`, `<`, `&&`, and `||` are rejected
- tool-specific policies may impose stricter rules than this global baseline

## Tools

### dotnet

Allowed actions:

- `test`
- `run`
- `build`
- `restore`
- `format`
- `sln`
- `help`

Not allowed:

- `tool`
- direct arbitrary `dotnet` verbs outside the allowlist

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

### curl

- only `http://` and `https://` URLs are allowed
- only `localhost`, `127.0.0.1`, and `::1` are allowed as hosts
- config and proxy escape hatches are blocked
- output paths must stay inside the repo

### repo

Allowed actions:

- `ls`
- `cat`
- `write`
- `append`
- `write-base64`
- `append-base64`
- `mkdir`
- `rm`
- `mv`
- `cp`
- `grep`
- `touch`
- `help`

Use `write-base64` / `append-base64` for multi-line or code-heavy content.

## Output discipline

The agent should prefer small, targeted reads and writes:

- use `repo cat` for direct file reads
- use `repo grep` to narrow search scope before reading many files
- use `dotnet test` with selective filters when possible
- use `curl` only for local app endpoints

## Adapter-specific docs

Roo-specific instructions live in `.agents/adapters/roo/ROO_EXECUTION_RULES.md`.
