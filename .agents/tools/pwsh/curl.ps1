[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $CurlArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "..\lib\ScriptSecurity.psm1") -Force

function Assert-LocalhostHttpUrl {
  param([Parameter(Mandatory = $true)][string]$Value)

  $uri = $null
  if (-not [System.Uri]::TryCreate($Value, [System.UriKind]::Absolute, [ref]$uri)) {
    Fail "Invalid absolute URL: $Value"
  }

  if ($uri.Scheme -notin @("http", "https")) {
    Fail "Only http/https URLs are allowed. Got: $Value"
  }

  if ($uri.Host.ToLowerInvariant() -notin @("localhost", "127.0.0.1", "::1")) {
    Fail "Only localhost URLs are allowed. Got: $Value"
  }
}

function Get-RedactedCurlArgs {
  param([string[]]$Arguments)

  $result = New-Object System.Collections.Generic.List[string]

  for ($i = 0; $i -lt $Arguments.Length; $i++) {
    $a = $Arguments[$i]

    if ($a -in @("-u", "--user", "--oauth2-bearer")) {
      $result.Add($a) | Out-Null
      if ($i + 1 -lt $Arguments.Length) {
        $result.Add("***") | Out-Null
        $i++
      }
      continue
    }

    if ($a -match '^(--user|--oauth2-bearer)=(.+)$') {
      $result.Add(($Matches[1] + "=***")) | Out-Null
      continue
    }

    if ($a -in @("-H", "--header")) {
      $result.Add($a) | Out-Null
      if ($i + 1 -lt $Arguments.Length) {
        $value = $Arguments[$i + 1]
        if ($value -match '^(Authorization|Cookie):') {
          $result.Add("***") | Out-Null
        } else {
          $result.Add($value) | Out-Null
        }
        $i++
      }
      continue
    }

    if ($a -match '^(--header)=(.+)$') {
      if ($Matches[2] -match '^(Authorization|Cookie):') {
        $result.Add("--header=***") | Out-Null
      } else {
        $result.Add($a) | Out-Null
      }
      continue
    }

    $result.Add($a) | Out-Null
  }

  return $result.ToArray()
}

function Validate-CurlArgs {
  param([string[]]$Arguments)

  if ($null -eq $Arguments) { return }
  Assert-NoShellMetachars $Arguments

  $blocked = @("-K", "--config", "--proxy", "--preproxy", "--connect-to", "--resolve", "--libcurl")

  for ($i = 0; $i -lt $Arguments.Length; $i++) {
    $a = $Arguments[$i]

    foreach ($flag in $blocked) {
      if ($a.Equals($flag, [System.StringComparison]::OrdinalIgnoreCase) -or $a.StartsWith("$flag=", [System.StringComparison]::OrdinalIgnoreCase)) {
        Fail "curl flag is blocked by policy: $a"
      }
    }

    if ($a -match '^[A-Za-z][A-Za-z0-9+.-]*://') {
      Assert-LocalhostHttpUrl $a
      continue
    }

    if ($a -eq "--url") {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after --url" }
      Assert-LocalhostHttpUrl $Arguments[$i + 1]
      $i++
      continue
    }

    if ($a -match '^--url=(.+)$') {
      Assert-LocalhostHttpUrl $Matches[1]
      continue
    }

    if ($a -in @("-o", "--output")) {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after $a" }
      [void](Assert-RelativeRepoPath $Arguments[$i + 1])
      $i++
      continue
    }

    if ($a -match '^(--output)=(.+)$') {
      [void](Assert-RelativeRepoPath $Matches[2])
      continue
    }
  }
}

Validate-CurlArgs $CurlArgs
$exe = Get-ExecutablePath -Candidates @("curl.exe", "curl")
$preview = Get-RedactedCurlArgs $CurlArgs
Write-Host (">> curl " + (Join-PreviewTokens $preview))
& $exe @CurlArgs
exit $LASTEXITCODE
