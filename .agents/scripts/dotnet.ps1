[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $ForwardArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
& (Join-Path $PSScriptRoot "..\tools\pwsh\dotnet.ps1") @ForwardArgs
exit $LASTEXITCODE
