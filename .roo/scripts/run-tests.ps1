param(
    [Parameter(Mandatory = $true)]
    [string]$Command,

    [int]$TimeoutMinutes = 1,

    [string]$LockFile = ".roo/.locks/test-runner.lock",

    [switch]$SkipProcessCleanup
)

$ErrorActionPreference = "Stop"

function Invoke-ProcessCleanup {
    $candidateNames = @("dotnet.exe", "vstest.console.exe", "testhost.exe")

    $processes = Get-CimInstance Win32_Process | Where-Object {
        ($candidateNames -contains $_.Name) -or
        ($_.Name -eq "dotnet.exe" -and $_.CommandLine -match "(^|\s)test(\s|$)")
    }

    foreach ($proc in $processes) {
        try {
            Stop-Process -Id $proc.ProcessId -Force -ErrorAction Stop
            Write-Output "[roo-test-runner] cleaned stale process: $($proc.Name) (PID $($proc.ProcessId))"
        }
        catch {
            Write-Output "[roo-test-runner] cleanup skipped for PID $($proc.ProcessId): $($_.Exception.Message)"
        }
    }
}

function Remove-StaleLockProcess {
    param([string]$ResolvedLockPath)

    if (-not (Test-Path -LiteralPath $ResolvedLockPath)) {
        return
    }

    try {
        $lockText = Get-Content -LiteralPath $ResolvedLockPath -Raw
        $lockJson = $lockText | ConvertFrom-Json

        if ($null -ne $lockJson.childPid) {
            $existing = Get-Process -Id ([int]$lockJson.childPid) -ErrorAction SilentlyContinue
            if ($null -ne $existing) {
                Write-Output "[roo-test-runner] found stale lock with active PID $($lockJson.childPid). Terminating process tree."
                cmd.exe /d /c "taskkill /PID $($lockJson.childPid) /T /F" | Out-Null
            }
        }
    }
    catch {
        Write-Output "[roo-test-runner] lock parse failed. Removing stale lock."
    }
    finally {
        Remove-Item -LiteralPath $ResolvedLockPath -Force -ErrorAction SilentlyContinue
    }
}

if ($TimeoutMinutes -lt 1) {
    throw "TimeoutMinutes must be >= 1"
}

$workspaceRoot = (Resolve-Path ".").Path
$resolvedLockPath = if ([System.IO.Path]::IsPathRooted($LockFile)) {
    $LockFile
}
else {
    Join-Path $workspaceRoot $LockFile
}

$lockDir = Split-Path -Parent $resolvedLockPath
if (-not (Test-Path -LiteralPath $lockDir)) {
    New-Item -ItemType Directory -Path $lockDir -Force | Out-Null
}

Remove-StaleLockProcess -ResolvedLockPath $resolvedLockPath

if (-not $SkipProcessCleanup) {
    Invoke-ProcessCleanup
}

$tempDir = Join-Path $workspaceRoot ".roo/.tmp"
if (-not (Test-Path -LiteralPath $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
}

$stdoutPath = Join-Path $tempDir ("test-runner-" + [guid]::NewGuid().ToString("N") + ".out.log")
$stderrPath = Join-Path $tempDir ("test-runner-" + [guid]::NewGuid().ToString("N") + ".err.log")

$commandProcess = $null
$timedOut = $false
$exitCode = 1

try {
    $lockPayload = [ordered]@{
        ownerPid       = $PID
        childPid       = $null
        startedUtc     = [DateTime]::UtcNow.ToString("o")
        timeoutMinutes = $TimeoutMinutes
        command        = $Command
        workspace      = $workspaceRoot
    } | ConvertTo-Json -Depth 4
    Set-Content -LiteralPath $resolvedLockPath -Value $lockPayload -Encoding UTF8

    Write-Output "[roo-test-runner] executing command: $Command"
    Write-Output "[roo-test-runner] timeout: $TimeoutMinutes minute(s)"

    $commandProcess = Start-Process -FilePath "cmd.exe" `
        -ArgumentList "/d", "/c", $Command `
        -WorkingDirectory $workspaceRoot `
        -NoNewWindow `
        -PassThru `
        -RedirectStandardOutput $stdoutPath `
        -RedirectStandardError $stderrPath

    $lockPayload = [ordered]@{
        ownerPid       = $PID
        childPid       = $commandProcess.Id
        startedUtc     = [DateTime]::UtcNow.ToString("o")
        timeoutMinutes = $TimeoutMinutes
        command        = $Command
        workspace      = $workspaceRoot
    } | ConvertTo-Json -Depth 4
    Set-Content -LiteralPath $resolvedLockPath -Value $lockPayload -Encoding UTF8

    $completed = $commandProcess.WaitForExit($TimeoutMinutes * 60 * 1000)
    if (-not $completed) {
        $timedOut = $true
        Write-Output "[roo-test-runner] timeout reached. terminating process tree for PID $($commandProcess.Id)."
        cmd.exe /d /c "taskkill /PID $($commandProcess.Id) /T /F" | Out-Null
        Start-Sleep -Seconds 1
    }

    if (Test-Path -LiteralPath $stdoutPath) {
        Get-Content -LiteralPath $stdoutPath
    }

    if (Test-Path -LiteralPath $stderrPath) {
        Get-Content -LiteralPath $stderrPath
    }

    if ($timedOut) {
        $exitCode = 124
        Write-Output "ROO_TEST_RUNNER_RESULT status=timeout exit_code=124 timeout_minutes=$TimeoutMinutes"
    }
    else {
        $exitCode = $commandProcess.ExitCode
        if ($exitCode -eq 0) {
            Write-Output "ROO_TEST_RUNNER_RESULT status=success exit_code=0 timeout_minutes=$TimeoutMinutes"
        }
        else {
            Write-Output "ROO_TEST_RUNNER_RESULT status=failure exit_code=$exitCode timeout_minutes=$TimeoutMinutes"
        }
    }
}
finally {
    if (-not $SkipProcessCleanup) {
        Invoke-ProcessCleanup
    }

    Remove-Item -LiteralPath $resolvedLockPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $stdoutPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $stderrPath -Force -ErrorAction SilentlyContinue
}

exit $exitCode
