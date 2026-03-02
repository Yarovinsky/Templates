# .agents/scripts/dotnet.ps1
[CmdletBinding(PositionalBinding = $false)]
param(
  # Primary verb, not free-form
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("test","run","build","restore","format","help")]
  [string] $Action,

  # Everything else goes here (Roo passes args after --)
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $DotNetArgs,

  # Optional, replaces user pipes:
  # dotnet ... 2>&1 | Select-String -Pattern ...
  [string] $MatchPattern,

  # Optional, replaces:
  # dotnet ... 2>&1 | Select-Object -Last N
  [int] $LastLines = 0
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "ScriptSecurity.psm1") -Force

function Validate-DotNetArgs([string[]]$Arguments) {
  Assert-NoShellMetachars $Arguments

  # Validate known "path-bearing" flags and their following value
  # (dotnet accepts both "--project foo" and "--project=foo")
  $pathFlags = @("--project","--solution","--startup-project","--results-directory","--output","-o")
  for ($i = 0; $i -lt $Arguments.Length; $i++) {
    $a = $Arguments[$i]

    # handle --flag=value
    foreach ($pf in $pathFlags) {
      if ($a.StartsWith("$pf=", [System.StringComparison]::OrdinalIgnoreCase)) {
        $val = $a.Substring($pf.Length + 1)
        Assert-RelativeRepoPath $val
      }
    }

    # handle --flag value
    if ($pathFlags -contains $a) {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after $a" }
      $val = $Arguments[$i + 1]
      Assert-RelativeRepoPath $val
      $i++ # skip value
      continue
    }
  }
}

function Invoke-DotNet([string[]]$Arguments, [string]$match, [int]$last) {
  Write-Host ">> dotnet $($Arguments -join ' ')"

  # Capture stdout+stderr. We keep the original exit code via $LASTEXITCODE.
  $lines = & dotnet @Arguments 2>&1 | ForEach-Object { $_.ToString() }

  if ($match) {
    $lines = $lines | Select-String -Pattern $match | ForEach-Object { $_.ToString() }
  }
  if ($last -gt 0) {
    $lines = $lines | Select-Object -Last $last
  }

  $lines | ForEach-Object { Write-Output $_ }

  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if ($Action -eq "help") {
@"
Usage:

  .\.agents\scripts\dotnet.cmd test [dotnet test args...] [-MatchPattern '...' ] [-LastLines N]
  .\.agents\scripts\dotnet.cmd run  [dotnet run  args...] [-MatchPattern '...' ] [-LastLines N]
  .\.agents\scripts\dotnet.cmd build[dotnet build args...] ...
  .\.agents\scripts\dotnet.cmd restore[dotnet restore args...] ...
  .\.agents\scripts\dotnet.cmd format[dotnet format args...] ...

Examples:

  .\.agents\scripts\dotnet.cmd test --no-build --filter "FullyQualifiedName~IngestionPipelineTests"
  .\.agents\scripts\dotnet.cmd test --collect:""XPlat Code Coverage"" -LastLines 200
  .\.agents\scripts\dotnet.cmd run --project src/VexaNews.Api/VexaNews.Api.csproj -- --urls http://localhost:5000
  .\.agents\scripts\dotnet.cmd build --configuration Release
  .\.agents\scripts\dotnet.cmd format

No pipes allowed in arguments. Use -MatchPattern / -LastLines instead.
"@ | Write-Output
  exit 0
}

# Validate args before executing
Validate-DotNetArgs $DotNetArgs

# Compose final argv
$argv = @($Action) + $DotNetArgs
Invoke-DotNet -Arguments $argv -match $MatchPattern -last $LastLines
