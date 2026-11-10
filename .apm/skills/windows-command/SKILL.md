---
name: windows-command
description: 'Guidelines for Windows Batch File (.bat) and Windows Command Script File (.cmd).'
argument-hint: 'Describe the batch file to create and any command-line arguments'
---

# Windows Command

Practical skill for creating Windows `*.bat`, `*.cmd` files that are reusable, robust, and maintainable.

## When to Use This Skill

- Creating a new `*.bat`, `*.cmd` file
- Refactoring an existing `*.bat` into a safe structure
- Unifying `for` / `if` / `setlocal` / label-based functions
- Stabilizing stdout/stderr handling
- Avoiding trailing-digit misinterpretation on lines that contain redirection

## Default Script Shape

Prefer the following skeleton:

1. `@echo off`
2. `setlocal enableextensions disabledelayedexpansion`
3. `:begin` / `:process` / `:end` labels
4. Terminate with `exit /B %errorlevel%`

For scripts that require elevation, perform a `net session` check and branch to elevation at the very top.

## Authoring Rules

### Control Flow

- Use `if (...) else (...)` for branching; name jump-target labels by role.
- Choose the loop form by purpose:
  - Numeric sequence: `for /L`
  - File/directory pattern: `for` (optionally `/D`, `/R`)
  - Line-by-line reading: `for /F`
  - Command-output iteration: `for /F "usebackq" %%I in (`command`) do (...)`

### Variables and Expansion

- Assign with `set "NAME=value"`.
- Command substitution via `for /F ... do set "NAME=%%I"`.
- Enable `setlocal enabledelayedexpansion` only where needed, scoped locally.
- Prefer `%VAR:~start,len%` and `%VAR:find=replace%` for string manipulation.

### Error Handling

- Verify external commands with `where /Q` + `if errorlevel 1 (...)`.
- Return the script's exit code to the caller with `exit /B %errorlevel%`.

## Redirection Policy

Redirection operators should be placed **at the front of the line** rather than at the traditional end.

- OK: `> "log.txt" echo %VAR%`
- NG: `echo %VAR% > "log.txt"`

Front placement avoids:

- Trailing digits in variable values being misinterpreted as redirection syntax
- Accidental whitespace insertion caused by `echo ... > file` spacing

Additional rules:

- When merging stdout and stderr to the same target, fix the order:
  - `> "log.txt" 2>&1`
- Use `2>nul` or `>nul 2>&1` for discarding, chosen by intent.
- With pipes, place redirection where the final result is captured.

## Snippet-Consistent Generation

### 1. Template scripts

- [run.cmd](./assets/run.cmd)
- [runas.cmd](./assets/runas.cmd)

### 2. Script idioms

Use `choice` + `goto` to turn a prompt into clear branches. This is the standard menu-style flow in the repo.

```bat
choice /C YN /M "Continue?"
goto :case_%errorlevel%
:case_1
:: yes branch
goto :end_case
:case_2
:: no branch
goto :end_case
:end_case
```

This collects positional arguments one by one and reassembles them for later use.

```bat
:loop
if "%~1"=="" goto :process
set args=%args% "%~1"
shift /1
goto :loop
```

Use `set /p` for inline prompt-like output without a trailing newline.

```bat
set /P ="Processing..."<nul
```

Use a label-based helper for a subroutine that returns with `exit /B`.

```bat
:: label-based helper
:subroutine
	rem add logic here.
	exit /B
:: end subroutine
```

### 3. Error-handling helpers

These are defensive checks that keep the script from failing in confusing ways.

```bat
where /Q command
if errorlevel 1 goto :end
```

Check whether an external command exists before using it. If missing, exit early instead of failing later with a vague error.

```bat
if "%~1"=="" goto :usage

:usage
echo USAGE: %~nx0 ARG1 ARG2
goto :end
```

Validate required arguments before continuing. This produces a clean usage message and avoids partial execution.

## Completion Checklist

- [ ] `@echo off` / `setlocal` are in the right places
- [ ] `:begin` $\rightarrow$ `:process` $\rightarrow$ `:end` flow is clear
- [ ] Argument validation and command-existence checks are present where needed
- [ ] Variable assignments use `set "name=value"` form
- [ ] Redirection follows the front-placement policy
- [ ] Exit code is returned via `exit /B %errorlevel%`

## Gotchas

- `%*` inside `if (...) else (...)` blocks breaks on parentheses in arguments
  — When `%*` expands to something containing `)` (e.g., `temp().txt`), it closes the block prematurely. Use `goto` labels instead of blocks for branching. See [Gotchas](./references/argument-expansion.md).

## Troubleshooting

| Symptom                                    | Remedy                                                                   |
| ------------------------------------------ | ------------------------------------------------------------------------ |
| Output breaks when value ends with a digit | Move redirection to the front (e.g., `> "log.txt" echo %VAR%`)           |
| Stderr not captured                        | Explicitly use `2>`; if merging, standardize on `> "log.txt" 2>&1` order |
| Loop variable not updating                 | Add `setlocal enabledelayedexpansion` and use `!VAR!`                    |
| Control flow breaks after subroutine       | Standardize on `exit /B` returns; verify `goto` target labels            |
| `.{ext} was unexpected at this time`       | Parentheses in `%*` broke an `if` block — use `goto` labels instead      |

## References

- [Launching Windows PowerShell from PowerShell 7 via CMD](./references/powershell.md)
- [Windows Commands](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands)
  - [cmd](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd)
