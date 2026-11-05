@echo off
setlocal

:begin
net session >nul 2>&1
if errorlevel 1 goto :elevate
goto :process

:elevate
where /q sudo >nul 2>&1
if errorlevel 1 goto :powershell

sudo "%~0"
goto :end

:powershell
set "PSModulePath="
powershell -NoLogo -NoProfile -Command 'Start-Process "%~0" -Verb RunAs'
goto :end

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
