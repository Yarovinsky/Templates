[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $CurlArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "ScriptSecurity.psm1") -Force

function Assert-LocalhostHttpUrl {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) { Fail "URL must not be empty" }

  $uri = $null
  if (-not [System.Uri]::TryCreate($Value, [System.UriKind]::Absolute, [ref]$uri)) {
    Fail "Invalid absolute URL: $Value"
  }

  $scheme = $uri.Scheme.ToLowerInvariant()
  if ($scheme -ne "http" -and $scheme -ne "https") {
    Fail "Only http/https URLs are allowed. Got: $Value"
  }

  $host = $uri.Host.ToLowerInvariant()
  if ($host -notin @("localhost", "127.0.0.1", "::1")) {
    Fail "Only localhost URLs are allowed. Got: $Value"
  }
}

function Validate-CurlArgs {
  param([string[]]$Args)

  Assert-NoShellMetachars $Args

  foreach ($arg in $Args) {
    if ([string]::IsNullOrWhiteSpace($arg)) { continue }

    if ($arg -match '^[A-Za-z][A-Za-z0-9+.-]*://') {
      Assert-LocalhostHttpUrl $arg
      continue
    }

    if ($arg -match '^--[^=]+=(.+)$') {
      $value = $Matches[1]
      if ($value -match '^[A-Za-z][A-Za-z0-9+.-]*://') {
        Assert-LocalhostHttpUrl $value
      }
      continue
    }
  }
}

Validate-CurlArgs $CurlArgs

Write-Host ">> curl $($CurlArgs -join ' ')"
& curl @CurlArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
