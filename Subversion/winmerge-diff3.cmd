@echo off
setlocal enableextensions disabledelayedexpansion

:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.diff3
:: Subversion invokes three-way differencing programs with GNU diff3-compatible
:: parameters. The useful file paths are the 9th, 10th, and 11th arguments,
:: representing mine, older (base), and yours, respectively. Because batch files
:: can only access %%1-%%9 at a time, shift the window twice to reach them.
shift
shift
set "MINE=%~7"
set "OLDER=%~8"
set "YOURS=%~9"

where WinMergeU >nul 2>&1
if errorlevel 1 (
  echo fatal: WinMerge not found.
  exit /B 1
)
WinMergeU /e /u /x /wl /wm /fr /ar /dl "Base: %~nx8%" /dm "Theirs: %~nx9%" /dr "Mine: %~nx7%" "%OLDER%" "%YOURS%" "%MINE%"
