Set-PSReadLineOption -HistoryNoDuplicates -HistorySearchCursorMovesToEnd -ShowToolTips
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
  Clear-Host
  Clear-History
  Clear-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath
} | Out-Null
if (Test-Path -LiteralPath "$env:LOCALAPPDATA\Programs") {
  $env:Path = "$env:LOCALAPPDATA\Programs;$env:Path"
}
if (Test-Path -LiteralPath "$env:USERPROFILE\.local\bin") {
  $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
}
if ($null -ne $env:ChocolateyInstall) {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path -LiteralPath $ChocolateyProfile) {
    Import-Module -Name $ChocolateyProfile
  }
}
if ((Get-Command -Name gh.exe -ErrorAction SilentlyContinue)) {
  Invoke-Expression -Command $(gh.exe completion --shell powershell | Out-String)
}
function prompt {
  return "$env:USERNAME@$env:COMPUTERNAME $env:OS $($PWD -replace [regex]::Escape($env:USERPROFILE), '~')`n$('>' * ($nestedPromptLevel + 1)) "
}
