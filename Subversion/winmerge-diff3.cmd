@echo off
setlocal enableextensions disabledelayedexpansion

:begin
where WinMergeU >nul 2>&1
if errorlevel 1 (
  echo fatal: WinMerge not found.
  exit /B 1
)

:process
:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.diff3
shift
shift
set "BASE=%~8"
set "MINE=%~7"
set "THEIRS=%~9"
WinMergeU /e /u /x /wl /wm /fr /ar /dl "Base: %~nx8" /dm "Theirs: %~nx9" /dr "Mine: %~nx7" "%BASE%" "%THEIRS%" "%MINE%"
