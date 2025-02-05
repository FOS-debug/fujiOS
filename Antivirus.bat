::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
:antivirus
setlocal EnableDelayedExpansion

:: Define the path to the Documents directory
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"
if not exist %mainfilepath% mkdir %mainfilepath%
%mainfilepath%
set "DOCS_PATH=%mainfilepath%"
set "LOGFILE=%DOCS_PATH%\antivirus_log.txt"

:: Define known viruses and their threat levels
set "VIRUS1=BURGER.dll"
set "VIRUS1_LEVEL=4"
set "VIRUS2=Bootifier.dll"
set "VIRUS2_LEVEL=2"
set "VIRUS3=bruteforce.dll"
set "VIRUS3_LEVEL=3"
set "VIRUS4=WindowsBootLog.dll"
set "VIRUS4_LEVEL=5"


title -AntiVirus- FujiOS
cls
echo =============================
echo   AntiVirus
echo =============================
echo     Premium Plan = 10$/m
echo  * Deep Scan
echo  * More Features
echo =============================
echo.
echo [1] Start Scanning
echo [2] Menu
echo =============================
choice /c 12 /n >nul
if %ERRORLEVEL%==1 goto scanning
if %ERRORLEVEL%==2 exit /b

:scanning
title -AntiVirus- FujiOS
cls
echo =============================
echo   AntiVirus
echo =============================
set "DETECTED=0"

:: Check for VIRUS1
if exist "%DOCS_PATH%\!VIRUS1!" (
    echo Detected virus: !VIRUS1! (Level !VIRUS1_LEVEL!)
    echo Detected virus: !VIRUS1! (Level !VIRUS1_LEVEL!) >> "!LOGFILE!"
    del /f /q "%DOCS_PATH%\!VIRUS1!" >nul
    echo Removed !VIRUS1! from %DOCS_PATH% >> "!LOGFILE!"
    set "DETECTED=1"
)  >nul

:: Check for VIRUS2
if exist "%DOCS_PATH%\!VIRUS2!" (
    echo Detected virus: !VIRUS2! (Level !VIRUS2_LEVEL!)
    echo Detected virus: !VIRUS2! (Level !VIRUS2_LEVEL!) >> "!LOGFILE!"
    del /f /q "%DOCS_PATH%\!VIRUS2!" >nul
    echo Removed !VIRUS2! from %DOCS_PATH% >> "!LOGFILE!"
    set "DETECTED=1"
)  >nul

:: Check for VIRUS3
if exist "%DOCS_PATH%\!VIRUS3!" (
    echo Detected virus: !VIRUS3! (Level !VIRUS3_LEVEL!)
    echo Detected virus: !VIRUS3! (Level !VIRUS3_LEVEL!) >> "!LOGFILE!"
    del /f /q "%DOCS_PATH%\!VIRUS3!" >nul
    echo Removed !VIRUS3! from %DOCS_PATH% >> "!LOGFILE!"
    set "DETECTED=1"
)  >nul

:: Check for VIRUS4
if exist "%DOCS_PATH%\!VIRUS4!" (
    echo Detected virus: !VIRUS4! (Level !VIRUS4_LEVEL!)
    echo Detected virus: !VIRUS4! (Level !VIRUS4_LEVEL!) >> "!LOGFILE!"
    del /f /q "%DOCS_PATH%\!VIRUS4!" >nul
    echo Removed !VIRUS4! from %DOCS_PATH% >> "!LOGFILE!"
    set "DETECTED=1"
)  >nul

if "!DETECTED!"=="0" (
    echo No viruses detected.
    echo No viruses detected at !date! !time! >> "!LOGFILE!"
)   >nul

echo Scan complete. Log file updated at "!LOGFILE!"
pause
endlocal
goto antivirus
