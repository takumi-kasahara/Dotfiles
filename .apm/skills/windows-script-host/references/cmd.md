# Recommended `cscript.exe` Invocation Options

When launching a script with Windows Script Host non-interactively — for example, from a batch file or from another shell — use:

```bat
cscript //B //Nologo "<script>" <args>
```

Each option removes a source of noise or interactivity. The defaults are not always what a scripted invocation wants.

## `//B`

**What it does:** Specifies batch mode, which does not display alerts, scripting errors, or input prompts. The default is `//I` (interactive mode), which displays alerts, scripting errors, and input prompts.

**Why:** A non-interactive caller has no one to answer a prompt or dismiss an alert. Without `//B`, a script that calls `WScript.Echo` with a prompt, or a cmdlet that raises an alert, would block waiting on the console. With `//B`, those interactive features are suppressed so the script runs to completion without human intervention. This is useful for scheduled tasks and CI/CD pipelines.

**Caveat:** `//B` also suppresses scripting errors. A failing script may exit silently with no visible diagnostic. Leave `//B` off while diagnosing a script, and add it back once the script is known to work.

## `//Nologo`

**What it does:** Specifies that the Windows Script Host banner is not displayed before the script runs. The default is `//Logo`, which displays the banner.

**Why:** The banner is noise for a scripted invocation. Suppressing it keeps stdout clean for callers that parse output, capture logs, or compare results, and avoids confusing downstream tooling that expects only the script's output.

## Notes

- `cscript.exe` options use a double slash (`//`); arguments passed to the script use a single slash (`/`).
- `//T:<seconds>` specifies the maximum time the script can run (up to 32,767 seconds). When the run time exceeds the limit, `cscript` interrupts the script engine and ends the process. Use it only when a bounded run is useful; a timeout terminates the script rather than reporting a normal script-level failure.
- `//Job:<identifier>` runs the job identified by `<identifier>` in a `.wsf` script file. WSF files can contain multiple jobs and scripting engines; check the file's `<JobID>` before choosing the invocation.
- `//E:<engine>` specifies the engine used to run the script.
- `//U` specifies Unicode for input and output that is redirected from the console.
- `//S` saves the current command-prompt options for the current user.
- `//H:cscript` registers `cscript.exe` as the default script host; `//H:wscript` registers `wscript.exe` (the default).
- `//D` starts the debugger; `//X` starts the script in the debugger.
- `//?` displays the available command parameters and help.
- `cscript.exe` runs scripts in a command-line environment where all console output is visible. `wscript.exe` is the GUI host and is not suitable for scripted invocations.

## Summary

| Option     | Effect                                    | Default                 | Why it is set explicitly                    |
| ---------- | ----------------------------------------- | ----------------------- | ------------------------------------------- |
| `//B`      | Batch mode: no alerts, errors, or prompts | `//I` (interactive)     | Prevents hangs in scheduled tasks and CI/CD |
| `//Nologo` | Hides the Windows Script Host banner      | `//Logo` (banner shown) | Keeps stdout clean for parsing and logging  |

## Reference

- [cscript](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cscript)
- [wscript](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wscript)
