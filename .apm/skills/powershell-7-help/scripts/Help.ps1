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

.OUTPUTS
  System.Management.Automation.PSObject
    The help object returned by Get-Help.
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
if ($PSEdition -ne 'Core') {
  return
}
Set-StrictMode -Version Latest

$arguments = @{
  Name = $Name
  Full = $Full
}
if ($Path) {
  $arguments['Path'] = $Path
}
$help = Get-Help @arguments
if (-not $help) {
  throw "No help found for command '$Name'."
}
$help
