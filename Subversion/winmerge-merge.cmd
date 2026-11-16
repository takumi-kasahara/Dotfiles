@echo off
setlocal enableextensions disabledelayedexpansion

:begin
where WinMergeU >nul 2>&1
if errorlevel 1 (
  echo fatal: WinMerge not found.
  exit /B 1
)

:process
:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.merge
set "BASE=%~1"
set "THEIRS=%~2"
set "MINE=%~3"
set "MERGED=%~4"
WinMergeU /e /u /x /wl /wm /fr /ar /dl "Base: %~nx1" /dm "Theirs: %~nx2" /dr "Mine: %~nx3" /o "%MERGED%" "%BASE%" "%THEIRS%" "%MINE%"
