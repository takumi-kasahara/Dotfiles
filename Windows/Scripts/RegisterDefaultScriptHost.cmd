@echo off
setlocal enableextensions disabledelayedexpansion

:begin
net session >nul 2>&1
if errorlevel 1 goto :elevate
goto :process

:elevate
where /Q sudo >nul 2>&1
if errorlevel 1 goto :powershell

sudo --disable-input "%~0"
goto :end

:powershell
set "PSModulePath="
powershell -NoLogo -NoProfile -NonInteractive -Command 'Start-Process "%~0" -Verb RunAs'
goto :end

:process
cscript /Nologo /H:WScript

:end
exit /B %errorlevel%
