@echo off
setlocal EnableDelayedExpansion

:Coreloaading
set "CRASHLOADED=1"
set /p VERSION2=<version.txt
set "OS2=FujiOS"

if "%crash%" == "1" (
    goto Crash
) else (
    set "crash=0"
)
set "crash=1"
call POST.bat
if "%POST%"=="PASS" call BOOTLOADER.bat
goto Coreloaading

:Crash
if "%POST%"=="FAIL" set "bsodcode= POST TEST FAIL"
if "%bsodcode%" == "" goto bcodeud
for /f "tokens=2 delims==" %%I in ('wmic os get TotalVisibleMemorySize /value') do set "TotalMemory=%%I"
for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
set report=BOOTLOADER_ERROR_DUMP_LOG_%random%.log
set crshdmpfile=%report%
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [31mFOS Bootloader System Has Encountered An Error[0m
echo.
echo Crash Code: %bsodcode%
echo Additional Info: %InfoAdd%
goto LogCrash
:LogCrash
echo ============================ > %crshdmpfile%
echo %DATE%  %time% >> %crshdmpfile%
echo Crash Code: %bsodcode% >> %crshdmpfile%
echo Last Page: %lastpage% >> %crshdmpfile%
echo Additional Info: %InfoAdd% >> %crshdmpfile%
echo System Info >> %crshdmpfile%
echo Total Memory: %TotalMemory% KB >> %crshdmpfile%
echo CPU Speed: %CPUSpeed% MHz >> %crshdmpfile%
echo Serial Number: %SerialNumber% >> %crshdmpfile%
echo ============================ >> %crshdmpfile%
echo. 
echo Report Saved At %crshdmpfile%
echo.
pause
:RESCUE
cls
echo %OS2% Bootloader v%VERSION2%
echo     RESCUE MODE
echo.
echo %bsodcode%
echo.
set "crash=0"
set "bsodcode="
:COMMAND
set /p command="%CD%~> "
if %command%==START goto Coreloaading
if %command%==start goto Coreloaading
if %command%==Start goto Coreloaading
if %command%==sTart goto Coreloaading
if %command%==stArt goto Coreloaading
if %command%==staRt goto Coreloaading
if %command%==starT goto Coreloaading
%command%
goto COMMAND


:bcodeud
set bsodcode=KERR_008X_UNDEFINED
goto crash