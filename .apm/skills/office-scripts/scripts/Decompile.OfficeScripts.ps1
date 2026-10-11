using namespace System.IO
using namespace System.Management.Automation
using namespace System.Text

[CmdletBinding()]
param (
  [Parameter(Mandatory, Position = 0)]
  [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
  [string]
  $LiteralPath
)
Set-StrictMode -Version Latest

$target = (Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders').Personal | Join-Path -ChildPath 'Office Scripts'
if (-not (Test-Path -LiteralPath $target)) {
  throw [ItemNotFoundException]::new("$target not found.")
}
Copy-Item -Path ([WildcardPattern]::Escape($target) | Join-Path -ChildPath '*.osts') -Destination $LiteralPath -PassThru

Get-ChildItem -LiteralPath $LiteralPath -Filter '*.osts' |
ForEach-Object {
  $destination = [Path]::ChangeExtension($_.FullName, '.ts')
  $content = Get-Content -Path $_.FullName | ConvertFrom-Json
  $normalized = $content.body -replace "`r`n", "`n"
  [File]::WriteAllText($destination, $normalized, [UTF8Encoding]::new($false))
  Get-Item -Path $destination
}
