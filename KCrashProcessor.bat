@echo off

:Coreloaading
set "CRASHLOADED=1"

if "%crash%" == "1" (
    goto Crash
) else (
    set "crash=0"
)
call KERNEL32.bat
goto Coreloaading

:Crash
if "%bsodcode%" == "" goto bcodeud
for /f "tokens=2 delims==" %%I in ('wmic os get TotalVisibleMemorySize /value') do set "TotalMemory=%%I"
for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
set report=KERNEL_ERROR_DUMP_LOG_%random%.log
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
echo [31mFOS Kernel System Has Encountered An Error[0m
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
set "crash=0"
set "bsodcode="
goto Coreloaading



:bcodeud
set bsodcode=KERR_008X_UNDEFINED
goto crash