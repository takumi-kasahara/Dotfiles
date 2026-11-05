# Cmdlet Guidelines

## Parameter Guidelines

- When adding `[CmdletBinding(SupportsShouldProcess)]`, follow official documentation:
  - Always call `$PSCmdlet.ShouldProcess()`.
  - Add `-WhatIf:$WhatIfPreference` to any command that supports `-WhatIf`.

### `New-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`
    - Overwrite existing items when present.
    - If the target is a folder or another mismatched type when creating a file, throw an exception.
- `[string]$Path`
  - `[Alias('FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]`

### `Get-*`

- `[string[]]$Path`
  - `[Parameter(Mandatory, Position = 0)]`
  - `[SupportsWildcards()]`
  - `[ValidateScript({ Test-Path -Path $_ })]`
- `[string[]]$LiteralPath`
  - `[Alias('PSPath', 'LP')]`
  - `[Parameter(Mandatory, ParameterSetName = 'LiteralPathSet', ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ })]`

### `Set-*` / `Remove-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`: ignore read-only attributes and overwrite.
- `[string[]]$Path`
  - `[Parameter(Mandatory, ParameterSetName = 'PathSet', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[SupportsWildcards()]`
  - `[ValidateScript({ Test-Path -Path $_ })]`
- `[string[]]$LiteralPath`
  - `[Alias('PSPath', 'LP')]`
  - `[Parameter(Mandatory, ParameterSetName = 'LiteralPathSet', ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ })]`

### `Export-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`: ignore read-only attributes and overwrite.
  - `[switch]$NoClobber`: error if the file already exists.
    - If not specified, overwrite.
- `[string]$Path`
  - `[Alias('FilePath', 'FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]`

### `Import-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`: ignore read-only attributes and overwrite.
- `[string]$Path`
  - `[Alias('FilePath', 'FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ })]`

## Error Handling

Add clear, user-friendly terminating errors for invalid or unsupported parameter values, including valid alternatives.

- If using `[CmdletBinding(SupportsShouldProcess)]`, always implement `-WhatIf`/`-Confirm` behavior.
- Refer to existing similar functions and tests.
- If a parameter value is invalid or unsupported, throw a clear terminating error that states the issue and valid alternatives.

## Resources

- [about_Functions_Advanced_Methods](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-5.1)
- [about_Functions_Advanced_Parameters](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-5.1)
- [about_Functions_Argument_Completion](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-5.1)
- [about_Functions_CmdletBindingAttribute](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-5.1)
- [about_Functions_OutputTypeAttribute](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-5.1)
- [about_Wildcards](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-5.1)
- [Everything you wanted to know about ShouldProcess](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-5.1)
- [Cmdlet.ShouldProcess Method](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldprocess?view=powershellsdk-1.1.0)

## Utility Modules

- [Invoke-ScriptAnalyzer](https://learn.microsoft.com/en-us/powershell/module/psscriptanalyzer/invoke-scriptanalyzer?view=ps-modules)
- [Parser.ParseFile Method](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parsefile?view=powershellsdk-1.1.0)
