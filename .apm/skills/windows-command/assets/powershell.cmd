@echo off
setlocal enableextensions disabledelayedexpansion

:begin
set "PSModulePath="

:process
powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File "%~dp0%~n0.ps1" %*

:end
exit /B %errorlevel%
