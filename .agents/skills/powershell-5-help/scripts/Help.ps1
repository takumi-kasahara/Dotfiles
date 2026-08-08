#Requires -Version 5.1

<#
.SYNOPSIS
    Verifies that comment-based help is available for a PowerShell command.

.DESCRIPTION
    Wraps Get-Help to confirm that a function, cmdlet, or script has
    discoverable help content. Returns the help object when found, or
    throws a terminating error when help is missing.

.PARAMETER Name
    The name of the command to inspect. This may be a function, cmdlet,
    alias, or external script.

.PARAMETER Path
    Optional path to a module or script file that contains the command.
    When omitted, Get-Help searches all loaded modules and the session
    command table.

.PARAMETER Full
    When specified, returns the full help topic including parameters,
    examples, and notes. Otherwise, returns the abbreviated help topic.

.EXAMPLE
    PS> .\Help.ps1 -Name Get-Process

    Verifies that the built-in Get-Process cmdlet has help content.

.EXAMPLE
    PS> .\Help.ps1 -Name ConvertTo-Json -Full

    Returns the full help topic for ConvertTo-Json.

.EXAMPLE
    PS> .\Help.ps1 -Name My-Function -Path .\MyModule.psm1 -Full

    Verifies help for My-Function inside the specified module file.

.OUTPUTS System.Management.Automation.PSObject
    The help object returned by Get-Help.

.NOTES
    This script is intended for use with the powershell-5-help skill as a
    post-edit validation step. It exits with code 0 when help is found and
    a non-zero code when help is missing or an error occurs.
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory, Position = 0)]
  [string]$Name,

  [Parameter(Position = 1)]
  [string]$Path,

  [Parameter()]
  [switch]$Full
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$getHelpParams = @{
  Name = $Name
  Full = $Full
}

if ($Path) {
  $getHelpParams['Path'] = $Path
}

$help = Get-Help @getHelpParams

if (-not $help) {
  throw "No help found for command '$Name'."
}

if ($help -is [System.Management.Automation.ErrorRecord] -or
  ($help.PSTypeNames -contains 'System.Management.Automation.ErrorRecord')) {
  throw "Get-Help returned an error for command '$Name'."
}

$help
