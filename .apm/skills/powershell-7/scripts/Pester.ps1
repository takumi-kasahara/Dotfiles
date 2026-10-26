<#
.SYNOPSIS
  Runs Pester tests for a specified script or module.

.DESCRIPTION
  The script validates the provided path, locates the corresponding module and test files, configures Pester settings, and invokes Pester.
  If not running in PowerShell Core, the script exits without running tests.

.PARAMETER Path
  The path to the script, module, or test file to run tests for. This parameter is required and must be a valid path.

.PARAMETER LineNumber
  The line number in the test file to filter tests to. Only applicable when a single test file is specified. Default is 0 (no line filter).

.PARAMETER TagFilter
  One or more tags to filter tests by. Only tests with at least one matching tag are run. Default is no tag filter.

.PARAMETER Parallel
  Run tests in parallel. When this switch is used, code coverage collection is skipped.

.EXAMPLE
  ```powershell
  .\Pester.ps1 -Path ".\Module.Tests.ps1"
  ```

  Runs all tests in the specified test file.

.EXAMPLE
  ```powershell
   .\Pester.ps1 -Path ".\Module.Tests.ps1" -LineNumber 42
  ```

   Runs only the test at or near line 42 in the specified test file.

.EXAMPLE
  ```powershell
  .\Pester.ps1 -Path ".\Modules" -Parallel
  ```

  Runs all tests for the module in parallel.

.OUTPUTS
  None

.NOTES
  For more information about Pester, see https://pester.dev
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory, Position = 0)]
  [ValidateScript({ Test-Path -LiteralPath $_ })]
  [string]
  $Path,
  [string[]]
  $TagFilter,
  [int]
  $LineNumber = 0,
  [switch]
  $Parallel
)
if ($PSEdition -ne 'Core') {
  return
}
Set-StrictMode -Version Latest

$ext = [WildcardPattern]::Escape($Path) | Split-Path -Extension
if (Test-Path -LiteralPath $Path -PathType Container) {
  $module = Get-ChildItem -Path "$([WildcardPattern]::Escape($Path))\*" -File -Include '*.ps1', '*.psm1' | Where-Object { $_.Name -notlike '*.Tests.ps1' }
  $test = Get-ChildItem -LiteralPath $Path -File -Filter '*.Tests.ps1'
} elseif ($ext -eq '.ps1') {
  $parent = [WildcardPattern]::Escape($Path) | Split-Path -Parent
  $base = ([WildcardPattern]::Escape($Path) | Split-Path -LeafBase) -replace '\.Tests$', [string]::Empty
  $module = $parent | Join-Path -ChildPath "$base.psm1"
  $test = $parent | Join-Path -ChildPath "$base.Tests.ps1"
} elseif ($ext -eq '.psm1') {
  $parent = [WildcardPattern]::Escape($Path) | Split-Path -Parent
  $base = [WildcardPattern]::Escape($Path) | Split-Path -LeafBase
  $module = $Path
  $test = $parent | Join-Path -ChildPath "$base.Tests.ps1"
} else {
  throw "Unsupported file type: $ext"
}
if (-not (Test-Path -LiteralPath $module)) {
  throw "Module not found: $module"
}
if (-not (Test-Path -LiteralPath $test)) {
  throw "Test not found: $test"
}
$config = New-PesterConfiguration
$config.Run.Exit = $true
$config.Run.Parallel = $Parallel.IsPresent
if ($TagFilter.Count -gt 0) {
  $config.Filter.Tag = $TagFilter
}
if ($LineNumber -gt 0 -and @($test).Count -eq 1) {
  $config.Filter.Line = "$((Resolve-Path -LiteralPath $test).Path):$($LineNumber)"
}
$config.CodeCoverage.Path = (Resolve-Path -LiteralPath $module).Path
$config.TestResult.Enabled = $true
Invoke-Pester -Configuration $config
