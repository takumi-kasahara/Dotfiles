@echo off

set "WinMerge=%ProgramFiles%\WinMerge\WinMergeU.exe"
if not exist "%WinMerge%" (
  echo fatal: WinMerge not found.
  exit /b 1
)
"%WinMerge%" /e /u /x /r /wl /fr /dl %3 /dr %5 %6 %7
