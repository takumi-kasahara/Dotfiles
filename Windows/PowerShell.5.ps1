Set-PSReadLineOption -HistoryNoDuplicates -HistorySearchCursorMovesToEnd -ShowToolTips
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
  Clear-Host
  Clear-History
  Clear-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath
} | Out-Null
if (Test-Path -LiteralPath "$env:LOCALAPPDATA\Programs") {
  $env:Path = "$env:LOCALAPPDATA\Programs;$env:Path"
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
  $branch = (git.exe rev-parse --abbrev-ref HEAD 2>$null) -replace 'HEAD', '(detached)'
  if ($branch) {
    $branch = " `e[1;36m($branch)`e[00m"
  }
  return "$env:USERNAME@$env:COMPUTERNAME $env:OS $($PWD -replace [regex]::Escape($env:USERPROFILE), '~')$branch`n$('>' * ($nestedPromptLevel + 1)) "
}
