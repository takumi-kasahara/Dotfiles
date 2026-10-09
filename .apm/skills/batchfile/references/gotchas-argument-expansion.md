# `%*` Expansion Gotchas in Batch Files

## The Problem

When using `%*` (all arguments) inside an `if (...) else (...)` block, parentheses in arguments can break the block structure.

### Example of the Problem

```bat
if "%~1"=="" (
  echo No arguments.
) else (
  echo Processing: %*
)
```

If the user passes `().txt` as an argument, `%*` expands to `().txt`, making the code:

```bat
if "%~1"=="" (
  echo No arguments.
) else (
  echo Processing: ().txt
)
```

The `)` in `().txt` closes the `else (` block prematurely, causing:

```plaintext
.txt was unexpected at this time.
```

## The Solution: Use Goto Labels Instead of Blocks

Replace block-based branching with label-based branching:

```bat
if "%~1"=="" goto :no_args
echo Processing: %*
goto :end

:no_args
echo No arguments.

:end
```

This works because labels are not affected by parentheses in expanded variables.

## Best Practices

1. Avoid `if (...) else (...)` blocks when using `%*` or `%1`...`%9`
   — the parentheses in arguments can break the block structure.
2. Use `goto` labels for branching
   — labels are parsed at read time, not expansion time, so they're immune to argument content.
3. If you must use blocks, quote carefully
   — but even `"%*"` doesn't help because the `)` is still a `)` to the parser.
4. This applies to `for` loops too
   — `for /f "tokens=*" %%I in ("%*") do (...)` has the same issue.

## When This Matters

- SendTo menu handlers (users can right-click any file, including ones with `()` in the name)
- Drag-and-drop handlers
- Any script that processes arbitrary file paths as arguments
- Wrapper scripts that forward arguments to other commands

## Related

- [SS64: IF](https://ss64.com/nt/if.html)
- [SS64: GOTO](https://ss64.com/nt/goto.html)
