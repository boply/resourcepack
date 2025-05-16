@echo off
set "FILENAME=resourcepack.zip"

if not exist "%FILENAME%" (
    echo File "%FILENAME%" not found!
    pause
    exit /b
)

echo Calculating SHA-1 for %FILENAME%...
certutil -hashfile "%FILENAME%" SHA1
pause