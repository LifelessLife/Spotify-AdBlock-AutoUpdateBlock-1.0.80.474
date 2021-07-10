@ECHO off
chcp 65001
ECHO.
ECHO.
TITLE Instalator Spotify v1.0.80.474 (bez reklam i aktualizacji)
COLOR A0

:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\caCLS.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    ECHO Uzyskuję uprawnienia administratora...
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
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Power /v CsEnabled /t REG_DWORD /d 1 /f
xcopy /s /y "Spotify_v1.0.80.474.exe" "%temp%\"
xcopy /s /y "spotify.exe" "%temp%\"
xcopy /s /y "1.exe" "%temp%\"
xcopy /s /y "install.exe" "%temp%\"
xcopy /s /y "spotify_version_keeper.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
ren "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\spotify_version_keeper.exe" "SpotifyUpdateBlocker.exe"

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
ECHO.
ECHO #*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
ECHO.
ECHO  Instalator Spotify 1.0.80.474 bez reklam i aktualizacji.
ECHO        ∟ta wersja obsługuję logowanie tylko przez e-mail.
ECHO.
ECHO #*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
ECHO.
ECHO.
ECHO  Upewnij się, że masz w folderze z instalatorem pliki:
ECHO.
ECHO  - "Spotify_v1.0.80.474.exe"
ECHO  - "spotify_version_keeper.exe"
ECHO.
ECHO  DOWNLOAD:
ECHO  - https://download.filepuma.com/files/video-and-audio/spotify/Spotify_v1.0.80.474.exe
ECHO. - https://github.com/SrMordred/spotify_version_keeper
ECHO.
ECHO.
ECHO _________________________________________________
SET /P Choice="Rozpocząć instalację ? (T/N)"
IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%
ECHO.
IF /I '%Choice%'=='T' GOTO ACCEPTED
IF /I '%Choice%'=='Y' GOTO ACCEPTED
IF /I '%Choice%'=='N' GOTO REJECTED
ECHO.
GOTO Loop

:REJECTED
ECHO Twoje HOSTS zostały nienaruszone>>%systemroot%\Temp\hostFileUpdate.log
ECHO Zamykanie...
TIMEOUT 2 > nul
EXIT
GOTO END

:ACCEPTED
TASKKILL /im SpotifyWebHelper.exe /t
DEL %appdata%\Spotify\Update /F /Q
DEL %localappdata%\Spotify\Update /F /Q
mkdir %appdata%\Spotify\Update
mkdir %localappdata%\Spotify\Update
icaCLS %appdata%\Spotify\Update /deny "%username%":D
icaCLS %appdata%\Spotify\Update /deny "%username%":R
icaCLS %localappdata%\Spotify\Update /deny "%username%":D
icaCLS %localappdata%\Spotify\Update /deny "%username%":R

SETlocal enableDELayedexpansion
SET LIST=(Spotify: pubads.g.doubleclick.NET securepubads.g.doubleclick.NET www.googletagservices.com www.gads.pubmatic.com ads.pubmatic.com spclient.wg.spotify.com ‾‾‾‾‾‾‾)
SET Spotify:
SET pubads.g.doubleclick.NET=127.0.0.1
SET securepubads.g.doubleclick.NET=127.0.0.1
SET www.googletagservices.com=127.0.0.1
SET www.gads.pubmatic.com=127.0.0.1
SET ads.pubmatic.com=127.0.0.1
SET spclient.wg.spotify.com=127.0.0.1
SET ‾‾‾‾‾‾‾
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
ECHO  1. Reklamy i aktualizacje zablokowane. (w Spotify)
ECHO.
ECHO  2. Instaluję Spotify v1.0.80.474.
ECHO.
ECHO  3. Usuwam pliki tymczasowe.
ECHO      Miłego słuchania bez reklam! - okno zamknie się automatycznie.
EXPLORER.EXE "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\SpotifyUpdateBlocker.exe"
EXPLORER.EXE "%temp%\Spotify_v1.0.80.474.exe"
TIMEOUT 20
DEL "%temp%\Spotify_v1.0.80.474.exe"
GOTO END

:END
ECHO.
TIMEOUT 2 > nul
EXIT
