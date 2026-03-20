Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Contract.Helpers.ps1")

Describe "docker wrapper validation" {
  BeforeAll {
    $repo = Join-Path $env:TEMP ("agents-tests-" + [guid]::NewGuid().ToString("N"))
    New-AgentsTestRepo -Root $repo
    $env:AGENTS_REPO_ROOT = $repo
    $script = Join-Path $PSScriptRoot "..\..\pwsh\docker.ps1"
  }

  AfterAll {
    Remove-Item Env:AGENTS_REPO_ROOT -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $repo -Recurse -Force -ErrorAction SilentlyContinue
  }

  It "rejects absolute bind mounts" {
    { & $script run -v C:\temp:/data alpine } | Should -Throw
  }

  It "rejects remote build contexts" {
    { & $script build https://example.com/context.tar.gz } | Should -Throw
  }
}
