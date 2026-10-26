<#
.SYNOPSIS
  Parses PowerShell files and reports syntax errors.

.DESCRIPTION
  Uses System.Management.Automation.Language.Parser to parse each specified file and outputs any parse errors as JSON.

.PARAMETER Path
  One or more file paths to parse. Supports pipeline and remaining arguments.

.PARAMETER Include
  Specifies glob patterns to include. Only items matching at least one pattern are considered.
  Follows Get-ChildItem semantics.

.PARAMETER Exclude
  Specifies glob patterns to exclude. Items matching any pattern are excluded.
  Follows Get-ChildItem semantics.

.PARAMETER Recurse
  Searches the specified path recursively.

.EXAMPLE
  ```powershell
  .\Parse.ps1 -Path .\Script.ps1
  ```

  Parses the specified PowerShell file and reports any syntax errors.

.EXAMPLE
  ```powershell
  .\Parse.ps1 -Path .\Modules -Recurse
  ```

  Parses all PowerShell files under the specified directory recursively.

.NOTES
  Requires PowerShell 5.
#>
using namespace System.Management.Automation.Language

[CmdletBinding()]
param (
  [Parameter(Mandatory, Position = 0)]
  [ValidateScript({ Test-Path -LiteralPath $_ })]
  [string[]]
  $Path,
  [string[]]
  $Include,
  [string[]]
  $Exclude,
  [switch]
  $Recurse
)
if ($PSEdition -ne 'Desktop') {
  return
}
Set-StrictMode -Version Latest

$items = Get-Item -LiteralPath $Path -Force |
ForEach-Object {
  if ($_.PSIsContainer) {
    $arguments = @{
      LiteralPath = $_.FullName
      Recurse     = $Recurse.IsPresent
    }
    if ($Include) { $arguments['Include'] = $Include }
    if ($Exclude) { $arguments['Exclude'] = $Exclude }
    Get-ChildItem @arguments |
    Where-Object -Property Extension -In '.ps1', '.psm1', '.psd1'
  } elseif ($_.Extension -in '.ps1', '.psm1', '.psd1') {
    $includeMatch = $true
    if ($Include) {
      $includeMatch = $false
      foreach ($pattern in $Include) {
        if ($_.Name -like $pattern) { $includeMatch = $true; break }
      }
    }
    $excludeMatch = $false
    if ($Exclude) {
      foreach ($pattern in $Exclude) {
        if ($_.Name -like $pattern) { $excludeMatch = $true; break }
      }
    }
    if ($includeMatch -and -not $excludeMatch) { $_ }
  }
}
$results = $items |
ForEach-Object {
  $errors = $null
  # https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parsefile?view=powershellsdk-1.1.0
  [Parser]::ParseFile($_.FullName, [ref]$null, [ref]$errors) | Out-Null
  if ($errors -and $errors.Count -gt 0) {
    return $errors
  }
}
$results | ConvertTo-Json -Depth 100
if ($results) {
  "$($results.Length) parse errors found."
  exit $results.Length
} else {
  '0 parse errors found.'
  exit 0
}
