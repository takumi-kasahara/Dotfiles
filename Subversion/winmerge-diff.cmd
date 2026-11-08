@echo off
setlocal

:: https://svnbook.red-bean.com/en/1.7/svn.advanced.externaldifftools.html#svn.advanced.externaldifftools.diff
:: Subversion calls external diff programs with GNU diff-compatible parameters.
:: Only the sixth and seventh arguments (%%6 and %%7) are guaranteed to be the
:: left and right file paths, respectively. The other arguments are diff flags.

where WinMergeU >nul 2>&1
if errorlevel 1 (
  echo fatal: WinMerge not found.
  exit /b 1
)
WinMergeU /e /u /x /wl /fr /dl "Base: %~nx6" /dr "Mine: %~nx7" "%~6" "%~7"
