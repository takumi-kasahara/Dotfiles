---
name: windows-script-host
description: Guidelines for JScript File (*.js) and Windows Script File (*.wsf).
argument-hint: Describe the Windows Script Host file to execute and any command-line arguments.
---

# Windows Script Host

Windows Script Host (WSH) is a Windows administration tool.

## JScript File

- JScript (`.js`) file runs in the WSH; it is not a browser or Node.js program.
- Match the installed JScript engine, not current browser or Node.js syntax. Avoid modules, `require`, browser globals, and newer syntax unless the target WSH engine has been verified to support it.
- For COM automation, use `WScript.CreateObject('ProgID')` instead of `new ActiveXObject('ProgID')`. Both work the same functionally, but it is the conventional WSH style and is already used by the bundled scripts.
  - [Using COM Objects in Windows Script Host](https://learn.microsoft.com/en-us/windows/win32/com/using-com-objects-in-windows-script-host)

### References

- [Windows Scripting](<https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/bstcxhf7(v=vs.84)>)
- [Windows Script Host](<https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/9bbdkx3k(v=vs.84)>)
  - [Object Model](<https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/a74hyyw0(v=vs.84)>)
  - [Dictionary Object](<https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x4k5wbx4(v=vs.84)>)
  - [FileSystemObject](<https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/6kxy1a51(v=vs.84)>)
  - [Microsoft ActiveX Data Objects reference](https://learn.microsoft.com/en-us/office/client-developer/access/desktop-database-reference/microsoft-activex-data-objects-reference)
  - [Shell Objects for Scripting](https://learn.microsoft.com/en-us/windows/win32/shell/objects)
- [Run a command with elevated privileges](./assets/runas.js)
- [Recommended `cscript.exe` invocation options](./references/cmd.md)
- [Recommended `powershell.exe` invocation options](./references/powershell.md)

## Windows Script File

WSF files are XML documents (start with `<?xml?>`) that group one or more scripts as "jobs".

- `<?xml?>` must be the first element in the file. It puts the compiler into strict XML mode (case-sensitive names, quoted attribute values).
- `<?job error="true" debug="true"?>` enables error messages and the script debugger during development; both default to `false`.
- Enclose script source in a `<![CDATA[ ... ]]>` section when the `<?xml?>` declaration is present; otherwise the XML parser misinterprets `<`, `>`, and `&` in the script.

### Elements

| Element         | Purpose                                                            | Assets                                      |
| --------------- | ------------------------------------------------------------------ | ------------------------------------------- |
| `<?job?>`       | Enables job-level error handling and debugging.                    |                                             |
| `<?xml?>`       | Declares the file is XML.                                          |                                             |
| `<description>` | Help text shown by `ShowUsage()` or `/?`.                          | [runtime.wsf](./assets/wsf/runtime.wsf)     |
| `<example>`     | Self-documentation example for `ShowUsage()`.                      | [runtime.wsf](./assets/wsf/runtime.wsf)     |
| `<job>`         | Marks the start/end of one script job; selected via `/Job:<id>`.   | [package.wsf](./assets/wsf/package.wsf)     |
| `<named>`       | Declares a named argument (`/name:value`).                         | [named.wsf](./assets/wsf/named.wsf)         |
| `<object>`      | Declares a COM object available to script.                         | [object.wsf](./assets/wsf/object.wsf)       |
| `<package>`     | Wraps multiple `<job>` definitions in one file.                    | [package.wsf](./assets/wsf/package.wsf)     |
| `<reference>`   | Imports an external type library.                                  | [reference.wsf](./assets/wsf/reference.wsf) |
| `<resource>`    | Stores text or numeric data kept out of the script source.         | [resource.wsf](./assets/wsf/resource.wsf)   |
| `<runtime>`     | Groups the script's command-line arguments.                        | [runtime.wsf](./assets/wsf/runtime.wsf)     |
| `<script>`      | Holds the actual script source.                                    | [package.wsf](./assets/wsf/package.wsf)     |
| `<unnamed>`     | Declares an unnamed positional argument.                           | [unnamed.wsf](./assets/wsf/unnamed.wsf)     |
| `<usage>`       | Overrides the usage display; other `<runtime>` content is ignored. | [usage.wsf](./assets/wsf/usage.wsf)         |

### References

- [XML Elements](<https://learn.microsoft.com/en-us/previous-versions/x4d5a2tx(v=vs.85)>)

### References

- [XML Elements](<https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/30f5bff1(v=vs.84)>)
