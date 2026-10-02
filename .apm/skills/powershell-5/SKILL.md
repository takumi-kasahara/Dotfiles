---
name: powershell-5
description: "PowerShell 5.1 coding, cmdlet, comment-based help, and Pester v6 guidance. Use when writing or editing *.ps1/*.psm1 files, creating or updating functions/cmdlets, documenting commands, or creating tests. Covers parameter design, ShouldProcess, terminating errors, null checks, safe paths, and testing."
argument-hint: "Describe the PowerShell 5.1 script or function you are writing or editing."
user-invocable: true
---

# PowerShell 5.1 Coding Guidelines

Guidelines for writing and editing PowerShell 5.1 scripts and modules in this repository.

## When to Use This Skill

- Writing or editing any `*.ps1` or `*.psm1` file
- Creating a new function or cmdlet
- Adding or updating comment-based help
- Handling errors, null checks, string formatting, or path operations
- Constructing .NET objects
- Escaping wildcards before path cmdlets

## Critical Rules

- Use `[CmdletBinding()]` for every function.
- Use `Set-StrictMode -Version Latest` in every script.
- For cmdlets, comment-based help, and Pester v6 tests, follow the corresponding sections below.

## Best Practices

### Error Handling

- Do not use `Write-Error` for error handling. It writes to the error stream but does not stop execution.
- Use `$PSCmdlet.ThrowTerminatingError()` for error handling.

### Null Handling and Type Conversion Caveats

- Use `$null -eq $value` or `$null -ne $value` for null comparisons to avoid potential parsing issues.
- For null checks, use `[string]::IsNullOrEmpty($value)` for strings.

#### References

- [Everything you wanted to know about $null](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-null?view=powershell-5.1)

### Constructor

For .NET object construction, prefer using the `new` method of the class over `New-Object` cmdlet.

- Example:
  - OK: `[System.IO.FileInfo]::new('C:\folder\file.txt')`
  - NG: `New-Object System.IO.FileInfo 'C:\folder\file.txt'`

#### References

- [about_Object_Creation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_object_creation?view=powershell-5.1)

### String Formatting

For simple string formatting, prefer string interpolation (expansion) syntax.
Do not use `+` for string concatenation.

- Example:
  - OK: `"value: $value"`
  - OK: `"value: {0:0.0}" -f $value`
  - NG: `"value: {0}" -f $value`
  - NG: `"value: " + $value`

### Path Resolution

- For paths that may not exist at runtime, prefer `System.IO.Path` methods.
- `Convert-Path` and `Resolve-Path` throw exceptions when the target path does not exist.
- Use these cmdlets only when the path is guaranteed to exist.

#### Examples

- OK: `if (Test-Path -LiteralPath $existingPath) { Convert-Path -Path $existingPath }`
- OK: `$item = Get-Item -LiteralPath $existingPath; Resolve-Path -LiteralPath $item.FullName`
- OK: `[Path]::GetFullPath($mayNotExistPath)`
- NG: `Convert-Path -Path $mayNotExistPath`
- NG: `Resolve-Path -Path $mayNotExistPath`

#### References

- [Convert-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/convert-path?view=powershell-5.1)
- [Resolve-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/resolve-path?view=powershell-5.1)

### Path Joining

- When joining paths, prefer passing the path through the pipeline into `Join-Path -ChildPath`.
- This style is especially useful when concatenating multiple segments or chaining path construction.

#### Examples

    - OK: `$PSScriptRoot | Join-Path -ChildPath 'src' | Join-Path -ChildPath 'module.psm1'`
    - NG: `Join-Path $PSScriptRoot 'src\module.psm1'`
    - NG: `Join-Path -Path $PSScriptRoot -ChildPath 'src\module.psm1'`

### Wildcard Handling

- `Split-Path` accepts wildcard patterns through `-Path`, and passing an uncertain input via the pipeline can cause unexpected behavior.
- Escape path values with `[WildcardPattern]::Escape(String)` before calling `Split-Path`.

#### Examples

- OK: `[WildcardPattern]::Escape($path) | Split-Path -Extension`
- NG: `Split-Path -Path $path -Extension`

#### References

- [Split-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/split-path?view=powershell-5.1)
- [WildcardPattern.Escape(String) Method](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.wildcardpattern.escape?view=powershellsdk-1.1.0)

#### References

- [Join-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/join-path?view=powershell-5.1)

## References

- [Documentation](https://learn.microsoft.com/en-us/powershell/)
- [PowerShell Module Browser](https://learn.microsoft.com/en-us/powershell/module/)
- [PowerShell Gallery](https://www.powershellgallery.com/)

## Cmdlet Guidelines

Use this checklist by section:

### Cmdlet Pattern

1. Pick the correct cmdlet pattern (`New-*`, `Get-*`, `Set-*`, `Remove-*`, `Export-*`, `Import-*`).

### Parameters and Behavior

2. Apply parameter and attribute rules from the parameter section.
3. If `SupportsShouldProcess` is enabled, verify `-WhatIf` and `-Confirm` behavior.

### Error Handling

4. Add clear, user-friendly terminating errors for invalid or unsupported parameter values, including valid alternatives.

- Follow parameter naming and attribute usage conventions from the official PowerShell docs: https://learn.microsoft.com/powershell/.
- If using `[CmdletBinding(SupportsShouldProcess)]`, always implement `-WhatIf`/`-Confirm` behavior.
- Refer to existing similar functions and tests.
- If a parameter value is invalid or unsupported, throw a clear terminating error that states the issue and valid alternatives.

### Parameter Guidelines

- When adding `[CmdletBinding(SupportsShouldProcess)]`, follow official documentation
  - Always call `$PSCmdlet.ShouldProcess()`
  - Add `-WhatIf:$WhatIfPreference` to any command that supports `-WhatIf`

#### `New-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`
    - Overwrite existing items when present
    - If the target is a folder or another mismatched type when creating a file, throw an exception
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
  - `[switch]$Force`: ignore read-only attributes and overwrite
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
  - `[switch]$Force`: ignore read-only attributes and overwrite
  - `[switch]$NoClobber`: error if the file already exists
    - If not specified, overwrite
- `[string]$Path`
  - `[Alias('FilePath', 'FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]`

#### `Import-*`

- `[CmdletBinding(SupportsShouldProcess)]`
  - `[switch]$Force`: ignore read-only attributes and overwrite
- `[string]$Path`
  - `[Alias('FilePath', 'FullName')]`
  - `[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]`
  - `[ValidateScript({ Test-Path -LiteralPath $_ })]`

### Cmdlet Resources

- See the [cmdlet reference](./references/powershell-cmdlet.md).
- Use [ParseFile.ps1](./scripts/ParseFile.ps1) to parse PowerShell files.
- Use [ScriptAnalyzer.ps1](./scripts/ScriptAnalyzer.ps1) for PSScriptAnalyzer.

## Comment-Based Help

Follow these steps in order:

1. Core sections: update `.SYNOPSIS` and `.DESCRIPTION`.
2. Parameters: update each `.PARAMETER <Name>` in function-signature order.
3. Supporting sections: add or refresh `.EXAMPLE`, `.OUTPUTS`, and `.NOTES`.
4. Validation: verify with `Get-Help [-Path <Path>] -Name <Name> -Full`.

- Follow the official PowerShell comment-based help documentation: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help.
- `.SYNOPSIS` should describe the function purpose concisely.
- `.DESCRIPTION` should describe behavior details, notes, and overall `ShouldProcess` behavior.
- `.PARAMETER <Name>` should match the parameter definition in the function signature, including order, type, and required/optional behavior.
- `.EXAMPLE` should include usage examples, scenarios, and results.
- `.OUTPUTS` should include the output type FQCN (Fully Qualified Class Name) and meaning.
  - Example:
    - `[OutputType([void])]`: `.OUTPUTS None.`
    - `[OutputType([string])]`: `.OUTPUTS System.String`
    - `[OutputType([string[]])]`: `.OUTPUTS System.String[]`
    - `[OutputType([System.IO.FileInfo])]`: `.OUTPUTS System.IO.FileInfo`
- `.NOTES` should include supplementary information or caveats.
- After editing, always verify output with `Get-Help [-Path <Path>] -Name <Name> -Full`.

### Help Resource

- Use [Help.ps1](./scripts/Help.ps1) to automate verification.
- See the [comment-based help reference](./references/comment-based-help.md).

## Pester v6 Tests

### Organization and Coverage

- Organize Pester tests with `Describe`, `Context`, and `It` blocks, creating one `Describe` block per function.
- Put helper functions in the `Describe` block's `BeforeAll`.
- Divide `Context` into these five categories:
  - `ParameterSetName`
    - Cover all `ParameterSetNames`.
    - If there is no `ParameterSetName`, cover mandatory parameters.
    - For parameters with `SupportsWildcards()`, test values containing wildcards.
  - `Output`
    - Verify the shape of the objects returned by the function (the normal-case result).
    - Cover count (`Should-BeCollection -Count`), property names, property values, and property types.
    - Example: verify a parsed entry exposes `Path`, `CreationTime`, `LastWriteTime` with correct values.
    - Distinguish from `Edge case`: `Output` checks the result shape in normal cases; `Edge case` checks behavior under boundary or invalid input.
  - `SupportsShouldProcess`
    - Apply this section only when `CmdletBinding(SupportsShouldProcess)` is present.
    - Required cases (run in order):
      1. Verify no side effects occur with `-WhatIf`.
      2. Verify the command runs when `-Confirm` is accepted.
      3. Verify the command does not run when `-Confirm` is declined.
    - Notes:
      - Since mocking `$PSCmdlet.ShouldProcess()` is difficult, review this in code review.
      - When `ConfirmImpact` is `High`, suppress the dialog by testing with `-Confirm:$false`.
    - Optional cases:
      - Verify `-Force` takes precedence over `-Confirm`.
      - Verify existing files are not overwritten with `-NoClobber`.
  - `Other parameters`
    - Parameters not covered by `ParameterSetName` or `SupportsShouldProcess`.
    - Add tests for defaults, aliases, and accepted input shapes.
  - `Edge cases`
    - Add boundary and error-case tests.
    - Example: minimum/maximum numeric values, read-only target file behavior.
    - Do not test constraints defined by `Parameter` or `Validate*` attributes.
- When changing existing code, run only related tests and verify behavior.

### Pester Mock Best Practices

- Declare Mocks inside `BeforeAll` or `It` blocks.
- A Mock declared in `BeforeAll` applies to all test cases in the same `Describe` block.
- A Mock declared in an `It` block applies only to that test case.
- Always mock functions called by `ValidationScript` or operations with significant side effects, such as file operations or external program execution.
  - Example: always mock validation functions like `Test-Path`.
- Use primitive types or objects created by `[PSCustomObject]` for Mock return values.
  - Example:
    - OK: `Mock -CommandName Test-Path -MockWith { $true }`
    - OK: `Mock -CommandName Get-Item -MockWith { [PSCustomObject]@{ FullName = 'C:\file.txt' } }`
    - NG: `Mock -CommandName Get-Item -MockWith { [System.IO.FileInfo]::new('C:\file.txt') }`
- Use `-ParameterFilter` to simulate behavior for specific arguments. This avoids needing `param()` inside `-MockWith`.
  - Example: `Mock -CommandName Get-Item -ParameterFilter { $Path -eq '*.txt' }`

### Pester Resource

- Use [Pester.ps1](./scripts/Pester.ps1) for tests.
- See the [Pester reference](./references/powershell-pester.md).
