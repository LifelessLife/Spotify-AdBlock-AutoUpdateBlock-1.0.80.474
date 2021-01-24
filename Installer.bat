@ECHO off
TITLE Spotify v1.0.80.474 (NoAds,NoAutoUpdates)
COLOR A0
ECHO.
xcopy /s /y "bin\Spotify_v1.0.80.474.exe" "%appdata%\"
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\caCLS.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    ECHO Requesting administrative privileges...
    GOTO UACPrompt
) ELSE ( GOTO gotAdmin )
:UACPrompt
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    SET params = %*:"="
    ECHO UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    DEL "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
:LOOP
CLS
TASKKILL /t /f /im Spotify.exe
CLS
TASKKILL /t /f /im SpotifyWebHelper.exe
CLS
RMDIR /s /q %appdata%\Spotify
RMDIR /s /q %localappdata%\Spotify
CLS
NET sess>nul 2>&1||(powershell start cmd -ArgumentList """/c %~0""" -verb Runas & exit)
CD %TMP%
ECHO Get-AppxPackage -AllUsers *Spotify* ^| Remove-AppxPackage > Spotify.ps1
Powershell -ExecutionPolicy ByPass -File Spotify.ps1
DEL Spotify.ps1
CLS
ECHO #*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
ECHO.
ECHO Installer of Spotify without ads and autoupdate.
ECHO.
ECHO Spotify v1.0.80.474
ECHO _________________________________________________
SET Choice=
SET /P Choice="Install ? (Y/N)"
IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%
ECHO.
IF /I '%Choice%'=='Y' GOTO ACCEPTED
IF /I '%Choice%'=='N' GOTO REJECTED
ECHO.
GOTO Loop

:REJECTED
ECHO Your HOSTS file was left unchanged>>%systemroot%\Temp\hostFileUpdate.log
ECHO Exiting...
TIMEOUT 2 > nul
EXIT
GOTO END

:ACCEPTED
TASKKILL /im SpotifyWebHelper.exe /t
DEL %appdata%\Spotify\Update /F /Q
mkdir %appdata%\Spotify\Update
icaCLS %appdata%\Spotify\Update /deny "%username%":D
icaCLS %appdata%\Spotify\Update /deny "%username%":R
SETlocal enableDELayedexpansion
SET LIST=(pubads.g.doubleclick.NET securepubads.g.doubleclick.NET www.googletagservices.com www.gads.pubmatic.com ads.pubmatic.com spclient.wg.spotify.com)
SET pubads.g.doubleclick.NET=0.0.0.0
SET securepubads.g.doubleclick.NET=0.0.0.0
SET www.googletagservices.com=0.0.0.0
SET www.gads.pubmatic.com=0.0.0.0
SET ads.pubmatic.com=0.0.0.0
SET spclient.wg.spotify.com=0.0.0.0
SET _list=%LIST:~1,-1%
for  %%G in (%_list%) do (
    SET  _name=%%G
    SET  _value=!%%G!
    SET NEWLINE=^& ECHO.
    ECHO Carrying out requested modifications to your HOSTS file
    type %WINDIR%\System32\drivers\etc\hosts | findstr /v !_name! > tmp.txt
    ECHO %NEWLINE%^!_value! !_name!>>tmp.txt
    copy /b/v/y tmp.txt %WINDIR%\System32\drivers\etc\hosts
    DEL tmp.txt
)
ipconfig /flushdns
CLS
TIMEOUT 1 > NUL
ECHO #*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
ECHO.
ECHO Ads and updates blocked successful. 
ECHO.
ECHO Starting installer of Spotify_v1.0.80.474.exe
ECHO Next... after install start cleaning temp directories.
EXPLORER.EXE "%appdata%\Spotify_v1.0.80.474.exe"
TIMEOUT 25
DEL "%appdata%\Spotify_v1.0.80.474.exe"
ECHO.
ECHO Cleaning up the temporary directory and exit.
ECHO.
GOTO END

:END
ECHO.
TIMEOUT 2 > nul
EXIT
Share