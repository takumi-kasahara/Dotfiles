# Recommended `pwsh.exe` Invocation Options

When launching PowerShell 7 non-interactively — for example, from a batch file or from another shell to run a script — use:

```bat
pwsh -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File "<script>" <args>
```

or, for an inline command:

```bat
pwsh -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command "<command>"
```

Each option removes a source of nondeterminism or interactivity. The defaults are not always what a scripted invocation wants, and user configuration (profiles, execution policy) can change them.

## `-NoLogo`

**What it does:** Hides the banner at startup of interactive sessions.

**Why:** The banner is noise for a scripted invocation. Suppressing it keeps stdout clean for callers that parse output, capture logs, or compare results, and avoids confusing downstream tooling that expects only the command's output.

## `-NoProfile` — Do not load the PowerShell profiles

**What it does:** Doesn't load the PowerShell profiles.

**Why:** Profiles (`$PROFILE`) can define aliases, functions, variables, and module imports, and can change `PSModulePath` or other session state. Loading them makes the invocation depend on per-user configuration, which is exactly what a scripted call should not depend on. `-NoProfile` gives a deterministic, minimal session and also starts faster.

## `-NonInteractive`

**What it does:** Creates a session that shouldn't require user input. This is useful for scripts that run in scheduled tasks or CI/CD pipelines. Any attempts to use interactive features, like `Read-Host` or confirmation prompts, result in statement-terminating errors rather than hanging.

**Why:** A non-interactive caller has no one to answer a prompt. Without `-NonInteractive`, a script that calls `Read-Host` or a cmdlet that prompts for confirmation would block forever waiting on stdin. With `-NonInteractive`, those attempts fail fast with a statement-terminating error, which surfaces as a non-zero exit code instead of a hung process.

## `-ExecutionPolicy RemoteSigned`

**What it does:** Sets the default execution policy for the current session and saves it in the `$env:PSExecutionPolicyPreference` environment variable. This parameter does not change the persistently configured execution policies.

**Why:** The machine or user execution policy may be `Restricted` or `AllSigned`, which would block the script from running at all. `-ExecutionPolicy RemoteSigned` overrides the policy for this session only: local scripts run without a signature, and scripts downloaded from the internet must be signed by a trusted publisher. Because the override is session-scoped (via `$Env:PSExecutionPolicyPreference`) and does not touch the persistently configured policies, it does not weaken the machine's persistent policy.

## Notes

- `-File` must be the last parameter; everything after it is interpreted as the script path and its arguments.
- `-Command` must also be the last parameter when its value is a string; everything after it is interpreted as part of the command to execute.
- With `-File`, a script-terminating error sets the exit code to `1`; interrupting with Ctrl+C sets it to `0`.
- With `-Command`, the exit code is `0` when `$?` is `$true` and `1` when `$?` is `$false`. To preserve a specific exit code from an external program, add `exit $LASTEXITCODE` to the command string.

## Summary

| Option             | Effect                                   | Default                    | Why it is set explicitly                                    |
| ------------------ | ---------------------------------------- | -------------------------- | ----------------------------------------------------------- |
| `-NoLogo`          | Hides the banner                         | banner shown               | Keeps stdout clean for parsing and logging                  |
| `-NoProfile`       | Doesn't load the PowerShell profiles     | profiles loaded            | Deterministic session, independent of per-user config       |
| `-NonInteractive`  | Interactive features fail fast           | prompts allowed (may hang) | Prevents hangs in scheduled tasks and CI/CD                 |
| `-ExecutionPolicy` | Session-scoped execution policy override | persistent policy          | Allows local scripts without changing the persistent policy |

## Reference

- [about_Pwsh](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.6)
- [about_Execution_Policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.6)
