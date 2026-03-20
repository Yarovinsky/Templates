[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $ForwardArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
& (Join-Path $PSScriptRoot "..\tools\pwsh\repo.ps1") @ForwardArgs
exit $LASTEXITCODE
