# Comment-Based Help

Follow these steps in order:

1. Core sections: update `.SYNOPSIS` and `.DESCRIPTION`.
2. Parameters: update each `.PARAMETER <Name>` in function-signature order.
3. Supporting sections: add or refresh `.EXAMPLE`, `.OUTPUTS`, and `.NOTES`.
4. Validation: verify with `Get-Help [-Path <Path>] -Name <Name> -Full`.

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

## References

- [about_Comment_Based_Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.6)
- [Get-Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help?view=powershell-7.6)
