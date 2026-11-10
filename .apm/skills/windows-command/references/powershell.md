# Recommended `powershell.exe` invocation options

When PowerShell 7 (`pwsh.exe`) starts Windows PowerShell (`powershell.exe`) directly, it removes PowerShell 7 module paths from the environment passed to Windows PowerShell.
This filtering does not happen when an intermediate process such as `cmd.exe` is involved.
`cmd.exe` inherits the unmodified `PSModulePath` from `pwsh.exe` and passes it to `powershell.exe`.
The resulting module path can contain duplicate entries or PowerShell 7 module paths that Windows PowerShell cannot load, which can break module auto-loading.

Clear `PSModulePath` before starting Windows PowerShell. Windows PowerShell then constructs its default module path at startup:

```powershell
cmd.exe /D /E:ON /V:OFF /S /C "set PSModulePath=&&  -NoLogo -NoProfile -File script.ps1"
```

This clears the variable only in the `cmd.exe` process and its child process; it does not change the environment of the current `pwsh.exe` session or the persistent user or system environment.
The [PowerShell launcher](../assets/powershell.cmd) in this skill uses this approach.

See [about_PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath?view=powershell-7.6) for details.
