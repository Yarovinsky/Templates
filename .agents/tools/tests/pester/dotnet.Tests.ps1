Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Contract.Helpers.ps1")

Describe "dotnet wrapper validation" {
  BeforeAll {
    $repo = Join-Path $env:TEMP ("agents-tests-" + [guid]::NewGuid().ToString("N"))
    New-AgentsTestRepo -Root $repo
    $env:AGENTS_REPO_ROOT = $repo
    New-Item -ItemType File -Path (Join-Path $repo "tests\App.Tests.csproj") -Force | Out-Null
    $script = Join-Path $PSScriptRoot "..\..\pwsh\dotnet.ps1"
  }

  AfterAll {
    Remove-Item Env:AGENTS_REPO_ROOT -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $repo -Recurse -Force -ErrorAction SilentlyContinue
  }

  It "validates positional test project paths" {
    { & $script test ..\App.Tests.csproj } | Should -Throw
  }
}
