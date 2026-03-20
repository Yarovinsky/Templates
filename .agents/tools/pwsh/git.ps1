[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("status","diff","log","show","add","restore","rm","mv","branch","switch","checkout","commit","fetch","pull","push","tag","stash","reset","help")]
  [string] $Subcommand,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $GitArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "..\lib\ScriptSecurity.psm1") -Force

function Test-ExistingRepoPathToken {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  if ($Value.StartsWith("-")) { return $false }
  if ($Value -eq ".") { return $true }

  try {
    $resolved = Resolve-RepoPath -Path $Value
    return (Test-Path -LiteralPath $resolved)
  }
  catch {
    return $false
  }
}

function Validate-GitArgs {
  param([string]$Verb, [string[]]$Arguments)

  if ($null -eq $Arguments) { return }
  Assert-NoShellMetachars $Arguments

  for ($i = 0; $i -lt $Arguments.Length; $i++) {
    $arg = $Arguments[$i]

    if ($arg -in @("-c", "--config-env", "--exec-path", "--html-path", "--man-path", "--paginate")) {
      Fail "git flag is blocked by policy: $arg"
    }

    if ($arg -eq "-C") {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after -C" }
      [void](Assert-RelativeRepoPath $Arguments[$i + 1])
      $i++
      continue
    }

    if ($arg -in @("--git-dir", "--work-tree")) {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after $arg" }
      [void](Assert-RelativeRepoPath $Arguments[$i + 1])
      $i++
      continue
    }

    if ($arg -match '^(--git-dir|--work-tree)=(.+)$') {
      [void](Assert-RelativeRepoPath $Matches[2])
      continue
    }
  }

  $separatorIndex = [Array]::IndexOf($Arguments, "--")
  if ($separatorIndex -ge 0) {
    for ($j = $separatorIndex + 1; $j -lt $Arguments.Length; $j++) {
      [void](Assert-RelativeRepoPath $Arguments[$j])
    }
    return
  }

  switch ($Verb) {
    "add" {
      foreach ($token in $Arguments) {
        if (Test-ExistingRepoPathToken $token) { [void](Assert-RelativeRepoPath $token) }
      }
    }
    "rm" {
      foreach ($token in $Arguments) {
        if (Test-ExistingRepoPathToken $token) { [void](Assert-RelativeRepoPath $token) }
      }
    }
    "mv" {
      $paths = @($Arguments | Where-Object { -not $_.StartsWith("-") })
      if ($paths.Count -lt 2) { Fail "git mv requires source and destination" }
      [void](Assert-RelativeRepoPath $paths[0])
      [void](Assert-RelativeRepoPath $paths[1])
    }
    "restore" {
      foreach ($token in $Arguments) {
        if (Test-ExistingRepoPathToken $token) { [void](Assert-RelativeRepoPath $token) }
      }
    }
  }
}

if ($Subcommand -eq "help") {
@"
Usage:

  git.cmd status [args...]
  git.cmd diff [args...]
  git.cmd add [args...]
  git.cmd commit [args...]
  git.cmd push [args...]

Notes:

- Only a bounded set of common git subcommands is exposed.
- User-supplied git -c and similar config-injection flags are blocked.
- Hooks are disabled through an internal empty hooks path.
- Use '--' before pathspecs when ambiguity is possible.
"@ | Write-Output
  exit 0
}

Validate-GitArgs -Verb $Subcommand -Arguments $GitArgs
$exe = Get-ExecutablePath -Candidates @("git")
$hooksPath = Resolve-RepoPath -Path ".agents/tools/disabled-hooks"
if (-not (Test-Path -LiteralPath $hooksPath -PathType Container)) {
  [System.IO.Directory]::CreateDirectory($hooksPath) | Out-Null
}

$argv = @("--no-pager", "-c", "core.hooksPath=$hooksPath", $Subcommand)
if ($GitArgs) { $argv += $GitArgs }
$preview = @("--no-pager", $Subcommand)
if ($GitArgs) { $preview += $GitArgs }
Write-Host (">> git " + (Join-PreviewTokens $preview))
& $exe @argv
exit $LASTEXITCODE
