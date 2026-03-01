[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateNotNullOrEmpty()]
  [string] $Subcommand,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $DockerArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "ScriptSecurity.psm1") -Force

function Test-IsWindowsAbsolutePath {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  if ($Value -match '^[a-zA-Z]:[\\/]') { return $true }
  if ($Value -match '^(\\\\|//)') { return $true }
  return $false
}

function Assert-AllowedDockerHostPath {
  param([string]$Host)

  if ([string]::IsNullOrWhiteSpace($Host)) { Fail "Volume source/host path is required" }

  if ([System.IO.Path]::IsPathRooted($Host) -or (Test-IsWindowsAbsolutePath $Host)) {
    Fail "Docker host path must be relative and inside repo: $Host"
  }

  Assert-RelativeRepoPath $Host | Out-Null
}

function Get-HostFromShortVolumeSpec {
  param([string]$Spec)

  if ([string]::IsNullOrWhiteSpace($Spec)) { return $null }

  if ($Spec -match '^[a-zA-Z]:[\\/]') {
    $separator = $Spec.IndexOf(':', 2)
    if ($separator -lt 0) { Fail "Invalid volume spec: $Spec" }
    return $Spec.Substring(0, $separator)
  }

  if ($Spec -match '^(\\\\|//)') {
    $separator = $Spec.IndexOf(':', 2)
    if ($separator -lt 0) { Fail "Invalid volume spec: $Spec" }
    return $Spec.Substring(0, $separator)
  }

  $firstColon = $Spec.IndexOf(':')
  if ($firstColon -lt 0) {
    return $Spec
  }

  return $Spec.Substring(0, $firstColon)
}

function Validate-ShortVolumeSpec {
  param([string]$Spec)

  $host = Get-HostFromShortVolumeSpec -Spec $Spec
  if ([string]::IsNullOrWhiteSpace($host)) { return }

  # Named volume, allow without restriction.
  if ($host -match '^[A-Za-z0-9][A-Za-z0-9_.-]*$') {
    return
  }

  Assert-AllowedDockerHostPath -Host $host
}

function Parse-MountOptions {
  param([string]$Spec)

  $map = @{}
  if ([string]::IsNullOrWhiteSpace($Spec)) { return $map }

  foreach ($pair in ($Spec -split ',')) {
    if ([string]::IsNullOrWhiteSpace($pair)) { continue }

    $parts = $pair.Split('=', 2)
    $key = $parts[0].Trim().ToLowerInvariant()
    $value = if ($parts.Length -eq 2) { $parts[1].Trim() } else { "" }

    if (-not [string]::IsNullOrWhiteSpace($key)) {
      $map[$key] = $value
    }
  }

  return $map
}

function Validate-MountSpec {
  param([string]$Spec)

  $opts = Parse-MountOptions -Spec $Spec

  $mountType = ""
  if ($opts.ContainsKey("type")) {
    $mountType = $opts["type"].ToLowerInvariant()
  }

  $source = $null
  if ($opts.ContainsKey("source")) { $source = $opts["source"] }
  if (-not $source -and $opts.ContainsKey("src")) { $source = $opts["src"] }

  if ([string]::IsNullOrWhiteSpace($source)) { return }

  if ($mountType -eq "bind") {
    Assert-AllowedDockerHostPath -Host $source
    return
  }

  if ($mountType -eq "volume") {
    return
  }

  # Unknown/omitted type: validate only path-looking sources, allow plain volume names.
  if ($source -match '[\\/]' -or $source.StartsWith('.')) {
    Assert-AllowedDockerHostPath -Host $source
    return
  }

  if ([System.IO.Path]::IsPathRooted($source) -or (Test-IsWindowsAbsolutePath $source)) {
    Fail "Docker source path must be relative and inside repo: $source"
  }
}

function Validate-DockerArgs {
  param([string[]]$Args)

  Assert-NoShellMetachars $Args

  for ($i = 0; $i -lt $Args.Length; $i++) {
    $a = $Args[$i]

    if ($a -in @("-f", "--file", "--env-file")) {
      if ($i + 1 -ge $Args.Length) { Fail "Missing value after $a" }
      Assert-RelativeRepoPath $Args[$i + 1] | Out-Null
      $i++
      continue
    }

    if ($a -match '^(--file|--env-file)=(.+)$') {
      Assert-RelativeRepoPath $Matches[2] | Out-Null
      continue
    }

    if ($a -in @("-v", "--volume")) {
      if ($i + 1 -ge $Args.Length) { Fail "Missing value after $a" }
      Validate-ShortVolumeSpec -Spec $Args[$i + 1]
      $i++
      continue
    }

    if ($a -match '^--volume=(.+)$') {
      Validate-ShortVolumeSpec -Spec $Matches[1]
      continue
    }

    if ($a -eq "--mount") {
      if ($i + 1 -ge $Args.Length) { Fail "Missing value after --mount" }
      Validate-MountSpec -Spec $Args[$i + 1]
      $i++
      continue
    }

    if ($a -match '^--mount=(.+)$') {
      Validate-MountSpec -Spec $Matches[1]
      continue
    }
  }
}

Validate-DockerArgs $DockerArgs

Write-Host ">> docker $Subcommand $($DockerArgs -join ' ')"
& docker $Subcommand @DockerArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
