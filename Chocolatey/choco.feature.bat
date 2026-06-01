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
choco feature disable --name=allowEmptyChecksumsSecure --limit-output
choco feature disable --name=ignoreInvalidOptionsSwitches --limit-output
choco feature enable --name=removePackageInformationOnUninstall --limit-output
choco feature enable --name=useEnhancedExitCodes --limit-output
choco feature enable --name=usePackageHashValidation --limit-output
choco feature enable --name=useRememberedArgumentsForUpgrades --limit-output
choco feature enable --name=virusCheck --limit-output

:end
exit /b %errorlevel%
