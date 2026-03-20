Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Contract.Helpers.ps1")

Describe "repo wrapper" {
  BeforeAll {
    $repo = Join-Path $env:TEMP ("agents-tests-" + [guid]::NewGuid().ToString("N"))
    New-AgentsTestRepo -Root $repo
    $env:AGENTS_REPO_ROOT = $repo
    $script = Join-Path $PSScriptRoot "..\..\pwsh\repo.ps1"
  }

  AfterAll {
    Remove-Item Env:AGENTS_REPO_ROOT -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $repo -Recurse -Force -ErrorAction SilentlyContinue
  }

  It "supports multi-line writes through write-base64" {
    $content = "line1`nline2`n"
    $payload = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($content))
    & $script write-base64 src/demo.txt -- $payload
    Get-Content -LiteralPath (Join-Path $repo "src\demo.txt") -Raw | Should -Be $content
  }

  It "keeps ls output repo-relative" {
    New-Item -ItemType File -Path (Join-Path $repo "src\demo.txt") -Force | Out-Null
    $output = & $script ls src
    $output | Should -Contain "src/demo.txt"
  }
}
