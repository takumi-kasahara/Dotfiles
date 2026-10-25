<#
.SYNOPSIS
  Imports registry settings and runs configuration scripts.

.DESCRIPTION
  Imports all *.reg files under Windows\Settings recursively and runs all *.bat scripts under Windows\Scripts.
  Also copies user international settings to the welcome screen and new user profile, then restarts Explorer.

.NOTES
  Requires administrator privileges to import registry settings and modify system configuration.
#>
[CmdletBinding()]
param ()
Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

try {
  Get-ChildItem -LiteralPath 'Windows\Settings' -Filter '*.reg' -Recurse |
  ForEach-Object {
    $relative = Resolve-Path -LiteralPath $_ -Relative
    Write-Progress -Activity 'Importing registry settings' -Status $relative
    reg.exe import $_.FullName
    "Imported:`t$relative" | Out-Host
  }
  Get-ChildItem -LiteralPath 'Windows\Scripts' -Filter '*.bat' -Recurse |
  ForEach-Object {
    $relative = Resolve-Path -LiteralPath $_ -Relative
    Write-Progress -Activity 'Running scripts' -Status $relative
    cmd.exe /c `"$($_.FullName)`"
    "Ran:`t$relative" | Out-Host
  }
  Copy-UserInternationalSettingsToSystem -WelcomeScreen:$true -NewUser:$true
  taskkill.exe /IM explorer.exe /F >$null && Start-Process -FilePath explorer.exe
} finally {
  Write-Progress -Completed
}
