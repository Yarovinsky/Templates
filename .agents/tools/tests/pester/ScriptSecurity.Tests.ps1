Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Contract.Helpers.ps1")
Import-Module (Join-Path $PSScriptRoot "..\..\lib\ScriptSecurity.psm1") -Force

Describe "ScriptSecurity" {
  BeforeAll {
    $repo = Join-Path $env:TEMP ("agents-tests-" + [guid]::NewGuid().ToString("N"))
    New-AgentsTestRepo -Root $repo
    $env:AGENTS_REPO_ROOT = $repo
  }

  AfterAll {
    Remove-Item Env:AGENTS_REPO_ROOT -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $repo -Recurse -Force -ErrorAction SilentlyContinue
  }

  It "resolves repo root from AGENTS_REPO_ROOT instead of current directory" {
    Push-Location (Join-Path $repo "src")
    try {
      (Get-RepoRoot) | Should -Be $repo
    }
    finally {
      Pop-Location
    }
  }

  It "rejects parent traversal" {
    { Resolve-RepoPath "..\outside.txt" } | Should -Throw
  }

  It "rejects absolute paths" {
    { Resolve-RepoPath "C:\temp\x.txt" } | Should -Throw
  }
}
