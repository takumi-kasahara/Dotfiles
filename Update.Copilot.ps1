using namespace System.IO

[CmdletBinding()]
param ()

Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

$config = Import-PowerShellDataFile -LiteralPath 'Copilot.psd1'
$config.GetEnumerator() |
ForEach-Object {
  try {
    $temp = [Path]::GetTempFileName()
    Invoke-WebRequest -Uri $_.Value.Url -OutFile $temp
    $destination = $PSScriptRoot | Join-Path -ChildPath '.copilot' | Join-Path -ChildPath $_.Key
    if (Test-Path -LiteralPath $destination) {
      $oldHash = Get-FileHash -LiteralPath $destination
      $newHash = Get-FileHash -LiteralPath $temp
      if ($oldHash.Hash -eq $newHash.Hash) {
        "Skiped:`t$($_.Key)" | Out-Host
        return
      }
    }
    else {
      $parent = [WildcardPattern]::Escape($destination) | Split-Path -Parent
      if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
      }
    }
    Move-Item -LiteralPath $temp -Destination $destination -Force -PassThru
  }
  finally {
    if (Test-Path -LiteralPath $temp) {
      Remove-Item -LiteralPath $temp
    }
  }
}
