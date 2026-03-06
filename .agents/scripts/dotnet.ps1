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
  if (-not $Arguments -or $Arguments.Count -eq 0) { return }
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
  # Scope ErrorActionPreference to SilentlyContinue so that stderr output from
  # the native command (e.g. xUnit test-failure messages) flows through the
  # pipeline as strings instead of triggering a NativeCommandError.
  $lines = & { $ErrorActionPreference = 'SilentlyContinue'; & dotnet @Arguments 2>&1 } |
    ForEach-Object { $_.ToString() }

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

  .\.agents\scripts\dotnet.cmd test tests/MyTests.csproj --no-build --filter "FullyQualifiedName~SomeTests"
  .\.agents\scripts\dotnet.cmd test --collect:""XPlat Code Coverage"" -LastLines 200
  .\.agents\scripts\dotnet.cmd run --project src/VexaNews.Api/VexaNews.Api.csproj -- --urls http://localhost:5000
  .\.agents\scripts\dotnet.cmd build --configuration Release
  .\.agents\scripts\dotnet.cmd format

Note: --project is automatically converted to a positional arg for 'test' (.NET 10+ compat).
No pipes allowed in arguments. Use -MatchPattern / -LastLines instead.
"@ | Write-Output
  exit 0
}

# Validate args before executing
Validate-DotNetArgs $DotNetArgs

# .NET 10+ SDK changed `dotnet test`: --project is no longer a valid switch.
# The project/solution path must be passed as a positional argument.
# We transparently rewrite --project <path> / --project=<path> to a positional arg
# so callers don't need to know about the SDK version difference.
function Rewrite-ProjectFlag([string]$act, [string[]]$args_in) {
  if (-not $args_in -or $args_in.Count -eq 0) { return $args_in }
  # Only rewrite for verbs where --project is now positional
  $rewriteVerbs = @("test")
  if ($rewriteVerbs -notcontains $act) { return $args_in }

  $result = [System.Collections.Generic.List[string]]::new()
  $projectPath = $null

  for ($i = 0; $i -lt $args_in.Length; $i++) {
    $a = $args_in[$i]

    # --project=value form
    if ($a -match '^--project=(.+)$') {
      $projectPath = $Matches[1]
      continue
    }
    # --project value form
    if ($a -eq '--project') {
      if ($i + 1 -lt $args_in.Length) {
        $projectPath = $args_in[$i + 1]
        $i++  # skip the value
      }
      continue
    }

    $result.Add($a)
  }

  if ($projectPath) {
    # Insert project path at the beginning (positional arg comes right after verb)
    $result.Insert(0, $projectPath)
  }

  return $result.ToArray()
}

$DotNetArgs = Rewrite-ProjectFlag -act $Action -args_in $DotNetArgs

# Compose final argv
$argv = @($Action)
if ($DotNetArgs) { $argv += $DotNetArgs }
Invoke-DotNet -Arguments $argv -match $MatchPattern -last $LastLines
