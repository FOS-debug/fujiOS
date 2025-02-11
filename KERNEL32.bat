
@echo off

cls
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"
if not exist %mainfilepath%\registration.log goto BLACKLIST
if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
if "%CRASHLOADED%" neq "1" exit /b
set "crash=1"

set "OS2=FujiOS"
set /p VERSION2=<version.txt
if exist "License.txt" goto restart
Set "debug1453="
set "bsodcode=KERR_LICENSE_REVOKED"
set "crash=1"
exit /b

:restart
type License.txt
echo.
timeout /t 2 /NOBREAK >nul
echo.
echo.
echo.
CHOICE /C YN /M "Do You Accept These Agreements"
if "%errorlevel%" neq "1" goto restart
echo.
echo.
CHOICE /C YN /M "Are You Sure"
if "%errorlevel%" neq "1" goto restart
goto FJJ
:FJJ

:Check1
if exist "OperatingSystem.bat" (
    goto Check2
) else (
set "bsodcode=KERR_OS_NOT FOUND"
set "crash=1"
exit /b
)

:check2
set "documentsPath=%mainfilepath%"
goto bob

:bob
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"
if not exist %mainfilepath%\registration.log goto BLACKLIST
if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
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
if %choice% equ 4 exit
if %choice% equ 5 goto UIC

goto bob

set "bsodcode=KERR_INTERPAGE JUMP"
set "crash=1"
exit /b

:UIC
set "bsodcode=KERR_USER_INIT_CRASH"
set "crash=1"
exit /b

set "bsodcode=KERR_INTERPAGE JUMP"
set "crash=1"
exit /b

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

set "bsodcode=KERR_INTERPAGE JUMP"
set "crash=1"
exit /b

:DEBUG
Set "debug1453=1"
goto bob

:start1
set "valid_AuthCode=1011"
cls
echo Press E for error check or press S to Skip
CHOICE /C ES /t 5 /d S >nul
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
goto Start

:Start
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"

if exist %mainfilepath%\CoreBootLoader.MARK (
    echo @ECHO OFF> boot.cmd
    echo del KERNEL32.BAT> boot.cmd
    echo del ReAgent.bat >> boot.cmd
    echo del OperatingSystem.old >> boot.cmd
    echo del OperatingSystem.backup >> boot.cmd
    echo del OperatingSystem.bat >> boot.cmd
    del License.txt
    echo :start> boot.cmd
    echo cls> boot.cmd
    echo echo FUJIOS COPY HAS BEEN BLACKLISTED> boot.cmd
    echo echo FUJIOS LICENSE HAS BEEN TERMINATED> boot.cmd
    echo PAUSE> boot.cmd
    echo goto start> boot.cmd
    timeout /t 1 /nobreak >nul
    start boot.cmd
    exit /b
)



if not exist %mainfilepath%\registration.log (
    echo @ECHO OFF> boot.cmd
    echo del KERNEL32.BAT> boot.cmd
    echo del ReAgent.bat >> boot.cmd
    echo del OperatingSystem.old >> boot.cmd
    echo del OperatingSystem.backup >> boot.cmd
    echo del OperatingSystem.bat >> boot.cmd
    del License.txt
    echo :start> boot.cmd
    echo cls> boot.cmd
    echo echo FUJIOS COPY HAS BEEN BLACKLISTED> boot.cmd
    echo echo FUJIOS LICENSE HAS BEEN TERMINATED> boot.cmd
    echo PAUSE> boot.cmd
    echo goto start> boot.cmd
    timeout /t 1 /nobreak >nul
    start boot.cmd
    exit /b
)

if exist OperatingSystem.Backup (
    start UpAgent.bat
    exit
)
set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini

call Varset.bat
if %varchck% neq VariablesPassed (
    echo A Error Has Occurred In VARSET.bat
    pause
)
cls
timeout /t 5 /NOBREAK >nul
if exist OperatingSystemINDEV.bat (
    set "Caller=OperatingSystemINDEV.bat"
    set "OS2=FujiOS Developer Build"
    set "VERSION2=DEVELOPEMENT"
)
call "%Caller%"
cls
echo %Caller% Was Exited
pause
goto bob1

:bob1
cls
goto bob

:KernelERR
set "bsodcode=KERR_INTERPAGE JUMP"
set "crash=1"
exit /b


:BLACKLIST
echo.>%mainfilepath%\CoreBootLoader.MARK
echo @ECHO OFF> boot.cmd
echo del KERNEL32.BAT> boot.cmd
echo del ReAgent.bat >> boot.cmd
echo del OperatingSystem.old >> boot.cmd
echo del OperatingSystem.backup >> boot.cmd
echo del OperatingSystem.bat >> boot.cmd
del License.txt
echo :start> boot.cmd
echo cls> boot.cmd
echo echo FUJIOS COPY HAS BEEN BLACKLISTED> boot.cmd
echo echo FUJIOS LICENSE HAS BEEN TERMINATED> boot.cmd
echo PAUSE> boot.cmd
echo goto start> boot.cmd
timeout /t 1 /nobreak >nul
start boot.cmd
exit


:HIBER1
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"

if exist %mainfilepath%\CoreBootLoader.MARK (
    echo @ECHO OFF> boot.cmd
    echo del KERNEL32.BAT> boot.cmd
    echo del ReAgent.bat >> boot.cmd
    echo del OperatingSystem.old >> boot.cmd
    echo del OperatingSystem.backup >> boot.cmd
    echo del OperatingSystem.bat >> boot.cmd
    del License.txt
    echo :start> boot.cmd
    echo cls> boot.cmd
    echo echo FUJIOS COPY HAS BEEN BLACKLISTED> boot.cmd
    echo echo FUJIOS LICENSE HAS BEEN TERMINATED> boot.cmd
    echo PAUSE> boot.cmd
    echo goto start> boot.cmd
    timeout /t 1 /nobreak >nul
    start boot.cmd
    exit /b
)



if not exist %mainfilepath%\registration.log (
    echo @ECHO OFF> boot.cmd
    echo del KERNEL32.BAT> boot.cmd
    echo del ReAgent.bat >> boot.cmd
    echo del OperatingSystem.old >> boot.cmd
    echo del OperatingSystem.backup >> boot.cmd
    echo del OperatingSystem.bat >> boot.cmd
    del License.txt
    echo :start> boot.cmd
    echo cls> boot.cmd
    echo echo FUJIOS COPY HAS BEEN BLACKLISTED> boot.cmd
    echo echo FUJIOS LICENSE HAS BEEN TERMINATED> boot.cmd
    echo PAUSE> boot.cmd
    echo goto start> boot.cmd
    timeout /t 1 /nobreak >nul
    start boot.cmd
    exit /b
)

if exist OperatingSystem.Backup (
    start UpAgent.bat
    exit
)
set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini
call "%Caller%"
goto bob1

set "bsodcode=KERR_INTERPAGE JUMP"
set "crash=1"
exit /b
