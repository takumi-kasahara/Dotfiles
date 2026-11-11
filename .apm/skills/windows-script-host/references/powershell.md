# Recommended `powershell.exe` invocation options

When PowerShell 7 (`pwsh.exe`) starts Windows PowerShell (`powershell.exe`) directly, it removes PowerShell 7 module paths from the environment passed to Windows PowerShell.
This filtering does not happen when an intermediate process such as `cscript.exe` is involved.
`cscript.exe` inherits the unmodified `PSModulePath` from `pwsh.exe` and passes it to `powershell.exe`.
The resulting module path can contain duplicate entries or PowerShell 7 module paths that Windows PowerShell cannot load, which can break module auto-loading.

Clear `PSModulePath` before starting Windows PowerShell. Windows PowerShell then constructs its default module path at startup:

```js
WshShell.Environment('Process').Remove('PSModulePath');
WScript.Quit(
  WshShell.Run(
    'powershell -NoLogo -NoProfile -NonInteractive -File "script.ps1"',
    0,
    true,
  ),
);
```

This clears the variable only in the `cscript.exe` process and its child process; it does not change the environment of the current `pwsh.exe` session or the persistent user or system environment. The [PowerShell launcher](../assets/powershell.js) in this skill uses this approach.

See [about_PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath?view=powershell-7.6#starting-windows-powershell-from-powershell-7) for details.
