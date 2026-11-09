<#
.SYNOPSIS
  Generates Markdown command documentation for the repository PowerShell scripts.

.DESCRIPTION
  Generates or refreshes Markdown help files using PlatyPS (New-MarkdownCommandHelp) for all *.ps1 scripts found in the repository root and in selected skill script folders.
  Then applies Prettier formatting and markdownlint-cli2 auto-fixes to the generated Markdown files.
  The script changes its working directory to the script root before processing.

.NOTES
  Requires the platyPS (New-MarkdownCommandHelp) command to be available.
  Requires Node.js tooling for Prettier and markdownlint-cli2.
  Regenerated files are written in-place and may overwrite existing help files.
#>
[CmdletBinding()]
param ()
# Set-StrictMode -Version Latest
Set-Location -LiteralPath $PSScriptRoot

$docs = '.\Docs'
Get-ChildItem -Filter '*.ps1' |
ForEach-Object { Get-Command -Name $_ } |
ForEach-Object { New-MarkdownCommandHelp -CommandInfo $_ -OutputFolder $docs -Force }

npx.cmd prettier --write "$docs\**\*.md"
npx.cmd markdownlint-cli2 --fix "$docs\**\*.md"

@(
  '.\.apm\skills\autohotkey\scripts'
  '.\.apm\skills\powershell-5\scripts'
  '.\.apm\skills\powershell-7\scripts'

) |
ForEach-Object {
  $root = $_
  Get-ChildItem -Path ([WildcardPattern]::Escape($_) | Join-Path -ChildPath '*.ps1') -File |
  ForEach-Object { Get-Command -Name $_ } |
  ForEach-Object { New-MarkdownCommandHelp -CommandInfo $_ -OutputFolder $root -Force }
  npx.cmd prettier --write "$root\*.md"
  npx.cmd markdownlint-cli2 --fix "$root\*.md"
}
