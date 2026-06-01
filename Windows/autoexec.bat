@prompt %USERNAME%@%COMPUTERNAME%$S%OS%$S$P$_$G$S

@if exist "%LOCALAPPDATA%\Programs" (
  @set "PATH=%LOCALAPPDATA%\Programs;%PATH%"
)

:: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/doskey
@doskey #=rem $*
@doskey ..=cd ..
@doskey ...=cd ..\..
@doskey alias=if "$1"=="" (doskey /MACROS:ALL) else (doskey /MACROS $b findstr /B $*=)
@doskey basename=for %%I in ("$1") do @echo %%~nxI
@doskey cat=type $*
@doskey cd=cd /d $*
@doskey cp=copy $*
@doskey del=del /p $*
@doskey dirname=for %%I in ("$1") do @echo %%~dpI
@doskey erase=erase /p $*
@doskey h=doskey /history
@doskey history=doskey /history
@doskey ip=ipconfig $*
@doskey kill=taskkill $*
@doskey l=dir /b $*
@doskey la=dir /a $*
@doskey ll=dir /a $*
@doskey ls=dir /b $*
@doskey mv=move $*
@doskey ps=tasklist $*
@doskey pwd=cd
@doskey replace=replace /p $*
@doskey rm=del /p $*
@doskey source=cmd /c $*
@doskey ss=netstat $*
@doskey touch=type nul $G $*
@doskey tree=tree /f $B more
@doskey which=where $*

@doskey g=git $*
@doskey wslpath=wsl wslpath $*
@doskey ex=explorer $*
@where /q sudo >nul 2>&1
@if errorlevel 1 (
  @doskey logout=runas /user:"%USERNAME%" shutdown /l /soft
  @doskey reboot=runas /user:"%USERNAME%" shutdown /g /soft
) else (
  @doskey logout=sudo --disable-input shutdown /l /soft
  @doskey reboot=sudo --disable-input shutdown /g /soft
)
@doskey restart=taskkill.exe /IM explorer.exe /F $Gnul $T$T start explorer.exe

@doskey cinst=sudo --disable-input choco install $1 --accept-license --pre $2 $3 $4 $5 $6 $7 $8 $9
@doskey cremove=sudo --disable-input choco uninstall $1 --all-versions $2 $3 $4 $5 $6 $7 $8 $9
@doskey cpurge=sudo --disable-input choco uninstall $1 --all-versions --remove-dependencies $2 $3 $4 $5 $6 $7 $8 $9
@doskey cup=sudo --disable-input choco upgrade all --accept-license --pre $2 $3 $4 $5 $6 $7 $8 $9

@doskey winst=sudo --disable-input winget install --id $1 --exact --accept-package-agreements --accept-source-agreements $2 $3 $4 $5 $6 $7 $8 $9
@doskey wremove=sudo --disable-input winget uninstall --id $1 --exact --all-versions $2 $3 $4 $5 $6 $7 $8 $9
@doskey wpurge=sudo --disable-input winget uninstall --id $1 --exact --all-versions --purge $2 $3 $4 $5 $6 $7 $8 $9
@doskey wup=sudo --disable-input winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements $2 $3 $4 $5 $6 $7 $8 $9
