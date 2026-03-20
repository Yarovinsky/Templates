[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("test","run","build","restore","format","sln","help")]
  [string] $Action,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $DotNetArgs,

  [string] $MatchPattern,
  [int] $LastLines = 0,
  [int] $Timeout = 300
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "..\lib\ScriptSecurity.psm1") -Force

function Test-PathLikeToken {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  if ($Value.StartsWith("-")) { return $false }
  if ($Value -eq ".") { return $true }
  if ($Value -match '[\\/]') { return $true }
  if ($Value -match '\.(sln|slnx|csproj|fsproj|vbproj)$') { return $true }
  return $false
}

function Validate-DotNetArgs {
  param([string]$Verb, [string[]]$Arguments)

  if ($null -eq $Arguments) { return }
  Assert-NoShellMetachars $Arguments

  $pathFlags = @("--project","--solution","--startup-project","--results-directory","--output","-o","--artifacts-path")
  $positionals = New-Object System.Collections.Generic.List[string]

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

    if (-not $a.StartsWith("-")) {
      $positionals.Add($a)
    }
  }

  switch ($Verb) {
    "test" { foreach ($p in $positionals) { if (Test-PathLikeToken $p) { [void](Assert-RelativeRepoPath $p) } } }
    "run" { foreach ($p in $positionals) { if (Test-PathLikeToken $p) { [void](Assert-RelativeRepoPath $p) } } }
    "build" { foreach ($p in $positionals) { if (Test-PathLikeToken $p) { [void](Assert-RelativeRepoPath $p) } } }
    "restore" { foreach ($p in $positionals) { if (Test-PathLikeToken $p) { [void](Assert-RelativeRepoPath $p) } } }
    "format" { foreach ($p in $positionals) { if (Test-PathLikeToken $p) { [void](Assert-RelativeRepoPath $p) } } }
    "sln" {
      if ($positionals.Count -gt 0 -and (Test-PathLikeToken $positionals[0])) {
        [void](Assert-RelativeRepoPath $positionals[0])
      }
      for ($j = 1; $j -lt $positionals.Count; $j++) {
        $token = $positionals[$j]
        if ($token -in @("add","remove","list")) { continue }
        if (Test-PathLikeToken $token) { [void](Assert-RelativeRepoPath $token) }
      }
    }
  }
}

function Rewrite-ProjectFlag {
  param([string]$Verb, [string[]]$Arguments)

  if ($Verb -ne "test" -or $null -eq $Arguments -or $Arguments.Count -eq 0) {
    return $Arguments
  }

  $result = New-Object System.Collections.Generic.List[string]
  $projectPath = $null

  for ($i = 0; $i -lt $Arguments.Length; $i++) {
    $a = $Arguments[$i]

    if ($a -match '^--project=(.+)$') {
      $projectPath = $Matches[1]
      continue
    }

    if ($a -eq "--project") {
      if ($i + 1 -ge $Arguments.Length) { Fail "Missing value after --project" }
      $projectPath = $Arguments[$i + 1]
      $i++
      continue
    }

    $result.Add($a) | Out-Null
  }

  if (-not [string]::IsNullOrWhiteSpace($projectPath)) {
    $result.Insert(0, $projectPath)
  }

  return $result.ToArray()
}

if ($Action -eq "help") {
@"
Usage:

  dotnet.cmd test [args...] [-MatchPattern '...'] [-LastLines N] [-Timeout seconds]
  dotnet.cmd run [args...] [-MatchPattern '...'] [-LastLines N] [-Timeout seconds]
  dotnet.cmd build [args...] [-Timeout seconds]
  dotnet.cmd restore [args...] [-Timeout seconds]
  dotnet.cmd format [args...] [-Timeout seconds]
  dotnet.cmd sln [args...] [-Timeout seconds]

Examples:

  dotnet.cmd test tests/App.Tests/App.Tests.csproj --no-build
  dotnet.cmd test --project tests/App.Tests/App.Tests.csproj -LastLines 200
  dotnet.cmd run --project src/App/App.csproj -- --urls http://localhost:5000
  dotnet.cmd build src/App/App.csproj --configuration Debug
  dotnet.cmd sln App.sln add src/App/App.csproj

Notes:

- Allowed actions are bounded by policy.
- Use -MatchPattern and -LastLines instead of shell pipes.
- Timeout defaults to 300 seconds. Use -Timeout 0 to disable.
"@ | Write-Output
  exit 0
}

Validate-DotNetArgs -Verb $Action -Arguments $DotNetArgs
$effectiveArgs = Rewrite-ProjectFlag -Verb $Action -Arguments $DotNetArgs
$argv = @($Action)
if ($effectiveArgs) { $argv += $effectiveArgs }

$exe = Get-ExecutablePath -Candidates @("dotnet")
Write-Host (">> dotnet " + (Join-PreviewTokens $argv))
$result = Invoke-ProcessWithCapture -FilePath $exe -Arguments $argv -TimeoutSeconds $Timeout

$combined = @()
if (-not [string]::IsNullOrEmpty($result.StdOut)) { $combined += ($result.StdOut -split "`r?`n") }
if (-not [string]::IsNullOrEmpty($result.StdErr)) { $combined += ($result.StdErr -split "`r?`n") }
$combined = $combined | Where-Object { $_ -ne $null -and $_ -ne "" }

if (-not [string]::IsNullOrWhiteSpace($MatchPattern)) {
  $combined = $combined | Select-String -Pattern $MatchPattern | ForEach-Object { $_.ToString() }
}

if ($LastLines -gt 0) {
  $combined = $combined | Select-Object -Last $LastLines
}

$combined | ForEach-Object { Write-Output $_ }
exit $result.ExitCode
