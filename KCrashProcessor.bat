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
pause
:RESCUE
cls
echo ==============================
echo    %OS2% Bootloader v%VERSION2%
echo         RESCUE MODE
echo ==============================
echo.
echo Error Code: %bsodcode%
echo.
set "crash=0"
set "bsodcode="
echo START to start Boot
echo.

:COMMAND
echo.
set /p "command=%OS2%~> "
if /i "%command%"=="START" goto Coreloaading
if "%command%" == "Get.Data" (
    for /f "tokens=2 delims==" %%I in ('wmic os get TotalVisibleMemorySize /value') do set "TotalMemory=%%I"
    for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
    for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
    set "DMP3=1"
    set "PERMS=KernelAdmin"
    echo %OS2% BOOTAGENT %VERSION2% INITIALIZED
    echo %TotalMemory% KB
    echo %CPUSpeed% MHz
    echo %SerialNumber%
    echo.
)

if "%command%" == "Dump.Data" (
    goto Memdump
)

echo.
call %command%
if errorlevel 1 echo [ERROR] Invalid command or execution failed.
goto COMMAND

:Memdump
set "DMP5=1"
echo.
echo Current Permissions [%PERMS%]
pause
if %PERMS% neq KernelAdmin goto COMMAND 
echo Dumping Current User Service . . . 
set "Dumpfile=$%Random%KernelMiniDump.dmp"
timeout /t 5 /nobreak >nul
echo. > %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%Enterprise%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%UAK%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%FPS_BROWSER_USER_PROFILE_STRING%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%hibernate%%RANDOM%%RANDOM%%privatekey2%%RANDOM%%RANDOM%%VERSION2%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%valid_username%%UPDATE%%SESSIONSTARTTIME%%valid_password%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%MaxxxErr%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%regnumber%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %OS2%%RANDOM%%MaxxErr%AdMni%RANDOM%%RANDOM%%ErrorL%%RANDOM%%RANDOM%%HOMEPATH%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%MaxErr%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%PRIVATEKEY%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%OS%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%FPS_BROWSER_APP_PROFILE_STRING%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%attempts%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%documentsPath%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%ComSpec%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
goto COMMAND


:bcodeud
set bsodcode=KERR_008X_UNDEFINED
goto crash