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

- [Windows Script Host](<https://learn.microsoft.com/en-us/previous-versions/9bbdkx3k(v=vs.85)>)
  - [Object Model](<https://learn.microsoft.com/en-us/previous-versions/a74hyyw0(v=vs.85)>)
- [Windows Shell](https://learn.microsoft.com/en-us/windows/win32/shell/shell-entry)

## Windows Script File

WSF files are XML documents (start with `<?XML?>`) that group one or more scripts as "jobs".

### Elements

| Element         | Purpose                                                                    | Assets                                      |
| --------------- | -------------------------------------------------------------------------- | ------------------------------------------- |
| `<?xml?>`       | Declares the file is XML.                                                  |                                             |
| `<?job?>`       | Processing instruction for job-level error handling (e.g. `error="true"`). |                                             |
| `<package>`     | Wraps multiple `<job>` definitions in one file.                            | [package.wsf](./assets/package.wsf)         |
| `<job>`         | Marks the start/end of one script job; selected via `/Job:<id>`.           | [job.wsf](./assets/job.wsf)                 |
| `<script>`      | Holds the actual script source (JScript/VBScript).                         | [script.wsf](./assets/script.wsf)           |
| `<object>`      | Declares a COM object available to script.                                 | [object.wsf](./assets/object.wsf)           |
| `<reference>`   | Imports an external type library.                                          | [reference.wsf](./assets/reference.wsf)     |
| `<resource>`    | Stores text/numeric data kept out of the script source.                    | [resource.wsf](./assets/resource.wsf)       |
| `<runtime>`     | Groups the script's command-line arguments.                                | [runtime.wsf](./assets/runtime.wsf)         |
| `<named>`       | Declares a named argument (`/name:value`).                                 | [named.wsf](./assets/named.wsf)             |
| `<unnamed>`     | Declares an unnamed positional argument.                                   | [unnamed.wsf](./assets/unnamed.wsf)         |
| `<description>` | Help text shown by `ShowUsage()` or `/?`.                                  | [description.wsf](./assets/description.wsf) |
| `<example>`     | Self-documentation example for `ShowUsage()`.                              | [example.wsf](./assets/example.wsf)         |

### References

- [XML Elements](<https://learn.microsoft.com/en-us/previous-versions/x4d5a2tx(v=vs.85)>)

## Execute with `cscript.exe`

- `cscript.exe` runs scripts in a command-line environment where all console output is visible. This is the only host the agent uses.
- To inspect a script from a terminal, run it with `cscript.exe //NoLogo "script.js"`.
  - `//NoLogo` hides only the startup banner.
  - Leave off `//B` while diagnosing: batch mode suppresses alerts, script errors, and input prompts.
- To run a job in a Windows Script File (WSF), pass the matching job identifier with `//Job`. WSF files can contain multiple jobs and scripting engines; check the file's `<JobID>` before choosing the invocation.
- `//T:<seconds>` interrupts and ends a script after the limit. Use it only when a bounded run is useful; a timeout terminates the script rather than reporting a normal script-level failure.

### References

- [Windows Commands](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands)
  - [cscript](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cscript)
  - [wscript](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wscript)
