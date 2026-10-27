@echo off

:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.diff3
:: Subversion invokes three-way differencing programs with GNU diff3-compatible
:: parameters. The useful file paths are the 9th, 10th, and 11th arguments,
:: representing mine, older (base), and yours, respectively. Because batch files
:: can only access %%1-%%9 at a time, shift the window twice to reach them.

setlocal
set "WinMerge=%ProgramFiles%\WinMerge\WinMergeU.exe"
if not exist "%WinMerge%" (
  echo fatal: WinMerge not found.
  exit /b 1
)

shift
shift
set "MINE=%~7"
set "OLDER=%~8"
set "YOURS=%~9"

"%WinMerge%" /e /u /x /3 /wl /wr /dl "Mine: %~nxMINE%" /dm "Base: %~nxOLDER%" /dr "Theirs: %~nxYOURS%" "%MINE%" "%OLDER%" "%YOURS%"
