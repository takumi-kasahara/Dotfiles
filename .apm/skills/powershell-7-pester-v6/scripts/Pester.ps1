[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [ValidateScript({ Test-Path -LiteralPath $_ })]
  [string]
  $Path,
  [int]
  $LineNumber = 0
)

Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

$resolvedPath = Resolve-Path -LiteralPath $Path
$fileName = $resolvedPath.Name
$directory = $resolvedPath.DirectoryName

# Determine the test file path based on the input file type
if ($fileName -match '\.Tests\.ps1$') {
  # *.Tests.ps1 —> allowed as-is
  $testPath = $resolvedPath.Path
} elseif ($fileName -match '\.psm1$') {
  # .psm1 —> resolve to *.Tests.ps1
  $testPath = Join-Path -Path $directory -ChildPath ($fileName -replace '\.psm1$', '.Tests.ps1')
} elseif ($fileName -match '\.ps1$') {
  # *.ps1 (but not *.Tests.ps1) —> resolve to *.Tests.ps1
  $testPath = Join-Path -Path $directory -ChildPath ($fileName -replace '\.ps1$', '.Tests.ps1')
} else {
  # All other file types —> reject
  throw "LineNumber is only allowed for *.Tests.ps1, *.psm1, or *.ps1 files. The file '$fileName' is not supported."
}

if (-not (Test-Path -LiteralPath $testPath)) {
  throw "The corresponding test file '$testPath' does not exist."
}

$config = New-PesterConfiguration
if ($LineNumber -gt 0) {
  $config.Filter.Line = "$($testPath):$($LineNumber)"
}
$config.Run.Exit = $true
$config.Run.Parallel = $true
$config.Run.Path = $testPath
Invoke-Pester -Configuration $config
