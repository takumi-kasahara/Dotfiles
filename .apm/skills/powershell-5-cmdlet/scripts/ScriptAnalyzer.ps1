[CmdletBinding()]
param(
  [Parameter(ValueFromRemainingArguments)]
  [SupportsWildcards()]
  [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
  [string[]]
  $Path,
  [string]
  $Settings = 'PSScriptAnalyzerSettings.psd1'
)
if ($PSEdition -ne 'Desktop') {
  return
}
Set-StrictMode -Version Latest

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
  Install-Module -Name PSScriptAnalyzer -Force
}
Import-Module PSScriptAnalyzer -Force
$results = Invoke-ScriptAnalyzer -Path $Path -Settings $Settings -Recurse -ReportSummary
$results | ConvertTo-Json
