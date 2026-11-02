@echo off
setlocal

:begin
net session >nul 2>&1
if errorlevel 1 goto :elevate
goto :process

:elevate
where /q sudo >nul 2>&1
if errorlevel 1 goto :powershell

sudo --inline "%~0" %*
goto :end

:powershell
set "PSModulePath="
if "%*"=="" (
  powershell -NoLogo -NoProfile -Command "Start-Process '%~0' -Verb RunAs"
) else (
  powershell -NoLogo -NoProfile -Command "Start-Process '%~0' -ArgumentList '%*' -Verb RunAs"
)
goto :end

:process

:end
exit /b %errorlevel%
