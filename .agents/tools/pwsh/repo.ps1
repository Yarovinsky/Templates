[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("ls","cat","write","append","write-base64","append-base64","mkdir","rm","mv","cp","grep","touch","help")]
  [string] $Action,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $RepoArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "..\lib\ScriptSecurity.psm1") -Force

function Get-SeparatorIndex {
  param([string[]]$Arguments)
  return [Array]::IndexOf($Arguments, "--")
}

function Get-PathArgsBeforeSeparator {
  param([string[]]$Arguments)
  $sep = Get-SeparatorIndex $Arguments
  if ($sep -lt 0) { return $Arguments }
  if ($sep -eq 0) { return @() }
  return $Arguments[0..($sep - 1)]
}

function Get-ContentArgsAfterSeparator {
  param([string[]]$Arguments)
  $sep = Get-SeparatorIndex $Arguments
  if ($sep -lt 0) { Fail "Missing '--' separator before content" }
  if ($sep -ge ($Arguments.Length - 1)) { Fail "Missing content after '--'" }
  return $Arguments[($sep + 1)..($Arguments.Length - 1)]
}

function Read-AllText {
  param([Parameter(Mandatory = $true)][string]$Path)
  Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
}

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Content,
    [bool]$Append = $false
  )

  $utf8 = New-Object System.Text.UTF8Encoding($false)
  Ensure-ParentDirectory -Path $Path

  if ($Append) {
    [System.IO.File]::AppendAllText($Path, $Content, $utf8)
  } else {
    [System.IO.File]::WriteAllText($Path, $Content, $utf8)
  }
}

function Decode-Base64Text {
  param([Parameter(Mandatory = $true)][string]$Base64)
  $bytes = [System.Convert]::FromBase64String($Base64)
  return [System.Text.Encoding]::UTF8.GetString($bytes)
}

function Get-Listing {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [bool]$Recurse = $false,
    [int]$Depth = 3
  )

  if (-not $Recurse) {
    Get-ChildItem -LiteralPath $Path -Force | ForEach-Object {
      ConvertTo-RepoRelativePath $_.FullName
    }
    return
  }

  function Visit-Tree {
    param([string]$CurrentPath, [int]$RemainingDepth)

    if ($RemainingDepth -lt 0) { return }

    foreach ($item in (Get-ChildItem -LiteralPath $CurrentPath -Force)) {
      ConvertTo-RepoRelativePath $item.FullName
      if ($item.PSIsContainer -and $RemainingDepth -gt 0) {
        Visit-Tree -CurrentPath $item.FullName -RemainingDepth ($RemainingDepth - 1)
      }
    }
  }

  Visit-Tree -CurrentPath $Path -RemainingDepth $Depth
}

$pathArgs = Get-PathArgsBeforeSeparator $RepoArgs
Assert-NoShellMetachars $pathArgs

if ($Action -eq "help") {
@"
repo.cmd actions:

  repo.cmd ls <path> [-Recurse] [-Depth N]
  repo.cmd cat <path>
  repo.cmd write <path> -- <single-line text...>
  repo.cmd append <path> -- <single-line text...>
  repo.cmd write-base64 <path> -- <base64-utf8>
  repo.cmd append-base64 <path> -- <base64-utf8>
  repo.cmd mkdir <path>
  repo.cmd rm <path> [-Recurse] [-Force]
  repo.cmd mv <src> <dst>
  repo.cmd cp <src> <dst> [-Recurse]
  repo.cmd grep <pattern> <path> [-Recurse]
  repo.cmd touch <path>

Notes:

- All paths are repo-relative.
- Use write-base64 / append-base64 for multi-line or code-heavy content.
- Content begins after the '--' separator.
"@ | Write-Output
  exit 0
}

switch ($Action) {
  "ls" {
    if ($RepoArgs.Length -lt 1) { Fail "ls requires <path>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    $recurse = $RepoArgs -contains "-Recurse"
    $depth = 3
    for ($i = 1; $i -lt $RepoArgs.Length; $i++) {
      if ($RepoArgs[$i] -eq "-Depth") {
        if ($i + 1 -ge $RepoArgs.Length) { Fail "-Depth requires a value" }
        $depth = [int]$RepoArgs[++$i]
      }
    }
    Get-Listing -Path $path -Recurse:$recurse -Depth $depth | Write-Output
  }

  "cat" {
    if ($RepoArgs.Length -lt 1) { Fail "cat requires <path>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    Read-AllText -Path $path | Write-Output
  }

  "write" {
    if ($RepoArgs.Length -lt 2) { Fail "write requires <path> -- <text...>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    $text = (Get-ContentArgsAfterSeparator $RepoArgs) -join " "
    Write-Utf8NoBom -Path $path -Content $text -Append:$false
  }

  "append" {
    if ($RepoArgs.Length -lt 2) { Fail "append requires <path> -- <text...>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    $text = (Get-ContentArgsAfterSeparator $RepoArgs) -join " "
    Write-Utf8NoBom -Path $path -Content $text -Append:$true
  }

  "write-base64" {
    if ($RepoArgs.Length -lt 2) { Fail "write-base64 requires <path> -- <base64-utf8>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    $payload = (Get-ContentArgsAfterSeparator $RepoArgs) -join ""
    $text = Decode-Base64Text -Base64 $payload
    Write-Utf8NoBom -Path $path -Content $text -Append:$false
  }

  "append-base64" {
    if ($RepoArgs.Length -lt 2) { Fail "append-base64 requires <path> -- <base64-utf8>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    $payload = (Get-ContentArgsAfterSeparator $RepoArgs) -join ""
    $text = Decode-Base64Text -Base64 $payload
    Write-Utf8NoBom -Path $path -Content $text -Append:$true
  }

  "mkdir" {
    if ($RepoArgs.Length -lt 1) { Fail "mkdir requires <path>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    [System.IO.Directory]::CreateDirectory($path) | Out-Null
  }

  "rm" {
    if ($RepoArgs.Length -lt 1) { Fail "rm requires <path>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    $recurse = $RepoArgs -contains "-Recurse"
    $force = $RepoArgs -contains "-Force"
    Remove-Item -LiteralPath $path -Recurse:$recurse -Force:$force -ErrorAction Stop
  }

  "mv" {
    if ($RepoArgs.Length -lt 2) { Fail "mv requires <src> <dst>" }
    $src = Resolve-RepoPath -Path $RepoArgs[0]
    $dst = Resolve-RepoPath -Path $RepoArgs[1]
    Ensure-ParentDirectory -Path $dst
    Move-Item -LiteralPath $src -Destination $dst -Force -ErrorAction Stop
  }

  "cp" {
    if ($RepoArgs.Length -lt 2) { Fail "cp requires <src> <dst>" }
    $src = Resolve-RepoPath -Path $RepoArgs[0]
    $dst = Resolve-RepoPath -Path $RepoArgs[1]
    $recurse = $RepoArgs -contains "-Recurse"
    Ensure-ParentDirectory -Path $dst
    Copy-Item -LiteralPath $src -Destination $dst -Recurse:$recurse -Force -ErrorAction Stop
  }

  "grep" {
    if ($RepoArgs.Length -lt 2) { Fail "grep requires <pattern> <path>" }
    $pattern = $RepoArgs[0]
    $path = Resolve-RepoPath -Path $RepoArgs[1]
    $recurse = $RepoArgs -contains "-Recurse"

    if ($recurse) {
      Get-ChildItem -LiteralPath $path -Recurse -File -Force |
        Select-String -Pattern $pattern |
        ForEach-Object {
          $rel = ConvertTo-RepoRelativePath $_.Path
          "$rel:$($_.LineNumber): $($_.Line)"
        } | Write-Output
    }
    else {
      $item = Get-Item -LiteralPath $path -ErrorAction Stop
      if ($item.PSIsContainer) {
        Get-ChildItem -LiteralPath $path -File -Force |
          Select-String -Pattern $pattern |
          ForEach-Object {
            $rel = ConvertTo-RepoRelativePath $_.Path
            "$rel:$($_.LineNumber): $($_.Line)"
          } | Write-Output
      }
      else {
        Select-String -LiteralPath $path -Pattern $pattern |
          ForEach-Object {
            $rel = ConvertTo-RepoRelativePath $_.Path
            "$rel:$($_.LineNumber): $($_.Line)"
          } | Write-Output
      }
    }
  }

  "touch" {
    if ($RepoArgs.Length -lt 1) { Fail "touch requires <path>" }
    $path = Resolve-RepoPath -Path $RepoArgs[0]
    Ensure-ParentDirectory -Path $path
    if (-not (Test-Path -LiteralPath $path)) {
      [System.IO.File]::WriteAllText($path, "")
    }
    else {
      (Get-Item -LiteralPath $path).LastWriteTime = Get-Date
    }
  }
}
