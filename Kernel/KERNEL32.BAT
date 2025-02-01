::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
set "OS=FujiOS"
set /p VERSION=<version.txt
set "ALTOS=FujiOS"
set "ALTVERSION=20"
if exist "License.txt" goto restart
echo LICENSE REVOKED
pause
exit /b
exit /b
exit /b
:restart
type License.txt
echo.
timeout /t 2 /NOBREAK >nul
echo.
echo.
echo.
CHOICE /C YN /M "Do You Accept These Agreements"
if "%errorlevel%"=="1" goto StartTsta


goto restart

:StartTsta
echo.
echo.
CHOICE /C YN /M "Are You Sure"
if "%errorlevel%"=="1" goto FJJ
goto restart









:FJJ
Set "debug1453=0"
for /f %%i in ('type "icd.ini"') do set "targetNumber=%%i"
if "%targetNumber%" neq "1121" goto BERR

:Check1
if exist "OperatingSystem.bat" (
    goto Check2
) else (
    echo 'OperatingSystem.bat' not found
    echo.
    echo Press Enter To Proceed Anyways
    pause
    goto check2
)

:check2
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\Bootifier.dll" (
    echo ERROR
    echo ERROR
    echo ERROR
    echo ERROR
    echo ERROR
    echo ERROR
    goto CheckErr

) else (
    goto Check3
)

:Check3

:S11
cls
title FujiOS Dual Boot Manager
echo =======================================
echo            Dual Boot Manager
echo =======================================
echo Select an operating system to boot:
echo.
echo 1. Boot %OS% v%VERSION%
echo 2. Boot %ALTOS% v%ALTVERSION%
echo =======================================
CHOICE /C 1234 /M "Enter your choice:"

if %ERRORLEVEL% equ 1 set "Caller=OperatingSystem.bat"
if %ERRORLEVEL% equ 1 set "OS2=%OS%"
if %ERRORLEVEL% equ 1 set "VERSION2=%VERSION%"
if %ERRORLEVEL% equ 2 set "Caller=OperatingSystem2.bat"
if %ERRORLEVEL% equ 2 set "OS2=%ALTOS%"
if %ERRORLEVEL% equ 2 set "VERSION2=%ALTVERSION%"
goto bob

:bob
title %os2%
cls
echo Fuji DOS
echo.
goto bob15

:bob15
if exist "HIBERNATE.log" echo %OS2% v%VERSION2% is Ready For Quick Boot.
if not exist "HIBERNATE.log" echo %OS2% v%VERSION2% is NOT Ready For Quick Boot.
echo.
echo 1. BOOT %OS2% v%VERSION2%
echo 2. Quick Boot %OS2% v%VERSION2%
echo 3. Advanced Mode
echo 4. Exit Kernel
choice /c 123456 /n /m "Choice:"
set choice=%errorlevel%

if %choice% equ 1 goto start1
if %choice% equ 2 goto HIBER1
if %choice% equ 3 goto bob12
if %choice% equ 4 goto exit /b 0
if %choice% equ 5 set "OS2=FujiOS Developer Build"
if %choice% equ 5 set "VERSION2=DEVELOPEMENT"
if %choice% equ 6 set "OS2=FujiOS"
goto bob


:bob12
cls
echo Fuji DOS
echo.
echo Type Start\S for diagnostics start
echo Type Start\Q for quick start
echo Type DEBUG for Debug Mode
echo Type RESET for resetting BIOS
echo Type CLS for clearing screen
echo Type SCAN for antivirus
echo.
set /p op=Command:
if "%op%"=="DEBUG" goto DEBUG
if "%op%"=="Start\S" goto start1
if "%op%"=="Start\Q" goto Start
if "%op%"=="Start\s" goto start1
if "%op%"=="Start\q" goto Start
if "%op%"=="start\S" goto start1
if "%op%"=="start\Q" goto Start
if "%op%"=="start\s" goto start1
if "%op%"=="reset" call fds.bat
if "%op%"=="Reset" call fds.bat
if "%op%"=="RESET" call fds.bat
if "%op%"=="start\q" goto Start
if "%op%"=="cls" goto bob
if "%op%"=="Cls" goto bob
if "%op%"=="CLS" goto bob
if "%op%"=="root" set "Root=true" 
if "%op%"=="root" echo ROOT Kernel 
if "%op%"=="SCAN" call Antivirus.bat
%op%
goto bob12

:DEBUG
Set "debug1453=1"
goto bob

:start1
set "valid_AuthCode=1011"
cls
echo Press E for error check or press S to Skip
CHOICE /C ES /t 10 /d S >nul
if %ERRORLEVEL% equ 2 goto Start
cls
echo Starting VAC Check...
timeout /t 3 /NOBREAK >nul
:Trouble
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\BOOTSEC.sys" (
    timeout /t 1 /NOBREAK >nul
    set /a errorcheck+=1
    echo [92m[+][0m [97mNo Problems Found With BootMGR[0m

) else (
    echo [91m[-][0m [97mError BootMGR May Be Missing[0m

)
timeout /t 1 /NOBREAK >nul
goto Trouble1

:Trouble1
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\BOOTSEC2" (
    timeout /t 1 /NOBREAK >nul
    echo [91m[-][0m [97mError Kernal Bug[0m
) else (
    set /a errorcheck+=1
    echo [92m[+][0m [97mNo Kernal Bugs[0m

)
timeout /t 1 /NOBREAK >nul
goto Trouble2

:Trouble2
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\BURGER.dll" (
    timeout /t 1 /NOBREAK >nul
    echo [91m[-][0m [97mError Operating system file not found[0m
    pause 
    goto KernelERR

) else (
    set /a errorcheck+=1
    timeout /t 1 /NOBREAK >nul
    echo [92m[+][0m [97mValid OS File[0m
)
echo VAC checking Finished
timeout /t 5 /NOBREAK >nul



echo Starting Environment Test...
:: Check if running as an admin
whoami /groups | find "S-1-5-32-544" >nul
if %errorlevel%==0 (
    set /a errorcheck+=1
    echo [92m[+][0m [97mUser has administrative privileges[0m
) else (
    echo [91m[-][0m [97mUser does NOT have administrative privileges[0m
)




:: Check for applied Group Policies
gpresult /r | find "Group Policy was applied" >nul
if %errorlevel%==0 (
    echo [91m[-][0m [97mGroup Policies are applied on this system[0m
) else (
    set /a errorcheck+=1
    echo [92m[+][0m [97mNo Group Policies detected.[0m
)


:: Check registry access restrictions
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies" >nul 2>&1
if %errorlevel%==0 (
    set /a errorcheck+=1
    echo [92m[+][0m [97mRegistry access is available[0m
) else (
    echo [91m[-][0m [97mRegistry access is restricted[0m
)




:: Check for restrictions on task manager
tasklist /FI "IMAGENAME eq taskmgr.exe" >nul 2>&1
if %errorlevel%==0 (
    set /a errorcheck+=1
    echo [92m[+][0m [97mTask Manager can be run[0m
) else (
    echo [91m[-][0m [97mTask Manager may be restricted[0m 
)




:: Check Windows Update settings
reg query "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" >nul 2>&1
if %errorlevel%==0 (
    echo [91m[-][0m [97mWindows Update policies are set, indicating potential restrictions[0m
) else (
    set /a errorcheck+=1
    echo [92m[+][0m [97mNo specific Windows Update policies detected. [0m
)


echo Environment Test Complete
echo.
echo Test %errorcheck% out of 8
set "errorcheck=0"
timeout /t 10 /NOBREAK >nul
tasklist | find /i "afwServ.exe"
taskkill /F /IM afwServ.exe
goto Start

:Start

Call "6Bit.bat"
call cdbit.bat
call 8bit.bat
set "NameFold=%mainfilepath%"
echo. > "%NameFold%\BootTime2" %Date%
cls
timeout /t 1 /NOBREAK >nul
call "%Caller%"
cls
echo %Caller% Ended Call
pause
goto bob1

:bob1
cls
goto bob

:KernelERR
cls
echo.
echo Unable To Find Operating System
echo.
echo.
echo.
echo.
pause
goto bob



:CheckErr
cls
echo.
echo Default Boot Manager Missing Or Boot Failed.
echo Hit any key for Boot Repair
pause >nul
goto BootRep1











:BootRep1
title Boot Repair

echo ================================
echo        Boot Repair Utility
echo ================================

echo Checking for issues...

rem Simulate checking for issues
timeout /nobreak /t 3 >nul

echo.
echo Issues found:
echo Boot Configuration Data (BCD) corruption (90312)
echo.

set /p choice=Enter the number corresponding to the issue: 

if "%choice%"=="90312" goto repairBCD
goto BootRep1

:repairBCD
echo Repairing Boot Configuration Data (BCD)...
timeout /nobreak /t 19 >nul
echo BCD repair complete.
goto repairBootFiles

:repairBootFiles
echo Rebuilding missing boot files...
timeout /nobreak /t 13 >nul
echo Boot files repair complete.
goto repairBootFig

:repairBootFig
set /a "randomNumber=%random% %% 2"

if %randomNumber% equ 0 (
    del /q "%mainfilepath%\Bootifier.dll"
    timeout /nobreak /t 5 >nul
    goto finish
) else (
    goto ErrorL1231
)
echo Rebuilding missing boot files...
timeout /nobreak /t 13 >nul
echo Boot files repair almost complete.

:noIssues
echo No issues found. Nothing to repair.
goto finish

:finish
cls
echo ================================
echo       Repair Completed
echo ================================
echo.
echo Restart your computer for changes to take effect.
pause >nul
goto Check1

:ErrorL1231
cls
echo ================================
echo       Error Repairing
echo ================================
echo.
echo There was an error repairing FujiOS
echo.
echo Undoing Changes...
timeout /nobreak /t 13 >nul
goto Check1



:BERR
cls
echo Possible BIOS Corruption 
echo Press any key to repair
pause >nul
start fds.bat
goto restart


:HIBER1
set "valid_AuthCode=1011"
call "%Caller%"
goto bob1
