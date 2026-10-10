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

Get-ChildItem -LiteralPath $LiteralPath -Filter '*.ts' |
Where-Object { $_.Name -notlike '*.d.ts' } |
ForEach-Object {
  $source = [Path]::ChangeExtension($_.FullName, '.osts')
  $json = Get-Content -LiteralPath $source -Raw | ConvertFrom-Json
  $json.body = (Get-Content -LiteralPath $_.FullName -Raw).ToString()
  $content = $json | ConvertTo-Json -Compress
  [File]::WriteAllText($source, $content, [UTF8Encoding]::new($false))
  Get-Item -LiteralPath $source
}
