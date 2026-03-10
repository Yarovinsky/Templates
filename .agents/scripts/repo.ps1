[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("ls","cat","write","append","mkdir","rm","mv","cp","grep","touch","help")]
  [string] $Action,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $RepoArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "ScriptSecurity.psm1") -Force

function Read-AllText([string]$Path) {
  Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
}

function Ensure-ParentDir([string]$Path) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path -LiteralPath $dir)) {
    [System.IO.Directory]::CreateDirectory($dir) | Out-Null
  }
}

Assert-NoShellMetachars $RepoArgs

if ($Action -eq "help") {
@"
repo.cmd actions:

  repo.cmd ls   <path> [-Recurse] [-Depth N]
  repo.cmd cat  <path>
  repo.cmd write <path> -- <text...>
  repo.cmd append <path> -- <text...>
  repo.cmd mkdir <path>
  repo.cmd rm <path> [-Recurse] [-Force]
  repo.cmd mv <src> <dst>
  repo.cmd cp <src> <dst> [-Recurse]
  repo.cmd grep <pattern> <path> [-Recurse]
  repo.cmd touch <path>

All paths are relative and restricted to repo.
"@ | Write-Output
  exit 0
}

switch ($Action) {

  "ls" {
    if ($RepoArgs.Length -lt 1) { Fail "ls requires <path>" }
    $path = Assert-RelativeRepoPath $RepoArgs[0]
    $recurse = $RepoArgs -contains "-Recurse"
    $depth = 3

    for ($i = 1; $i -lt $RepoArgs.Length; $i++) {
      if ($RepoArgs[$i] -eq "-Depth") {
        if ($i + 1 -ge $RepoArgs.Length) { Fail "-Depth requires a value" }
        $depth = [int]$RepoArgs[++$i]
      }
    }

    if ($recurse) {
      Get-ChildItem -LiteralPath $path -Recurse -Depth $depth -Force | Select-Object FullName
    } else {
      Get-ChildItem -LiteralPath $path -Force | Select-Object FullName
    }
  }

  "cat" {
    if ($RepoArgs.Length -lt 1) { Fail "cat requires <path>" }
    $p = Assert-RelativeRepoPath $RepoArgs[0]
    Read-AllText $p | Write-Output
  }

  "write" {
    if ($RepoArgs.Length -lt 2) { Fail "write requires <path> -- <text...>" }
    $p = Assert-RelativeRepoPath $RepoArgs[0]
    $sep = [Array]::IndexOf($RepoArgs, "--")
    if ($sep -lt 0) { Fail "write requires '--' separator before text" }
    if ($sep -ge ($RepoArgs.Length - 1)) { Fail "write requires text after '--'" }

    $text = ($RepoArgs[($sep + 1)..($RepoArgs.Length - 1)] -join " ")
    Ensure-ParentDir $p
    Set-Content -LiteralPath $p -Value $text -NoNewline -Encoding UTF8
  }

  "append" {
    if ($RepoArgs.Length -lt 2) { Fail "append requires <path> -- <text...>" }
    $p = Assert-RelativeRepoPath $RepoArgs[0]
    $sep = [Array]::IndexOf($RepoArgs, "--")
    if ($sep -lt 0) { Fail "append requires '--' separator before text" }
    if ($sep -ge ($RepoArgs.Length - 1)) { Fail "append requires text after '--'" }

    $text = ($RepoArgs[($sep + 1)..($RepoArgs.Length - 1)] -join " ")
    Ensure-ParentDir $p
    Add-Content -LiteralPath $p -Value $text -Encoding UTF8
  }

  "mkdir" {
    if ($RepoArgs.Length -lt 1) { Fail "mkdir requires <path>" }
    $p = Assert-RelativeRepoPath $RepoArgs[0]
    [System.IO.Directory]::CreateDirectory($p) | Out-Null
  }

  "rm" {
    if ($RepoArgs.Length -lt 1) { Fail "rm requires <path>" }
    $p = Assert-RelativeRepoPath $RepoArgs[0]
    $recurse = $RepoArgs -contains "-Recurse"
    $force = $RepoArgs -contains "-Force"
    Remove-Item -LiteralPath $p -Recurse:$recurse -Force:$force -ErrorAction Stop
  }

  "mv" {
    if ($RepoArgs.Length -lt 2) { Fail "mv requires <src> <dst>" }
    $src = Assert-RelativeRepoPath $RepoArgs[0]
    $dst = Assert-RelativeRepoPath $RepoArgs[1]
    Ensure-ParentDir $dst
    Move-Item -LiteralPath $src -Destination $dst -Force -ErrorAction Stop
  }

  "cp" {
    if ($RepoArgs.Length -lt 2) { Fail "cp requires <src> <dst>" }
    $src = Assert-RelativeRepoPath $RepoArgs[0]
    $dst = Assert-RelativeRepoPath $RepoArgs[1]
    $recurse = $RepoArgs -contains "-Recurse"
    Ensure-ParentDir $dst
    Copy-Item -LiteralPath $src -Destination $dst -Recurse:$recurse -Force -ErrorAction Stop
  }

  "grep" {
    if ($RepoArgs.Length -lt 2) { Fail "grep requires <pattern> <path>" }

    $pattern = $RepoArgs[0]
    $path = Assert-RelativeRepoPath $RepoArgs[1]
    $recurse = $RepoArgs -contains "-Recurse"

    if ($recurse) {
      Get-ChildItem -LiteralPath $path -Recurse -File -Force |
        Select-String -Pattern $pattern |
        ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line)" }
    } else {
      $item = Get-Item -LiteralPath $path -ErrorAction Stop
      if ($item.PSIsContainer) {
        Get-ChildItem -LiteralPath $path -File -Force |
          Select-String -Pattern $pattern |
          ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line)" }
      } else {
        Select-String -LiteralPath $path -Pattern $pattern |
          ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line)" }
      }
    }
  }

  "touch" {
    if ($RepoArgs.Length -lt 1) { Fail "touch requires <path>" }
    $p = Assert-RelativeRepoPath $RepoArgs[0]
    Ensure-ParentDir $p

    if (-not (Test-Path -LiteralPath $p)) {
      [System.IO.File]::WriteAllText($p, "")
    } else {
      (Get-Item -LiteralPath $p).LastWriteTime = Get-Date
    }
  }
}
