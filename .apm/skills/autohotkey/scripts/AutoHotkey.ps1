<#
.SYNOPSIS
  Runs one or more AutoHotkey v2 scripts via AutoHotkey.exe.

.DESCRIPTION
  Finds AutoHotkey.exe on the system and uses it to execute the specified `.ahk` files.
  The script resolves AutoHotkey.exe from the PATH first, then falls back to a recursive search under $env:ProgramFiles.
  Output from each script is streamed to the console.

.PARAMETER Path
  One or more file paths to AutoHotkey script files.

.PARAMETER Include
  Specifies glob patterns to include. Only items matching at least one pattern are considered.

.PARAMETER Exclude
  Specifies glob patterns to exclude. Items matching any pattern are excluded.

.PARAMETER Recurse
  Searches the specified path recursively.

.PARAMETER Switches
  Additional switches to pass to AutoHotkey.exe. These are inserted before the script path.

.PARAMETER ArgumentList
  Additional arguments to pass to Script. These are forwarded after the script path.

.EXAMPLE
  ```powershell
  .\AutoHotkey.ps1 -Path .\Script.ahk
  ```

  Runs the specified AutoHotkey script from a clean PowerShell session.

.EXAMPLE
  ```powershell
  .\AutoHotkey.ps1 -Path .\Tests -Recurse
  ```

  Runs all AutoHotkey scripts under the specified directory recursively.

.EXAMPLE
  ```powershell
  .\AutoHotkey.ps1 -Path .\Script.ahk -Switches '/ErrorStdOut', '/Validate' -ArgumentList 'foo', 'bar', 'baz'
  ```

  Runs the specified AutoHotkey script with additional switches passed to AutoHotkey.exe before the script path, and additional arguments passed to AutoHotkey.exe after the script path.

.LINK
  - [Command Line Parameters](https://www.autohotkey.com/docs/v2/Scripts.htm#cmd)

.OUTPUTS
  None.
#>
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
  $Recurse,
  [string[]]
  $Switches = @('/ErrorStdOut'),
  [string[]]
  [Parameter(ValueFromRemainingArguments)]
  $ArgumentList
)
if ($PSEdition -ne 'Desktop') {
  return
}
Set-StrictMode -Version Latest

$ahk = @(where.exe AutoHotkey.exe)[0]
if (-not $ahk) {
  $ahk = @(where.exe /r $env:ProgramFiles AutoHotkey.exe 2>$null)[0]
}
if (-not $ahk) {
  throw 'AutoHotkey.exe not found.'
}

$items = Get-Item -LiteralPath $Path -Force |
ForEach-Object {
  if ($_.PSIsContainer) {
    $arguments = @{
      LiteralPath = $_.FullName
      Recurse     = $Recurse.IsPresent
    }
    if ($Include) {
      $arguments['Include'] = $Include
    }
    if ($Exclude) {
      $arguments['Exclude'] = $Exclude
    }
    Get-ChildItem @arguments |
    Where-Object -Property Extension -In '.ahk'
  } elseif ($_.Extension -in '.ahk') {
    $_
  }
}
$result = $items |
ForEach-Object {
  "Running:`t$_" | Out-Host
  & $ahk @Switches $_.FullName @ArgumentList 2>&1 | Out-Host
  return $LASTEXITCODE
}
$m = Measure-Object -InputObject $result -Maximum -Minimum
exit $m.Maximum -gt 0 -or $m.Minimum -lt 0
