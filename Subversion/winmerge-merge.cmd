@echo off
setlocal enableextensions disabledelayedexpansion

:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.merge
:: %%1 = base        (common ancestor)
:: %%2 = theirs      (incoming changes)
:: %%3 = mine        (working copy)
:: %%4 = target      (file to write the resolved result)

where WinMergeU >nul 2>&1
if errorlevel 1 (
  echo fatal: WinMerge not found.
  exit /B 1
)
WinMergeU /e /u /x /wl /wm /fr /ar /dl "Base: %~nx1" /dm "Theirs: %~nx2" /dr "Mine: %~nx3" /o "%~4" "%~1" "%~2" "%~3"
