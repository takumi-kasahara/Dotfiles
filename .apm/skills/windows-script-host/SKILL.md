---
name: windows-script-host
description: Best practices for Windows Script Host JScript (.js) and Windows Script Files (.wsf).
argument-hint: Describe the Windows Script Host file to execute and any command-line arguments.
---

# Windows Script Host

- WSH `.js` file runs in Microsoft's legacy JScript engine, with host objects such as `WScript` and COM automation through `ActiveXObject`; it is not a browser or Node.js program.
- Match the installed JScript engine, not current browser or Node.js syntax. Avoid modules, `require`, browser globals, and newer syntax unless the target WSH engine has been verified to support it.

## Execute with cscript.exe

- `cscript.exe` runs scripts in a command-line environment where all console output is visible. This is the only host the agent uses.
- To inspect a script from a terminal, run it with `cscript.exe //NoLogo "script.js"`.
  - `//NoLogo` hides only the startup banner.
  - Leave off `//B` while diagnosing: batch mode suppresses alerts, script errors, and input prompts.
- To run a job in a Windows Script File (WSF), pass the matching job identifier with `//Job`. WSF files can contain multiple jobs and scripting engines; check the file's `<job id>` before choosing the invocation.
- `//T:<seconds>` interrupts and ends a script after the limit. Use it only when a bounded run is useful; a timeout terminates the script rather than reporting a normal script-level failure.

## References

- [Windows Script Host overview and object model](<https://learn.microsoft.com/en-us/previous-versions//9bbdkx3k(v=vs.85)>)
  - [cscript](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cscript)
  - [Object Model](<https://learn.microsoft.com/en-us/previous-versions//a74hyyw0(v=vs.85)>)
  - [XML Elements](<https://learn.microsoft.com/en-us/previous-versions//x4d5a2tx(v=vs.85)>)
- [Using COM Objects in Windows Script Host](https://learn.microsoft.com/en-us/windows/win32/com/using-com-objects-in-windows-script-host)
