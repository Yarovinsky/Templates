[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("build","compose","run","ps","logs","exec","stop","rm","images","pull","help")]
  [string] $Subcommand,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $DockerArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "..\lib\ScriptSecurity.psm1") -Force

function Assert-AllowedDockerHostPath {
  param([Parameter(Mandatory = $true)][string]$Host)

  if ([string]::IsNullOrWhiteSpace($Host)) { Fail "Docker host path is required" }
  if ([System.IO.Path]::IsPathRooted($Host) -or (Test-IsWindowsAbsolutePath $Host)) {
    Fail "Docker host path must be relative and inside the repo: $Host"
  }

  [void](Assert-RelativeRepoPath $Host)
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
  if ($firstColon -lt 0) { return $Spec }
  return $Spec.Substring(0, $firstColon)
}

function Validate-ShortVolumeSpec {
  param([Parameter(Mandatory = $true)][string]$Spec)

  $host = Get-HostFromShortVolumeSpec -Spec $Spec
  if ([string]::IsNullOrWhiteSpace($host)) { return }

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
  param([Parameter(Mandatory = $true)][string]$Spec)

  $opts = Parse-MountOptions -Spec $Spec
  $mountType = if ($opts.ContainsKey("type")) { $opts["type"].ToLowerInvariant() } else { "" }
  $source = $null
  if ($opts.ContainsKey("source")) { $source = $opts["source"] }
  if (-not $source -and $opts.ContainsKey("src")) { $source = $opts["src"] }

  if ([string]::IsNullOrWhiteSpace($source)) { return }

  if ($mountType -eq "volume") { return }
  if ($mountType -eq "bind") {
    Assert-AllowedDockerHostPath -Host $source
    return
  }

  if ($source -match '[\\/]' -or $source.StartsWith('.')) {
    Assert-AllowedDockerHostPath -Host $source
    return
  }

  if ([System.IO.Path]::IsPathRooted($source) -or (Test-IsWindowsAbsolutePath $source)) {
    Fail "Docker source path must be relative and inside the repo: $source"
  }
}

function Test-PathLikeToken {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  if ($Value -eq "." -or $Value -eq "-") { return $true }
  if ($Value -match '^[A-Za-z][A-Za-z0-9+.-]*://') { return $false }
  if ($Value -match '[\\/]') { return $true }
  return $false
}

function Validate-DockerArgs {
  param([string]$Verb, [string[]]$Arguments)

  if ($null -eq $Arguments) { return }
  Assert-NoShellMetachars $Arguments

  $pathFlags = @("-f","--file","--env-file","--cidfile","--iidfile","--metadata-file")

  for ($i = 0; $i -lt $Arguments.Length; $i++) {
    $a = $Arguments[$i]
    $handled = $false

    foreach ($pf in $pathFlags) {
      if ($a.Equals($pf, [System.StringComparison]::OrdinalIgnoreCase)) {
        if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after $a" }
        [void](Assert-RelativeRepoPath $Arguments[$i + 1])
        $i++
        $handled = $true
        break
      }

      if ($a.StartsWith("$pf=", [System.StringComparison]::OrdinalIgnoreCase)) {
        [void](Assert-RelativeRepoPath $a.Substring($pf.Length + 1))
        $handled = $true
        break
      }
    }

    if ($handled) { continue }

    if ($a -in @("-v", "--volume")) {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after $a" }
      Validate-ShortVolumeSpec -Spec $Arguments[$i + 1]
      $i++
      continue
    }

    if ($a -match '^--volume=(.+)$') {
      Validate-ShortVolumeSpec -Spec $Matches[1]
      continue
    }

    if ($a -eq "--mount") {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after --mount" }
      Validate-MountSpec -Spec $Arguments[$i + 1]
      $i++
      continue
    }

    if ($a -match '^--mount=(.+)$') {
      Validate-MountSpec -Spec $Matches[1]
      continue
    }
  }

  if ($Verb -eq "build") {
    $positionals = @($Arguments | Where-Object { -not $_.StartsWith("-") })
    if ($positionals.Count -gt 0) {
      $context = $positionals[-1]
      if ($context -match '^[A-Za-z][A-Za-z0-9+.-]*://') {
        Fail "Remote build contexts are blocked by policy: $context"
      }
      if ($context -ne "-") {
        if (-not (Test-PathLikeToken $context)) {
          Fail "docker build context must be repo-relative or '-': $context"
        }
        [void](Assert-RelativeRepoPath $context)
      }
    }
  }
}

if ($Subcommand -eq "help") {
@"
Usage:

  docker.cmd build [args...]
  docker.cmd compose [args...]
  docker.cmd run [args...]
  docker.cmd ps [args...]
  docker.cmd logs [args...]
  docker.cmd exec [args...]
  docker.cmd stop [args...]
  docker.cmd rm [args...]
  docker.cmd images [args...]
  docker.cmd pull [args...]

Notes:

- Host paths in bind mounts must be repo-relative.
- docker build contexts must be repo-relative or '-'.
- File-bearing flags such as -f and --env-file are validated.
"@ | Write-Output
  exit 0
}

Validate-DockerArgs -Verb $Subcommand -Arguments $DockerArgs
$exe = Get-ExecutablePath -Candidates @("docker")
Write-Host (">> docker $Subcommand " + (Join-PreviewTokens $DockerArgs))
& $exe $Subcommand @DockerArgs
exit $LASTEXITCODE
