Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail {
  param([Parameter(Mandatory = $true)][string]$Message)
  throw [System.InvalidOperationException]::new($Message)
}

function Get-ModuleDirectory {
  return [System.IO.Path]::GetFullPath($PSScriptRoot)
}

function Get-RepoRoot {
  $envRoot = [Environment]::GetEnvironmentVariable("AGENTS_REPO_ROOT")
  if (-not [string]::IsNullOrWhiteSpace($envRoot)) {
    $fullEnvRoot = [System.IO.Path]::GetFullPath($envRoot)
    if (-not (Test-Path -LiteralPath $fullEnvRoot -PathType Container)) {
      Fail "AGENTS_REPO_ROOT does not exist or is not a directory: $envRoot"
    }
    if (-not (Test-Path -LiteralPath (Join-Path $fullEnvRoot ".agents") -PathType Container)) {
      Fail "AGENTS_REPO_ROOT must point to a repo root containing .agents: $envRoot"
    }
    return $fullEnvRoot
  }

  $cursor = Get-ModuleDirectory
  while ($true) {
    if (Test-Path -LiteralPath (Join-Path $cursor ".agents") -PathType Container) {
      return [System.IO.Path]::GetFullPath($cursor)
    }

    $parent = Split-Path -Parent $cursor
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $cursor) { break }
    $cursor = $parent
  }

  Fail "Unable to resolve repo root. Set AGENTS_REPO_ROOT or place .agents under the repository root."
}

function Get-NormalizedRoot {
  param([Parameter(Mandatory = $true)][string]$Root)
  return $Root.TrimEnd([char]'\', [char]'/')
}

function Assert-PathWithinRoot {
  param(
    [Parameter(Mandatory = $true)][string]$FullPath,
    [Parameter(Mandatory = $true)][string]$Root
  )

  $normalizedRoot = Get-NormalizedRoot $Root
  $normalizedFull = Get-NormalizedRoot ([System.IO.Path]::GetFullPath($FullPath))

  if ($normalizedFull.Equals($normalizedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    return
  }

  $rootWithSep = $normalizedRoot + [System.IO.Path]::DirectorySeparatorChar
  if (-not $normalizedFull.StartsWith($rootWithSep, [System.StringComparison]::OrdinalIgnoreCase)) {
    Fail "Path escapes repo root: $FullPath"
  }
}

function Assert-NoReparsePointTraversal {
  param(
    [Parameter(Mandatory = $true)][string]$FullPath,
    [Parameter(Mandatory = $true)][string]$Root
  )

  $rootFull = [System.IO.Path]::GetFullPath($Root)
  $cursor = [System.IO.Path]::GetFullPath($FullPath)

  while (-not (Test-Path -LiteralPath $cursor) -and ($cursor.Length -gt 0)) {
    $parent = Split-Path -Parent $cursor
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $cursor) { break }
    $cursor = $parent
  }

  while ($true) {
    if (Test-Path -LiteralPath $cursor) {
      $item = Get-Item -LiteralPath $cursor -Force -ErrorAction Stop
      if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        Fail "Path traverses reparse point (symlink/junction): $cursor"
      }
    }

    if ($cursor.Equals($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) { break }

    $parent = Split-Path -Parent $cursor
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $cursor) { break }
    $cursor = $parent
  }
}

function Test-IsWindowsAbsolutePath {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  if ($Value -match '^[a-zA-Z]:[\\/]') { return $true }
  if ($Value -match '^(\\\\|//)') { return $true }
  return $false
}

function Resolve-RepoPath {
  param([Parameter(Mandatory = $true)][string]$Path)

  if ([string]::IsNullOrWhiteSpace($Path)) { Fail "Path is required" }
  if ([System.IO.Path]::IsPathRooted($Path) -or (Test-IsWindowsAbsolutePath $Path)) {
    Fail "Path must be relative: $Path"
  }
  if ($Path -match '(^|[\\/])\.\.([\\/]|$)') {
    Fail "Path must not contain '..': $Path"
  }

  $root = Get-RepoRoot
  $full = [System.IO.Path]::GetFullPath((Join-Path $root $Path))

  Assert-PathWithinRoot -FullPath $full -Root $root
  Assert-NoReparsePointTraversal -FullPath $full -Root $root

  return $full
}

function Assert-RelativeRepoPath {
  param([Parameter(Mandatory = $true)][string]$Path)
  [void](Resolve-RepoPath -Path $Path)
  return $Path
}

function ConvertTo-RepoRelativePath {
  param([Parameter(Mandatory = $true)][string]$FullPath)

  $root = Get-NormalizedRoot (Get-RepoRoot)
  $normalizedFull = Get-NormalizedRoot ([System.IO.Path]::GetFullPath($FullPath))
  Assert-PathWithinRoot -FullPath $normalizedFull -Root $root

  if ($normalizedFull.Equals($root, [System.StringComparison]::OrdinalIgnoreCase)) {
    return "."
  }

  $relative = $normalizedFull.Substring($root.Length).TrimStart([char]'\', [char]'/')
  return ($relative -replace '\\', '/')
}

function Assert-NoShellMetachars {
  param([string[]]$Tokens)

  if ($null -eq $Tokens) { return }
  $meta = @('`','>','<','&&','||')

  foreach ($t in $Tokens) {
    if ($null -eq $t) { continue }
    foreach ($m in $meta) {
      if ($t -like "*$m*") {
        Fail "Forbidden shell metachar '$m' detected in argument: $t"
      }
    }
  }
}

function Ensure-ParentDirectory {
  param([Parameter(Mandatory = $true)][string]$Path)

  $parent = Split-Path -Parent $Path
  if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent -PathType Container)) {
    [System.IO.Directory]::CreateDirectory($parent) | Out-Null
  }
}

function Get-ExecutablePath {
  param(
    [Parameter(Mandatory = $true)][string[]]$Candidates
  )

  foreach ($candidate in $Candidates) {
    try {
      $cmd = Get-Command $candidate -ErrorAction Stop
      if ($null -ne $cmd.Source -and -not [string]::IsNullOrWhiteSpace($cmd.Source)) {
        return $cmd.Source
      }
      return $cmd.Path
    }
    catch {
    }
  }

  Fail "Unable to resolve executable. Tried: $($Candidates -join ', ')"
}

function ConvertTo-WindowsArgument {
  param([Parameter(Mandatory = $true)][AllowEmptyString()][string]$Argument)

  if ($Argument.Length -eq 0) { return '""' }
  if ($Argument -notmatch '[\s"]') { return $Argument }

  $builder = New-Object System.Text.StringBuilder
  [void]$builder.Append('"')
  $backslashes = 0

  foreach ($ch in $Argument.ToCharArray()) {
    if ($ch -eq '\\') {
      $backslashes++
      continue
    }

    if ($ch -eq '"') {
      [void]$builder.Append(('\\' * (($backslashes * 2) + 1)))
      [void]$builder.Append('"')
      $backslashes = 0
      continue
    }

    if ($backslashes -gt 0) {
      [void]$builder.Append(('\\' * $backslashes))
      $backslashes = 0
    }

    [void]$builder.Append($ch)
  }

  if ($backslashes -gt 0) {
    [void]$builder.Append(('\\' * ($backslashes * 2)))
  }

  [void]$builder.Append('"')
  return $builder.ToString()
}

function Invoke-ProcessWithCapture {
  param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [Parameter()][string[]]$Arguments = @(),
    [int]$TimeoutSeconds = 0
  )

  $stdoutFile = [System.IO.Path]::GetTempFileName()
  $stderrFile = [System.IO.Path]::GetTempFileName()

  try {
    $proc = Start-Process -FilePath $FilePath `
      -ArgumentList $Arguments `
      -RedirectStandardOutput $stdoutFile `
      -RedirectStandardError $stderrFile `
      -NoNewWindow `
      -PassThru

    $timedOut = $false
    if ($TimeoutSeconds -gt 0) {
      $exited = $proc.WaitForExit($TimeoutSeconds * 1000)
      if (-not $exited) {
        $timedOut = $true
        try { $proc.Kill() } catch {}
      }
    }

    $proc.WaitForExit()

    $stdout = if (Test-Path -LiteralPath $stdoutFile) { [System.IO.File]::ReadAllText($stdoutFile) } else { "" }
    $stderr = if (Test-Path -LiteralPath $stderrFile) { [System.IO.File]::ReadAllText($stderrFile) } else { "" }

    if ($timedOut) {
      return [pscustomobject]@{
        ExitCode = 124
        TimedOut = $true
        StdOut = $stdout
        StdErr = ($stderr + [Environment]::NewLine + "TIMEOUT: process exceeded ${TimeoutSeconds}s and was killed.").Trim()
      }
    }

    return [pscustomobject]@{
      ExitCode = $proc.ExitCode
      TimedOut = $false
      StdOut = $stdout
      StdErr = $stderr
    }
  }
  finally {
    Remove-Item -LiteralPath $stdoutFile -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $stderrFile -Force -ErrorAction SilentlyContinue
  }
}

function Join-PreviewTokens {
  param([string[]]$Tokens)
  if ($null -eq $Tokens -or $Tokens.Count -eq 0) { return "" }
  return (($Tokens | ForEach-Object {
    if ($_ -match '\s') { '"' + $_ + '"' } else { $_ }
  }) -join ' ')
}

Export-ModuleMember -Function `
  Fail, `
  Get-RepoRoot, `
  Assert-PathWithinRoot, `
  Assert-NoReparsePointTraversal, `
  Test-IsWindowsAbsolutePath, `
  Resolve-RepoPath, `
  Assert-RelativeRepoPath, `
  ConvertTo-RepoRelativePath, `
  Assert-NoShellMetachars, `
  Ensure-ParentDirectory, `
  Get-ExecutablePath, `
  ConvertTo-WindowsArgument, `
  Invoke-ProcessWithCapture, `
  Join-PreviewTokens
