# dotnet.ps1
[CmdletBinding(PositionalBinding = $false)]
param(
  # Primary verb, not free-form
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("test","run","build","restore","format","help","sln")]
  [string] $Action,

  # Everything else goes here (Roo passes args after --)
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $DotNetArgs,

  # Optional, replaces user pipes:
  # dotnet ... 2>&1 | Select-String -Pattern ...
  [string] $MatchPattern,

  # Optional, replaces:
  # dotnet ... 2>&1 | Select-Object -Last N
  [int] $LastLines = 0,

  # Timeout in seconds. 0 = no timeout. Default 5 minutes.
  [int] $Timeout = 300
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

function Invoke-DotNet([string[]]$Arguments, [string]$match, [int]$last, [int]$timeoutSec) {
  Write-Host ">> dotnet $($Arguments -join ' ')"

  $dotnetExe = (Get-Command dotnet -ErrorAction Stop).Source

  $psi = [System.Diagnostics.ProcessStartInfo]::new()
  $psi.FileName = $dotnetExe
  $psi.Arguments = ($Arguments | ForEach-Object {
    if ($_ -match '\s') { "`"$_`"" } else { $_ }
  }) -join ' '
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.CreateNoWindow = $true

  $outputLines = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()

  $proc = [System.Diagnostics.Process]::new()
  $proc.StartInfo = $psi
  $proc.EnableRaisingEvents = $true

  # Use scriptblock event handlers to collect output
  $outHandler = { if ($EventArgs.Data -ne $null) { $Event.MessageData.Enqueue($EventArgs.Data) } }
  $errHandler = { if ($EventArgs.Data -ne $null) { $Event.MessageData.Enqueue($EventArgs.Data) } }

  $outEvent = Register-ObjectEvent -InputObject $proc -EventName OutputDataReceived -Action $outHandler -MessageData $outputLines
  $errEvent = Register-ObjectEvent -InputObject $proc -EventName ErrorDataReceived -Action $errHandler -MessageData $outputLines

  try {
    [void]$proc.Start()
    $proc.BeginOutputReadLine()
    $proc.BeginErrorReadLine()

    if ($timeoutSec -gt 0) {
      $exited = $proc.WaitForExit($timeoutSec * 1000)
      if (-not $exited) {
        # Kill the process tree
        try { & taskkill /F /T /PID $proc.Id 2>$null | Out-Null } catch {}
        try { $proc.Kill($true) } catch {}
        Write-Error "TIMEOUT: dotnet process exceeded ${timeoutSec}s and was killed."
        exit 124
      }
    } else {
      $proc.WaitForExit()
    }

    # Ensure async output handlers have flushed
    $proc.WaitForExit()

    $exitCode = $proc.ExitCode
  }
  finally {
    Unregister-Event -SourceIdentifier $outEvent.Name -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier $errEvent.Name -ErrorAction SilentlyContinue
    $proc.Dispose()
  }

  # Convert collected output to ordered array
  $lines = $outputLines.ToArray()

  if ($match) {
    $lines = $lines | Select-String -Pattern $match | ForEach-Object { $_.ToString() }
  }
  if ($last -gt 0) {
    $lines = $lines | Select-Object -Last $last
  }

  $lines | ForEach-Object { Write-Output $_ }

  if ($exitCode -ne 0) { exit $exitCode }
}

if ($Action -eq "help") {
@"
Usage:

  dotnet.cmd test [dotnet test args...] [-MatchPattern '...' ] [-LastLines N]
  dotnet.cmd run  [dotnet run  args...] [-MatchPattern '...' ] [-LastLines N]
  dotnet.cmd build [dotnet build args...] ...
  dotnet.cmd restore [dotnet restore args...] ...
  dotnet.cmd format [dotnet format args...] ...

Examples:

  dotnet.cmd test tests/MyTests.csproj --no-build --filter "FullyQualifiedName~SomeTests"
  dotnet.cmd test --collect:""XPlat Code Coverage"" -LastLines 200
  dotnet.cmd run --project src/VexaNews.Api/VexaNews.Api.csproj -- --urls http://localhost:5000
  dotnet.cmd build --configuration Release
  dotnet.cmd format
  dotnet.cmd test tests/MyTests.csproj -Timeout 120

Timeout: Default 300s (5 min). Override with -Timeout 600. Use -Timeout 0 to disable.
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
Invoke-DotNet -Arguments $argv -match $MatchPattern -last $LastLines -timeoutSec $Timeout
