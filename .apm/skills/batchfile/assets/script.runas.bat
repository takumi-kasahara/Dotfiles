@echo off
cd /d "%~dp0"
setlocal

:begin
net session >nul 2>&1
if errorlevel 1 (
  where /q sudo >nul 2>&1
  if errorlevel 1 goto :no_sudo
  goto :elevate
)

:no_sudo
echo ERROR: Access is denied.
goto :end

:elevate
sudo --inline "%~0" %*
exit /b %errorlevel%

:process
:: Add script logic here.

:end
pause
exit /b %errorlevel%
