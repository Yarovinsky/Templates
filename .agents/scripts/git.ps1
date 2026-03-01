[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateNotNullOrEmpty()]
  [string] $Subcommand,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $GitArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "ScriptSecurity.psm1") -Force

function Validate-GitArgs {
  param([string[]]$Args)

  Assert-NoShellMetachars $Args

  for ($i = 0; $i -lt $Args.Length; $i++) {
    $arg = $Args[$i]

    if ($arg -eq "-C") {
      if ($i + 1 -ge $Args.Length) { Fail "Missing value after -C" }
      Assert-RelativeRepoPath $Args[$i + 1] | Out-Null
      $i++
      continue
    }

    if ($arg -in @("--git-dir", "--work-tree")) {
      if ($i + 1 -ge $Args.Length) { Fail "Missing value after $arg" }
      Assert-RelativeRepoPath $Args[$i + 1] | Out-Null
      $i++
      continue
    }

    if ($arg -match '^(--git-dir|--work-tree)=(.+)$') {
      Assert-RelativeRepoPath $Matches[2] | Out-Null
      continue
    }
  }
}

Validate-GitArgs $GitArgs

Write-Host ">> git $Subcommand $($GitArgs -join ' ')"
& git $Subcommand @GitArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
