Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail {
  param([Parameter(Mandatory = $true)][string]$Message)
  Write-Error $Message
  exit 1
}

function Assert-NoShellMetachars {
  param([string[]]$Tokens)

  if ($null -eq $Tokens) { return }

  # Note: ';' is intentionally excluded — it's safe in argument arrays
  # (direct process invocation via & and splatting) and is legitimately
  # used in dotnet --logger values like "console;verbosity=detailed".
  # Note: '|' is intentionally excluded — it's safe in splatted argument
  # arrays (not interpreted as a pipe) and is legitimately used in
  # xUnit/NUnit --filter expressions like "FullyQualifiedName~A|FullyQualifiedName~B".
  # Note: '&' is intentionally excluded — it's safe in splatted argument
  # arrays (not interpreted as command chaining) and is legitimately used in
  # xUnit/NUnit --filter expressions as an AND operator like "A&B".
  # The double '&&' is still blocked as a dedicated entry in $meta.
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

function Get-RepoRoot {
  [System.IO.Path]::GetFullPath((Get-Location).Path)
}

function Assert-PathWithinRoot {
  param(
    [Parameter(Mandatory = $true)][string]$FullPath,
    [Parameter(Mandatory = $true)][string]$Root
  )

  $normalizedRoot = $Root.TrimEnd([char]'\', [char]'/')
  $normalizedFull = $FullPath.TrimEnd([char]'\', [char]'/')

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

  $cursor = $FullPath

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

    if ($cursor.Equals($Root, [System.StringComparison]::OrdinalIgnoreCase)) { break }

    $parent = Split-Path -Parent $cursor
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $cursor) { break }
    $cursor = $parent
  }
}

function Assert-RelativeRepoPath {
  param([string]$Path)

  if ([string]::IsNullOrWhiteSpace($Path)) { Fail "Path is required" }

  if ([System.IO.Path]::IsPathRooted($Path)) {
    Fail "Path must be relative: $Path"
  }

  if ($Path -match '(^|[\\/])\.\.([\\/]|$)') {
    Fail "Path must not contain '..': $Path"
  }

  $root = Get-RepoRoot
  $full = [System.IO.Path]::GetFullPath((Join-Path $root $Path))

  Assert-PathWithinRoot -FullPath $full -Root $root
  Assert-NoReparsePointTraversal -FullPath $full -Root $root

  return $Path
}

Export-ModuleMember -Function Fail, Assert-NoShellMetachars, Assert-RelativeRepoPath, Get-RepoRoot, Assert-PathWithinRoot, Assert-NoReparsePointTraversal
