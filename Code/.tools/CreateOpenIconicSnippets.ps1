using namespace System.IO

[CmdletBinding()]
param ()

Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

$temp = New-Item -Path ($env:TEMP | Join-Path -ChildPath ([Path]::GetRandomFileName())) -ItemType Directory
try {
  git.exe clone https://github.com/iconic/open-iconic.git $temp
  $snippets = [PSCustomObject]@{}
  $temp |
  Join-Path -ChildPath 'svg' |
  Get-ChildItem |
  Sort-Object -Property BaseName |
  ForEach-Object {
    $base = $_.BaseName
    Add-Member -InputObject $snippets -MemberType NoteProperty -Name "OpenIconic.$base" -Value (
      [ordered]@{
        prefix      = "&$base"
        body        = "<&$base>"
        description = "$base"
        scope       = 'diagram'
      }
    )
  }
  $snippets |
  ConvertTo-Json -Depth 100 |
  Out-File -FilePath ('..\snippets' | Join-Path -ChildPath 'OpenIconic.code-snippets')
}
finally {
  if (Test-Path -LiteralPath $temp) {
    Remove-Item -LiteralPath $temp -Recurse
  }
}
