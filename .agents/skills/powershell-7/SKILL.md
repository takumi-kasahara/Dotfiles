---
name: powershell-7
description: "PowerShell 7.6 coding guidelines. Use when: writing or editing *.ps1/*.psm1, adding functions, error handling, null checks, string formatting, path joining, .NET constructors, wildcard escaping. Enforces [CmdletBinding()], Set-StrictMode, ThrowTerminatingError, and safe path handling."
argument-hint: "Describe the PowerShell 7 script or function you are writing or editing."
user-invocable: true
---

# PowerShell 7.6 Coding Guidelines

Guidelines for writing and editing PowerShell 7.6 scripts and modules in this repository.

## When to Use This Skill

- Writing or editing any `*.ps1` or `*.psm1` file
- Creating a new function or cmdlet
- Adding or updating comment-based help
- Handling errors, null checks, string formatting, or path operations
- Constructing .NET objects
- Escaping wildcards before path cmdlets

## Critical Rules

- For editing cmdlets, load the `powershell-7-cmdlet` skill.
- For editing comment-based help, load the `powershell-7-help` skill.
- Use `[CmdletBinding()]` for every function.
- Use `Set-StrictMode -Version Latest` in every script.

## Best Practices

### Error Handling

- Do not use `Write-Error` for error handling. It writes to the error stream but does not stop execution.
- Use `$PSCmdlet.ThrowTerminatingError()` for error handling.

### Null Handling and Type Conversion Caveats

- Use `$null -eq $value` or `$null -ne $value` for null comparisons to avoid potential parsing issues.
- For null checks, use `[string]::IsNullOrEmpty($value)` for strings.

#### References

- [Everything you wanted to know about $null](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-null?view=powershell-7.6)

### Constructor

For .NET object construction, prefer using the `new` method of the class over `New-Object` cmdlet.

- Example:
  - OK: `[System.IO.FileInfo]::new('C:\folder\file.txt')`
  - NG: `New-Object System.IO.FileInfo 'C:\folder\file.txt'`

#### References

- [about_Object_Creation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_object_creation?view=powershell-7.6)

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

- [Convert-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/convert-path?view=powershell-7.6)
- [Resolve-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/resolve-path?view=powershell-7.6)

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

- [Split-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/split-path?view=powershell-7.6)
- [WildcardPattern.Escape(String) Method](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.wildcardpattern.escape?view=powershellsdk-7.4.0)

#### References

- [Join-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/join-path?view=powershell-7.6)

## References

- [Documentation](https://learn.microsoft.com/en-us/powershell/)
- [PowerShell Module Browser](https://learn.microsoft.com/en-us/powershell/module/)
- [PowerShell Gallery](https://www.powershellgallery.com/)
