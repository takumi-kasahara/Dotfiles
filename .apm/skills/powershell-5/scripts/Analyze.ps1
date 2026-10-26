<#
.SYNOPSIS
  Runs PSScriptAnalyzer on the specified path.

.DESCRIPTION
  Installs and imports PSScriptAnalyzer if needed, analyzes the given path(s) using the specified settings file,
  and outputs results as objects by default, or as JSON when -AsJson is specified.

.PARAMETER Path
  One or more paths to analyze. Wildcard characters are treated as literals and are not expanded.

.PARAMETER Settings
  Path to the PSScriptAnalyzer settings file. Defaults to PSScriptAnalyzerSettings.psd1.

.PARAMETER Recurse
  Analyzes all files under the specified path recursively.

.PARAMETER AsJson
  Outputs the analysis results as a JSON string. When omitted, outputs the raw results.

.EXAMPLE
  ```powershell
  .\Analyze.ps1 -Path .\Script.ps1
  ```

  Analyzes the specified PowerShell script and outputs PSScriptAnalyzer results.

.EXAMPLE
  ```powershell
  .\Analyze.ps1 -Path .\Script.ps1 -AsJson
  ```

  Analyzes the specified PowerShell script and outputs results as JSON.

.EXAMPLE
  ```powershell
  .\Analyze.ps1 -Path .\Modules -Recurse
  ```

  Analyzes all PowerShell files under the specified directory recursively.

.NOTES
  Requires PowerShell 5.
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
  $Settings = 'PSScriptAnalyzerSettings.psd1',
  [switch]
  $AsJson
)
if ($PSEdition -ne 'Desktop') {
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
$results = Invoke-ScriptAnalyzer -EnableExit -Fix -Path ([WildcardPattern]::Escape($Path)) -Recurse:$Recurse -Settings $Settings -ReportSummary
if ($AsJson) {
  $results | ConvertTo-Json -Depth 100
} else {
  $results
}
