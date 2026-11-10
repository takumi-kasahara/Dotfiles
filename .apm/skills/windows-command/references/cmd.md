# Recommended `cmd.exe` Invocation Options

When launching `cmd.exe` non-interactively — for example, from PowerShell to bridge into Windows PowerShell, or to run a batch file — use:

```bat
cmd /D /E:ON /V:OFF /S /C "<command>"
```

Each option removes a source of nondeterminism. The defaults are not always what a scripted invocation wants, and registry settings can change them.

## `/D` — Disable AutoRun

**What it does:** Disables execution of AutoRun commands.

**Why:** Without `/D`, `cmd` looks up the following registry subkeys and executes them before anything else:

- `HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\AutoRun` (`REG_SZ` or `REG_EXPAND_SZ`)
- `HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun` (`REG_SZ` or `REG_EXPAND_SZ`)

AutoRun is a per-machine and per-user customization intended for interactive sessions. In a scripted invocation it can print unexpected output, fail, or mutate state before your command runs. `/D` makes the invocation independent of those registry values. This is one of the two options in the set that is **not** the default (the other is `/S`).

## `/E:ON` — Enable command extensions

**What it does:** Enables command extensions.

**Why:** Extensions change the behavior of `assoc`, `call`, `cd`, `color`, `del`, `endlocal`, `for`, `ftype`, `goto`, `if`, `mkdir`, `popd`, `prompt`, `pushd`, `set`, `setlocal`, `shift`, and `start`. They are enabled by default, but they can be disabled per machine or per user via:

- `HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\EnableExtensions` (`REG_DWORD`, `0x1` = enabled, `0x0` = disabled)
- `HKEY_CURRENT_USER\Software\Microsoft\Command Processor\EnableExtensions` (`REG_DWORD`)

User-specified settings take precedence over computer settings, and **command-line options take precedence over registry settings**. Passing `/E:ON` guarantees the extended behavior that batch scripts rely on, regardless of registry state.

## `/V:OFF` — Disable delayed environment variable expansion

**What it does:** Disables delayed environment variable expansion.

**Why:** With delayed expansion enabled, `!VAR!` is expanded at run time instead of at parse time. That makes `!` a special character, so a literal `!` in the command string — in an argument, a password, or `echo` text — would be interpreted as a variable delimiter and mangled or removed. Scripted invocations rarely need delayed expansion (a batch file can opt in locally with `setlocal enabledelayedexpansion`), so `/V:OFF` keeps `!` literal and the command string predictable. This is the default, made explicit.

## `/S` — Strip the outermost quotes

**What it does:** When used with `/C` or `/K`, triggers special non-parsing rules that strip the first and last quotes (`"`) around `<string>` but leave the rest of the command unchanged.

**Why:** Without `/S`, whether the quotes around `<string>` are preserved depends on a heuristic. The quotes are preserved only if **all** of the following hold:

- `/S` is not used
- exactly one set of quotation marks is present
- no special characters (`& < > ( ) @ ^ |`) appear within the quotes
- one or more white-space characters appear within the quotes
- the quoted `<string>` is the name of an executable file

## `/C` — Run and exit

**What it does:** Carries out the command specified by `<string>` and then exits the command processor.

**Why:** A non-interactive invocation should return control to the caller when the command finishes, with the command's exit code observable via `%ERRORLEVEL%`. `/K` would keep the command processor running, which is only useful for interactive sessions.

## Summary

| Option   | Effect                     | Default                    | Why it is set explicitly                                |
| -------- | -------------------------- | -------------------------- | ------------------------------------------------------- |
| `/D`     | Disables AutoRun           | off (AutoRun runs)         | AutoRun is a per-user/machine side effect               |
| `/E:ON`  | Enables command extensions | on                         | Command-line flags take precedence over the registry    |
| `/V:OFF` | Disables delayed expansion | off                        | Keeps `!` literal in programmatically built strings     |
| `/S`     | Strips outermost quotes    | off (heuristic)            | Makes quote handling deterministic for compound strings |
| `/C`     | Runs the command and exits | n/a (required for scripts) | Returns control and the exit code to the caller         |

## Reference

- [cmd](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd)
