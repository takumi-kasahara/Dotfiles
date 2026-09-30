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
:: https://www.nict.go.jp/sts/ntp.html
:: https://learn.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings?tabs=config
net stop w32time
w32tm /config /manualpeerlist:ntp.nict.jp,0x8
w32tm /config /syncfromflags:ALL
net start w32time
w32tm /resync
w32tm /query /peers /verbose

:end
exit /b %errorlevel%
