@echo off
setlocal enableextensions disabledelayedexpansion

:begin
where WinMergeU >nul 2>&1
if errorlevel 1 (
  echo fatal: WinMerge not found.
  exit /B 1
)

:process
:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.diff
set "BASE=%~6"
set "MINE=%~7"
WinMergeU /e /u /x /wl /fr /dl "Base: %~nx6" /dr "Mine: %~nx7" "%BASE%" "%MINE%"
