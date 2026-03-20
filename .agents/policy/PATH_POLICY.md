# Path Policy

## Allowed path shape

All user-supplied repo paths must be relative to the repository root.
Examples:

- `src/App/App.csproj`
- `.agents/tools/manifest.json`
- `tests/App.Tests`

## Rejected path shape

Rejected examples:

- `C:\repo\src\App.csproj`
- `/home/user/repo/src/App.csproj`
- `..\outside.txt`
- `src\..\..\outside.txt`

## Reparse points

If any existing path segment between the repo root and the requested target is a symlink or junction, the path is rejected.
This prevents path escape through reparse points.

## Repo root discovery

The repo root is not inferred from the current working directory.
It is discovered from `AGENTS_REPO_ROOT` or by finding the nearest ancestor containing `.agents`.
