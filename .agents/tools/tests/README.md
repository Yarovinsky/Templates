# Tests

These Pester tests are intended as contract tests for the wrapper surface.
Run them locally after unpacking, for example from PowerShell:

```powershell
Invoke-Pester .agents/tools/tests/pester
```

Recommended next step: add a CI job that runs these tests on every change to `.agents/tools/`.
