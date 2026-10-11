---
name: autohotkey
description: Guidelines for AutoHotkey v2 coding or testing.
argument-hint: Describe the AutoHotkey v2 script or function and its expected behavior
---

# AutoHotkey v2 Coding Guidelines

Guidelines for writing and editing AutoHotkey v2 scripts in this repository.

## Compatibility

1. Target environment is Windows 11.
2. AutoHotkey version is v2.

## Coding Style

### Variable Naming

- Use `lowerCamelCase` for variable names.
  - Avoid reassignment unless it significantly improves performance or is required for compatibility with external libraries.
- Use `UPPER_SNAKE_CASE` for constants.

### Function Naming

- Use the `FileName_FunctionName` format for function names.

### Equality Operators

- **Prohibited**: `=` and `!=` operators for equality/inequality checks.
- **Required**: Use `==` for equality and `!==` for inequality.
  - [Equality Operators](https://www.autohotkey.com/docs/v2/Variables.htm#equal)
- `=` performs case-insensitive string comparison, which can lead to unexpected behavior.
- `==` performs strict equality comparison (type and value).
- `!==` performs strict inequality comparison (type and value).

```autohotkey
; NG: Case-insensitive comparison (prohibited)
if value = "hello"
  MsgBox("matched")

; OK: Strict equality comparison
if value == "hello"
  MsgBox("matched")

; NG: Case-insensitive inequality (prohibited)
if value != "hello"
  MsgBox("not matched")

; OK: Strict inequality comparison
if value !== "hello"
  MsgBox("not matched")
```

### Escape Sequences

AutoHotkey v2 uses the backtick character (`` ` ``) as its escape character inside expressions. Outside expressions (in literal strings), use ` `` ` (double backtick) for a literal backtick.

Common [Escape Sequences](https://www.autohotkey.com/docs/v2/misc/EscapeChar.htm):

| Sequence | Meaning                                   |
| -------- | ----------------------------------------- |
| ` `` `   | Literal backtick                          |
| `` `, `` | Literal comma                             |
| `` `; `` | Literal semicolon                         |
| `` `% `` | Literal percent                           |
| `` `# `` | Literal hash                              |
| `` `: `` | Literal colon                             |
| `` `" `` | Literal double-quote                      |
| `` `n `` | Newline (`Chr(10)`)                       |
| `` `r `` | Carriage return (`Chr(13)`)               |
| `` `t `` | Tab (`Chr(9)`)                            |
| `` `b `` | Backspace (`Chr(8)`)                      |
| `` `v `` | Vertical tab (`Chr(11)`)                  |
| `` `a `` | Alert/bell (`Chr(7)`)                     |
| `` `f `` | Form feed (`Chr(12)`)                     |
| `` `s `` | Literal space (useful in expressions)     |
| `` `" `` | Literal Double-quote (when Double-quoted) |
| `` `' `` | Literal single-quote (when Single-quoted) |

### `Chr()` Function

[Chr()](https://www.autohotkey.com/docs/v2/lib/Chr.htm) returns the character for a given Unicode code point. Use this when a character cannot be safely written as a literal in a string.

```autohotkey
tick      := Chr(96)  ; backtick
quote     := Chr(34)  ; double-quote
backslash := Chr(92)  ; backslash
```

**When to use `Chr()` instead of escape sequences:**

1. When the character cannot appear safely in a string literal (e.g., backtick inside a string that already contains backticks).
2. When building regex patterns that will be used with `~=` or `RegExMatch()`.
3. When passing special characters to external functions (COM, DllCall) where escape handling differs.

### Regular Expressions

[RegEx](https://www.autohotkey.com/docs/v2/misc/RegEx-QuickRef.htm)

- Use `~=` for regular expression checks.
  - Use `RegExMatch()` only when optional arguments are needed.

### String Formatting

- Use [Format](https://www.autohotkey.com/docs/v2/Format.htm) only when specifying format specifiers.
  - OK: `value " cm"`
  - OK: `Format("{:0.2f} cm", value)`
  - NG: `Format("{} cm", value)`

### Output to Console

- Use [FileAppend](https://www.autohotkey.com/docs/v2/lib/FileAppend.htm) to write to stdout or stderr.
- Write to stdout:

  ```autohotkey
  FileAppend("Hello stdout", "*")
  ```

- Write to stderr:

  ```autohotkey
  FileAppend("Hello stderr", "**")
  ```

- This is useful for debugging and error reporting in scripts run via `AutoHotkey.ps1`.

### System Integration

- Use [ComObjCreate](https://www.autohotkey.com/docs/v2/lib/ComObject.htm) for COM object integration.
- Use [DllCall](https://www.autohotkey.com/docs/v2/lib/DllCall.htm) when no built-in AutoHotkey functions or libraries can achieve the desired functionality.
  - Use the following mapping of WINAPI types to AutoHotkey v2 types:
    - [Windows Data Types](https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types)

| WINAPI      | typedef                                           | type      |
| ----------- | ------------------------------------------------- | --------- |
| `BOOL`      | `typedef int BOOL, *PBOOL, *LPBOOL;`              | `Int`     |
| `DWORD_PTR` | `typedef ULONG_PTR DWORD_PTR;`                    | `UInt`    |
| `DWORD`     | `typedef unsigned long DWORD, *PDWORD, *LPDWORD;` | `UInt`    |
| `HANDLE`    | `typedef PVOID HANDLE;`                           | `Ptr`     |
| `HGLOBAL`   | `typedef HANDLE HGLOBAL;`                         | `Ptr`     |
| `HRESULT`   | `typedef LONG HRESULT;`                           | `HRESULT` |
| `HWND`      | `typedef HANDLE HWND;`                            | `Ptr`     |
| `int`       |                                                   | `Int`     |
| `INT`       | `typedef int INT, *LPINT;`                        | `Int`     |
| `INT64`     | `typedef signed __int64 INT64;`                   | `Int64`   |
| `long`      |                                                   | `Int`     |
| `LONG`      | `typedef long LONG, *PLONG, *LPLONG;`             | `Int`     |
| `LPCWSTR`   | `typedef const wchar_t *LPCWSTR;`                 | `WStr`    |
| `LPVOID`    | `typedef void *LPVOID;`                           | `Ptr`     |
| `LPWSTR`    | `typedef wchar_t *LPWSTR, *PWSTR;`                | `WStr`    |
| `PCWSTR`    | `typedef const WCHAR *PCWSTR;`                    | `WStr`    |
| `PWSTR`     | `typedef wchar_t *LPWSTR, *PWSTR;`                | `WStr`    |
| `WCHAR`     | `typedef wchar_t WCHAR, *PWCHAR;`                 | `WStr`    |

## Running Scripts

- Use [AutoHotkey.ps1](./scripts/AutoHotkey.ps1) from PowerShell:

  ```powershell
  powershell.exe -NoLogo -NoProfile -File '.\.agents\skills\autohotkey\scripts\AutoHotkey.ps1' -LiteralPath '.\Script.ahk'
  ```

- Run multiple scripts with wildcards:

  ```powershell
  powershell.exe -NoLogo -NoProfile -File '.\.agents\skills\autohotkey\scripts\AutoHotkey.ps1' -Path '.\*.Tests.ahk'
  ```

- Pipe files to the script:

  ```powershell
  Get-ChildItem -Path '.\Scripts\*.ahk' | '.\.agents\skills\autohotkey\scripts\AutoHotkey.ps1'
  ```

## References

- [AutoHotkey Quick Reference](https://www.autohotkey.com/docs/v2/)
