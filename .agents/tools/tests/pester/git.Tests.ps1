Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Contract.Helpers.ps1")

Describe "git wrapper validation" {
  BeforeAll {
    $repo = Join-Path $env:TEMP ("agents-tests-" + [guid]::NewGuid().ToString("N"))
    New-AgentsTestRepo -Root $repo
    $env:AGENTS_REPO_ROOT = $repo
    $script = Join-Path $PSScriptRoot "..\..\pwsh\git.ps1"
  }

  AfterAll {
    Remove-Item Env:AGENTS_REPO_ROOT -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $repo -Recurse -Force -ErrorAction SilentlyContinue
  }

  It "rejects git config injection flags" {
    { & $script status -c core.sshCommand=malicious } | Should -Throw
  }
}
