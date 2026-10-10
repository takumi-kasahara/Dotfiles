---
name: csharp-for-powershell-5
description: Guidelines for C# code that can be loaded by PowerShell 5.1 Add-Type.
argument-hint: Describe the desired functionality and type overview for the C# file.
---

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
