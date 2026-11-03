@echo off
setlocal

:begin

:process
powershell -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0%~n0.ps1" %*

:end
exit /b %errorlevel%
