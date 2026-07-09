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
}
finally {
  Write-Progress -Completed
}
