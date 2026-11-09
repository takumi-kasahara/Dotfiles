# Cmdlet Guidelines

Use this checklist by section:

### Cmdlet Pattern

1. Pick the correct cmdlet pattern (`New-*`, `Get-*`, `Set-*`, `Remove-*`, `Export-*`, `Import-*`).

### Parameters and Behavior

1. Apply parameter and attribute rules from the parameter section.
2. If `SupportsShouldProcess` is enabled, verify `-WhatIf` and `-Confirm` behavior.

### Error Handling

1. Add clear, user-friendly terminating errors for invalid or unsupported parameter values, including valid alternatives.

- If using `[CmdletBinding(SupportsShouldProcess)]`, always implement `-WhatIf`/`-Confirm` behavior.
- Refer to existing similar functions and tests.
- If a parameter value is invalid or unsupported, throw a clear terminating error that states the issue and valid alternatives.

### Parameter Guidelines

- When adding `[CmdletBinding(SupportsShouldProcess)]`, follow official documentation:
  - Always call `$PSCmdlet.ShouldProcess()`.
  - Add `-WhatIf:$WhatIfPreference` to any command that supports `-WhatIf`.

#### `New-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`
    - Overwrite existing items when present.
    - If the target is a folder or another mismatched type when creating a file, throw an exception.
- `[string]$Path`
  - `[Alias('FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]`

#### `Get-*`

- `[string[]]$Path`
  - `[Parameter(Mandatory, Position = 0)]`
  - `[SupportsWildcards()]`
  - `[ValidateScript({ Test-Path -Path $_ })]`
- `[string[]]$LiteralPath`
  - `[Alias('PSPath', 'LP')]`
  - `[Parameter(Mandatory, ParameterSetName = 'LiteralPathSet', ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ })]`

#### `Set-*` / `Remove-*`

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

#### `Export-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`: ignore read-only attributes and overwrite.
  - `[switch]$NoClobber`: error if the file already exists.
    - If not specified, overwrite.
- `[string]$Path`
  - `[Alias('FilePath', 'FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]`

#### `Import-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`: ignore read-only attributes and overwrite.
- `[string]$Path`
  - `[Alias('FilePath', 'FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ })]`

### Resources

- [about_Functions_Advanced_Methods](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7.6)
- [about_Functions_Advanced_Parameters](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.6)
- [about_Functions_Argument_Completion](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-7.6)
- [about_Functions_CmdletBindingAttribute](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.6)
- [about_Functions_OutputTypeAttribute](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-7.6)
- [about_Wildcards](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.6)
- [Everything you wanted to know about ShouldProcess](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.6)
- [Cmdlet.ShouldProcess Method](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldprocess?view=powershellsdk-7.4.0)

#### Utility Modules

- [parse.ps1](../scripts/parse.ps1) parses PowerShell files.
- [analyze.ps1](../scripts/analyze.ps1) runs PSScriptAnalyzer.
- [Invoke-ScriptAnalyzer](https://learn.microsoft.com/en-us/powershell/module/psscriptanalyzer/invoke-scriptanalyzer?view=ps-modules)
- [Parser.ParseFile Method](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parsefile?view=powershellsdk-7.4.0)
