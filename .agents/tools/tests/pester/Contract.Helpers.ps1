Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-AgentsTestRepo {
  param([string]$Root)

  if (Test-Path -LiteralPath $Root) {
    Remove-Item -LiteralPath $Root -Recurse -Force
  }

  New-Item -ItemType Directory -Path $Root | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $Root ".agents") | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $Root "src") | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $Root "tests") | Out-Null
}
