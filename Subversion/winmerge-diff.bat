@echo off

:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.diff
:: Subversion calls external diff programs with GNU diff-compatible parameters.
:: Only the sixth and seventh arguments (%%6 and %%7) are guaranteed to be the
:: left and right file paths, respectively. The other arguments are diff flags.

setlocal
set "WinMerge=%ProgramFiles%\WinMerge\WinMergeU.exe"
if not exist "%WinMerge%" (
  echo fatal: WinMerge not found.
  exit /b 1
)
"%WinMerge%" /e /u /x /r /wl /fr "%~6" "%~7"
