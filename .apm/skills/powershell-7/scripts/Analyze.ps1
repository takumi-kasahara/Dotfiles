<#
.SYNOPSIS
  Runs PSScriptAnalyzer on the specified path.

.DESCRIPTION
  Installs and imports PSScriptAnalyzer if needed, analyzes the given path(s) using the specified settings file,
  and outputs results as JSON.

.PARAMETER Path
  One or more paths to analyze. Wildcard characters are treated as literals and are not expanded.

.PARAMETER Settings
  Path to the PSScriptAnalyzer settings file. Defaults to PSScriptAnalyzerSettings.psd1.

.EXAMPLE
  ```powershell
  .\Analyze.ps1 -Path .\Script.ps1
  ```

  Analyzes the specified PowerShell script and outputs PSScriptAnalyzer results as JSON.

.EXAMPLE
  ```powershell
  .\Analyze.ps1 -Path .\Modules -Recurse
  ```

  Analyzes all PowerShell files under the specified directory recursively.

.NOTES
  Requires PowerShell 7 or later.
#>
using namespace System.IO

[CmdletBinding()]
param(
  [Parameter(Mandatory, Position = 0)]
  [ValidateScript({ Test-Path -LiteralPath $_ })]
  [string[]]
  $Path,
  [switch]
  $Recurse,
  [string]
  $Settings = 'PSScriptAnalyzerSettings.psd1'
)
if ($PSEdition -ne 'Core') {
  return
}
Set-StrictMode -Version Latest

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
  Install-Module -Name PSScriptAnalyzer -Force
}
if (-not [Path]::IsPathRooted($Settings)) {
  $Settings = $Settings = $PSScriptRoot | Join-Path -ChildPath 'PSScriptAnalyzerSettings.psd1'
}
Import-Module PSScriptAnalyzer -Force
Invoke-ScriptAnalyzer -EnableExit -Fix -Path ([WildcardPattern]::Escape($Path)) -Recurse:$Recurse -Settings $Settings -ReportSummary |
ConvertTo-Json -Depth 100
