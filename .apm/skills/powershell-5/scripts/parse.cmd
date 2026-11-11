@echo off
setlocal enableextensions disabledelayedexpansion

:begin
set "PSModulePath="
if "%~1"=="" goto :help

:process
powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -File "%~dp0%~n0.ps1" %*
goto :end

:help
powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command "Get-Help -Name '%~dp0%~n0.ps1' -Full"
goto :end

:end
exit /B %errorlevel%
