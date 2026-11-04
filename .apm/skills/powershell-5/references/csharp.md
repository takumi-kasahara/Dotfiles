# C# for PowerShell

- The goal is for `Add-Type -LiteralPath '<file>.cs'` to succeed in compilation and loading for PowerShell 5.1.

## Guidelines

1. Constraint priority:
   1. .NET Framework API compatibility.
   2. PowerShell 5.1 `Add-Type` compilation compatibility.
   3. Minimal namespace usage.
2. If the request depends on unsupported APIs or features, explain the limitation and suggest a compatible alternative.
3. Generate C# source containing `public class` or `public static class`.
4. Include only namespaces that are actually used by the generated code.
   - Start with `using System;` when needed.
   - Common examples: `System`, `System.IO`, `System.Collections.Generic`.

## References

- [Add-Type](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type?view=powershell-5.1)
- [C# documentation](https://learn.microsoft.com/en-us/dotnet/csharp/tour-of-csharp/)
