[CmdletBinding()]
param()

Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

$snippets = [ordered]@{}
$json = (Invoke-WebRequest -Uri 'https://html.spec.whatwg.org/entities.json').Content |
ConvertFrom-Json -Depth 100 -AsHashtable
foreach ($entry in $json.GetEnumerator() | Sort-Object -Property Name) {
  $snippet = [ordered]@{}
  $snippet.Add('prefix', $entry.Key)
  $snippet.Add('body', $entry.Value.characters)
  $snippet.Add('scope', 'html,markdown')
  $snippets.Add($entry.Key, $snippet)
}
$snippets |
ConvertTo-Json -Depth 100 |
Out-File -FilePath ('..\snippets' | Join-Path -ChildPath 'EntityReference.code-snippets')
