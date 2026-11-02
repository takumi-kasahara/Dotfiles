@echo off
setlocal

:begin
net session >nul 2>&1
if errorlevel 1 goto :elevate
goto :process

:elevate
where /q sudo >nul 2>&1
if errorlevel 1 goto :powershell

sudo --inline "%~0"
goto :end

:powershell
set "PSModulePath="
powershell -NoLogo -NoProfile -Command "Start-Process '%~0' -Verb RunAs"
goto :end

:process
choco feature disable --name=allowEmptyChecksumsSecure --limit-output
choco feature disable --name=ignoreInvalidOptionsSwitches --limit-output
choco feature enable --name=removePackageInformationOnUninstall --limit-output
choco feature enable --name=useEnhancedExitCodes --limit-output
choco feature enable --name=usePackageHashValidation --limit-output
choco feature enable --name=useRememberedArgumentsForUpgrades --limit-output
choco feature enable --name=virusCheck --limit-output

:end
exit /b %errorlevel%
