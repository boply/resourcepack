@echo off
setlocal

:: CONFIG
set "PACK_DIR=resourcepack"
set "ZIP_NAME=resourcepack.zip"
set "SERVER_PROPERTIES=..\server.properties"
set "ZIP_TOOL=C:\Program Files\7-Zip\7z.exe"
set "GIT=C:\Users\braed\AppData\Local\GitHubDesktop\app-3.4.20\resources\app\git\cmd\git.exe"
set "COMMIT_MSG=Update resource pack - %DATE% %TIME%"

:: Delete old zip
if exist "%ZIP_NAME%" del "%ZIP_NAME%"

:: Create new zip using 7-Zip (MUCH faster than PowerShell)
"%ZIP_TOOL%" a -tzip "%ZIP_NAME%" ".\%PACK_DIR%\*" >nul

:: Generate SHA1
for /f "tokens=1 delims= " %%i in ('certutil -hashfile "%ZIP_NAME%" SHA1 ^| find /v "SHA1" ^| find /v ":"') do set "SHA1_HASH=%%i"
echo SHA1: %SHA1_HASH%

:: Update server.properties in-place
(for /f "usebackq tokens=*" %%l in ("%SERVER_PROPERTIES%") do (
    echo %%l | findstr /b /c:"resource-pack-sha1=" >nul
    if errorlevel 1 (
        echo %%l
    ) else (
        echo resource-pack-sha1=%SHA1_HASH%
    )
)) > "%SERVER_PROPERTIES%.tmp"
move /Y "%SERVER_PROPERTIES%.tmp" "%SERVER_PROPERTIES%"

:: Commit all changes in the resourcepack repo
echo Committing all changes to .resourcepack repo...
%GIT% add -A
%GIT% commit -m "%COMMIT_MSG%"
%GIT% push origin main
echo %COMMIT_MSG%

echo Done.
pause