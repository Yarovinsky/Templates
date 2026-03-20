Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Contract.Helpers.ps1")

Describe "curl wrapper validation" {
  BeforeAll {
    $repo = Join-Path $env:TEMP ("agents-tests-" + [guid]::NewGuid().ToString("N"))
    New-AgentsTestRepo -Root $repo
    $env:AGENTS_REPO_ROOT = $repo
    $script = Join-Path $PSScriptRoot "..\..\pwsh\curl.ps1"
  }

  AfterAll {
    Remove-Item Env:AGENTS_REPO_ROOT -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $repo -Recurse -Force -ErrorAction SilentlyContinue
  }

  It "rejects non-localhost URLs" {
    { & $script --url https://example.com } | Should -Throw
  }

  It "rejects curl config files" {
    { & $script --config curl.txt } | Should -Throw
  }
}
