@echo off
cd /d "%~dp0"
setlocal

:begin
net session >nul 2>&1
if errorlevel 1 (
  where /q sudo >nul 2>&1
  if errorlevel 1 (
    echo ERROR: Access is denied.
    goto :end
  ) else (
    sudo --inline "%~0" %*
    exit /b %errorlevel%
  )
)

:process
pwsh -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -File "Install.Config.ps1" -SymLink -Force
pwsh -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -File "Install.Registry.ps1"

:end
exit /b %errorlevel%
