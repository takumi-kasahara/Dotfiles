@echo off

:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.merge
:: %%1 = base        (common ancestor)
:: %%2 = theirs      (incoming changes)
:: %%3 = mine        (working copy)
:: %%4 = target      (file to write the resolved result)

setlocal
set "WinMerge=%ProgramFiles%\WinMerge\WinMergeU.exe"
if not exist "%WinMerge%" (
  echo fatal: WinMerge not found.
  exit /b 1
)
"%WinMerge%" /e /u /3 /wl /wr /dl "Mine: %~nx3" /dm "Base: %~nx1" /dr "Theirs: %~nx2" /o "%~4" "%~3" "%~1" "%~2"
