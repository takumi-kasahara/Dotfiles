@prompt %USERNAME%@%COMPUTERNAME%$S%OS%$S$P$_$G$S

:: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/doskey
@doskey #=rem $*
@doskey ..=cd ..
@doskey ...=cd ..\..
@doskey alias=if "$1"=="" (doskey /MACROS:ALL) else (doskey /MACROS $b findstr /B $*=)
@doskey basename=for %%I in ("$1") do @echo %%~nxI
@doskey cat=type $*
@doskey cd=cd /D $*
@doskey cp=copy $*
@doskey del=del /P $*
@doskey dirname=for %%I in ("$1") do @echo %%~dpI
@doskey erase=erase /P $*
@doskey h=doskey /history
@doskey history=doskey /history
@doskey ip=ipconfig $*
@doskey kill=taskkill $*
@doskey l=dir /B $*
@doskey la=dir /A $*
@doskey ll=dir /A $*
@doskey ls=dir /B $*
@doskey mv=move $*
@doskey ps=tasklist $*
@doskey replace=replace /P $*
@doskey rm=del /P $*
@doskey source=cmd /D /E:ON /V:OFF /S /C $*
@doskey ss=netstat $*
@doskey touch=type nul $G $*
@doskey tree=tree /F $B more
@doskey which=where $*

@doskey g=git $*
@doskey wslpath=wsl wslpath $*
@doskey ex=explorer $*
@where /Q sudo >nul 2>&1
@if errorlevel 1 (
  @doskey logout=runas /user:"%USERNAME%" shutdown /l /soft
  @doskey reboot=runas /user:"%USERNAME%" shutdown /g /soft
) else (
  @doskey logout=sudo shutdown /l /soft
  @doskey reboot=sudo shutdown /g /soft
)
@doskey restart=taskkill.exe /IM explorer.exe /F $Gnul $T$T start explorer.exe

@doskey cinst=sudo choco install $1 --accept-license --pre $2 $3 $4 $5 $6 $7 $8 $9
@doskey cremove=sudo choco uninstall $1 --all-versions $2 $3 $4 $5 $6 $7 $8 $9
@doskey cpurge=sudo choco uninstall $1 --all-versions --remove-dependencies $2 $3 $4 $5 $6 $7 $8 $9
@doskey cup=sudo choco upgrade all --accept-license --pre $2 $3 $4 $5 $6 $7 $8 $9

@doskey winst=sudo winget install --id $1 --exact --accept-package-agreements --accept-source-agreements $2 $3 $4 $5 $6 $7 $8 $9
@doskey wremove=sudo winget uninstall --id $1 --exact --all-versions $2 $3 $4 $5 $6 $7 $8 $9
@doskey wpurge=sudo winget uninstall --id $1 --exact --all-versions --purge $2 $3 $4 $5 $6 $7 $8 $9
@doskey wup=sudo winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements $2 $3 $4 $5 $6 $7 $8 $9
