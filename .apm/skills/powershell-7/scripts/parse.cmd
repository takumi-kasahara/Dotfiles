@echo off
setlocal

:begin
if "%~1"=="" goto :help

:process
pwsh -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0%~n0.ps1" %*
goto :end

:help
pwsh -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "Get-Help -Name '%~dp0%~n0.ps1' -Full"
goto :end

:end
exit /b %errorlevel%
