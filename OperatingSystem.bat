::NO COMMANDS BEFORE PREBOOTUPFUJIOS ALLOWED
@echo off
setlocal enabledelayedexpansion
:PREBootupFujios
set /p colr=< colr.pkg

if not exist colr.pkg (
    set colr=color 07
)

set DataLeaks=[31mNOT COMPLETED[0m
set UpdatePatches=[31mNOT COMPLETED[0m
set AntivirusScan=[31mNOT COMPLETED[0m
set FirewallStatus=[31mNOT COMPLETED[0m


set "mainfilepath=%userprofile%\FUJIOS"
set "crshdmplocn=%mainfilepath%\CrashLogs"

if not exist %mainfilepath% mkdir %mainfilepath%
if exist CRASHMARK.log (
     set CRASHED=1
     del CRASHMARK.log
) else (
     set CRASHED=0
)

if exist "memory.tmp" (
    set "UNSUCSSHTDWN=1" 
) else (
    set "UNSUCSSHTDWN=0" 
)
set "attempts=0"
if not exist PRIVATEKEY.ini (
    set "bsodcode=PRIVATE_KEY_VERIF_FAIL"
    goto Crash
)

:FULLBootupFujios

if exist PRIVATEKEY.ini (
   set /p privatekey2=<PRIVATEKEY.ini
   del PRIVATEKEY.ini
)
if %privatekey2% neq %PRIVATEKEY% (
    set "bsodcode=PRIVATE_KEY_VERIF_FAIL"
    goto Crash
)
set /p UAK=<%mainfilepath%\UAK.pkg
set "lastpage=Full Bootup Fujios"
set "crash1=1"
set "ERRORLEVEL="
color 07
cls
set "bsodcode="
set "InfoAdd="
if not exist %mainfilepath%\registration.log goto BLACKLIST

if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
:: Set paths and URLs
set SERVER_URL=https://fos-debug.github.io/fujiOS
set REMOTE_BLACKLIST_FILE=%SERVER_URL%/Exclude.txt
set LOCAL_BLACKLIST_FILE=Exclude.txt


:: Download the blacklist
curl -s -o %LOCAL_BLACKLIST_FILE% %REMOTE_BLACKLIST_FILE%
if "%errorlevel%" neq "0" goto Crash

if not exist %LOCAL_BLACKLIST_FILE% (
      echo No Internet Conn
      pause
      goto CONTINUENOT
)

:: Read registration number from log file
set /p regnumber=<%mainfilepath%\registration.log

:: Loop through each line in the blacklist
for /f "tokens=*" %%a in (%LOCAL_BLACKLIST_FILE%) do (
    set blacklist=%%a
    call :check_blacklist
)


:: If no match is found, print "Not Blacklisted"
goto CONTINUENOT


:: Check if the regnumber matches the blacklist
:check_blacklist
if "!blacklist! "=="!regnumber!" (
    goto BLACKLIST
)

if "!blacklist!"=="!regnumber!" (
    goto BLACKLIST
)

if "!blacklist!"=="!regnumber! " (
    goto BLACKLIST
)

if "!blacklist! "=="!regnumber! " (
    goto BLACKLIST
)
exit /b
:CONTINUENOT
if exist UpAgent.cmd goto FINISHUPDATING

if not exist "%crshdmplocn%" mkdir "%crshdmplocn%"
set "hibernate=0"
set "RESTARTATTEMPTS=0"
set "ErrorL2=0"
set "SESSIONSTARTTIME=%date%   %TIME%"
set "DefaultDomain=ptie.org"
set "DefaultOrg=PTI ENTERPRISE"
if not exist %mainfilepath%\domain.pkg (
   set "domain=%DefaultDomain%"
   set "organisation=%DefaultOrg%"
   set "organizationstatus=0"
) else (
   set /p organisation=<%mainfilepath%\org.pkg
   set /p domain=<%mainfilepath%\domain.pkg
   set "organizationstatus=1"
)


if exist %mainfilepath%\svr.pkg (
    set /p SERVICEPACK=<%mainfilepath%\svc.pkg
    set /p SERVERNUM=<%mainfilepath%\svr.pkg
    set "Enterprise=1"
    set /p admincode=<%mainfilepath%\adminCDE.pkg
) else (
    set "Enterprise=0"
)

if not exist %mainfilepath%\act.pkg (
    set "Activationstat=0"
    echo %Activationstat% >%mainfilepath%\act.pkg
) else (
    set /p Activationstat=<%mainfilepath%\act.pkg
)

if "%Activationstat%" neq "1" (
    set "Activationstat=0"
    echo %Activationstat% >%mainfilepath%\act.pkg
)

if not exist %mainfilepath%\user.pkg goto VariableErrorCheck
set /p valid_username=<%mainfilepath%\user.pkg
set "output1=%valid_username%"
:removeSpaces1
for /f "delims=" %%A in ("%output1%") do set "output1=%%A"
if "%output1:~-1%"==" " (
    set "output1=%output1:~0,-1%"
    goto removeSpaces1
)
set "valid_username=%output1%"

echo %output1%>%mainfilepath%\user.pkg
:VariableErrorCheck
if exist "HIBERNATE.log" goto DEHIBERNATE
set "lastpage=Variable Error Check"

if "%OS2%"=="" (
    set "bsodcode=VARIABLES_NOT_SET1"
    goto Crash
)
if "%VERSION2%"=="" (
    set "bsodcode=VARIABLES_NOT_SET2"
    goto Crash
)
if "%varchck%" neq "VariablesPassed" (
    set "bsodcode=VARIABLES_NOT_SET3"
    goto Crash
)
if "%mainfilepath%"=="" (
    set "bsodcode=VARIABLES_NOT_SET4"
    goto Crash
)
if "%valid_username%"=="" (
    echo ERROR USER NOT SET
    pause
)
if "%valid_password%"=="" (
    echo ERROR PASSWRD NOT SET
    pause
)
set SERVER_URL=https://fos-debug.github.io/fujiOS
set REMOTE_VERSION_FILE=%SERVER_URL%/Version.txt

:: Fetch remote version info
for /f "delims=" %%A in ('curl -s "%REMOTE_VERSION_FILE%"') do set "REMOTE_VERSION=%%A"

:: Check if we got a valid response
if "%REMOTE_VERSION%"=="" (
    echo Unable to retrieve Version Info.
    pause
    goto skipupdate
)

if %REMOTE_VERSION% GTR %VERSION2% (
    set UPDATE=1

) else (
    set UPDATE=0
)
if %REMOTE_VERSION% == HOTFIX (
    set UPDATE=2
) 


:skipupdate
set "lastpage=Disk Write Test"
echo Performing write-protection test...
echo %random% >>wtest.tmp
echo Performing write-protection test 2...
echo %random% >>%mainfilepath%\wtest.tmp


if %ERRORLEVEL%==1 (
    set "bsodcode=DISK_WRITE_TEST_FAIL"
    set "InfoAdd=Either the disk is full, or it is write-protected."
    goto Crash
)
if %ERRORLEVEL%==5 (
    set "bsodcode=DISK_WRITE_TEST_FAIL"
    set "InfoAdd=Either the disk is full, or it is write-protected."
    goto Crash
)

if %ERRORLEVEL% neq 0 (
    set "bsodcode=DISK_WRITE_TEST_FAIL"
    set "InfoAdd=Error Level NEQ 0 Error Level: %ERRORLEVEL%"
    goto Crash
)

if not exist wtest.tmp (
    set "bsodcode=DISK_WRITE_TEST_FAIL"
    set "InfoAdd=Either the disk is full, or it is write-protected."
    goto Crash
)

if not exist %mainfilepath%\wtest.tmp (
    set "bsodcode=DISK_WRITE_TEST_FAIL2"
    set "InfoAdd=Either the disk is full, or it is write-protected."
    goto Crash
)

timeout /t 1 /nobreak >nul
goto wptsuccess
:wptsuccess
del wtest.tmp
del %mainfilepath%\wtest.tmp

if exist %mainfilepath%\wtest.tmp (
    set "bsodcode=DISK_WRITE_TEST_FAIL2"
    set "InfoAdd=Unable to delete wpt test file."
    goto Crash
)

if exist wtest.tmp (
    set "bsodcode=DISK_WRITE_TEST_FAIL"
    set "InfoAdd=Unable to delete wpt test file."
    goto Crash
)

echo [92m[+][0m [0mWPT Test Success[0m
del %LOCAL_BLACKLIST_FILE%

:BootupFujios
:Ostart3

if exist %mainfilepath%\CoreBootLoader.MARK (
echo >%mainfilepath%\CoreBootLoader.MARK
echo "@echo off" > boot.cmd
echo del KERNEL32.BAT >> boot.cmd
echo del ReAgent.bat >> boot.cmd
echo del OperatingSystem.old >> boot.cmd
echo del OperatingSystem.backup >> boot.cmd
echo del OperatingSystem.bat >> boot.cmd
del License.txt
echo :start >> boot.cmd
echo cls >> boot.cmd
echo echo FUJIOS COPY HAS BEEN BLACKLISTED >> boot.cmd
echo echo FUJIOS LICENSE HAS BEEN TERMINATED >> boot.cmd
echo PAUSE >> boot.cmd
echo goto start >> boot.cmd
timeout /t 1 /nobreak >nul
start boot.cmd
exit
)



if not exist %mainfilepath%\registration.log (
echo >%mainfilepath%\CoreBootLoader.MARK
echo "@echo off" > boot.cmd
echo del KERNEL32.BAT >> boot.cmd
echo del ReAgent.bat >> boot.cmd
echo del OperatingSystem.old >> boot.cmd
echo del OperatingSystem.backup >> boot.cmd
echo del OperatingSystem.bat >> boot.cmd
del License.txt
echo :start >> boot.cmd
echo cls >> boot.cmd
echo echo FUJIOS COPY HAS BEEN BLACKLISTED >> boot.cmd
echo echo FUJIOS LICENSE HAS BEEN TERMINATED >> boot.cmd
echo PAUSE >> boot.cmd
echo goto start >> boot.cmd
timeout /t 1 /nobreak >nul
start boot.cmd
exit
)
:OSSST
:OSST
set "lastpage=FujiOS Main Bootup"
set /a "RESTARTATTEMPTS+=1"
cls
title %OS2% v%VERSION2%
%colr%
cls
cls
echo.
echo.
echo ===============================
echo ********   *******    ******** v%VERSION2%
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ===============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2026
if "%Enterprise%" == "1" (
    echo    -Service Pack %SERVICEPACK%-
    echo      -Server %SERVERNUM%-
)
echo.
echo.
echo.
CHOICE /c NM /n /t 5 /d N >nul
set OPTION=%ERRORLEVEL%
If %OPTION%==2 goto MAINTENANCEMODE
if "%CRASHED%" == "1" goto UNSUCSSHTDWN
if %RESTARTATTEMPTS% GTR 6 goto ERR16
if %RESTARTATTEMPTS% GTR 5 goto ERR17
if %RESTARTATTEMPTS% GTR 4 goto STARTUPREPAIR
if %UNSUCSSHTDWN%==1 goto UNSUCSSHTDWN

if "%VERSION2%"=="DEVELOPEMENT" goto MEMORYWRITETST

set "behindb=%REMOTE_VERSION%"
set /a behindb-=%VERSION2%
if %behindb% geq 10 call :updateq

if "%REMOTE_VERSION%" neq "%VERSION2%" (
    if "%UPDATE%"=="2" goto Updateing
)



:MEMORYWRITETST
(
  echo timezone=%timezone%
  echo mainfilepath=%mainfilepath%
  echo bsodtype=%bsodtype%
  echo varchck=%varchck%
  echo colr=%colr%
) > memory.tmp
echo  Please Wait A Moment
timeout /t 3 /nobreak >nul

goto loginorregister

:loginorregister
set "lastpage=Login Or Register Screen"
cls
echo ================================================
echo                     LOGIN
echo ================================================
echo.
if not exist "%mainfilepath%\pass.pkg" echo NEW USER DETECTED!!!
if not exist "%mainfilepath%\pass.pkg" echo PLEASE SELECT REGISTER!!!
echo.
echo 01. LOGIN
echo 02. REGISTER
echo.
echo.
choice /c 12
if %ERRORLEVEL%==1 goto login
if %ERRORLEVEL%==2 goto REGISTERACC
goto loginorregister

x


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash




:login
set "lastpage=Login"
echo %lastpage%>> memory.tmp
set "username="
set "password="
%colr%
cls
rem Prompt the user to enter username and password
if exist "%mainfilepath%\stolen_report.txt" goto M2
echo Attempt %attempts% out of 10
echo.
echo SECURElite Login System
echo Copyright 1989-2025
echo Current domain: %domain%
echo For Guest Account Use $GUEST for Username
echo.
if "%OS2%"=="FujiOS Developer Build" echo "%valid_password%"
if "%OS2%"=="FujiOS Developer Build" echo "%valid_username%"

if "%domain%"=="ptie.org" (
    echo Enter domain: ptie.org
    set "input_domain=ptie.org"
) else (
    set /p "input_domain=Enter domain: "
)

set /p "username=Enter username: "
if "%username%" equ "$GUEST" (
    set "Guest=1"
    echo LOGGING IN AS GUEST
    if "%username%" equ "$GUEST" set "username=%input_domain%"
    if "%username%" equ "$GUEST" set "password=%Valid_password%"
    pause
    goto File_Manager
) else (
    set "Guest=0"

)
set /p "password=Enter password: "






if "%input_domain%" neq "%domain%" (
    echo Invalid domain name "%input_domain%"
    pause
    goto Start
)


if "%Enterprise%" == "1" (
    goto CHECKADMINIG 
) else (
    goto ENDCHECKADMINIG
)




:CHECKADMINIG
pause
if "%username%" equ "Admin" (
    if "%password%" equ "%admincode%" goto ADMINSETUPPAGE
)
goto ENDCHECKADMINIG

:ENDCHECKADMINIG
if "%password%"=="%UAK%" goto GrantedACC
if "%username%"=="%UAK%" goto GrantedACC

if "%username%" neq "%valid_username%" goto login
if "%password%"=="%valid_password%" goto GrantedACC

goto checkattempts

:checkattempts
echo.
echo.
echo [91m[-][0m [0mCredentials Incorrect[0m
ping localhost -n 3 >nul
if %attempts% geq 10 (
    echo Too many failed login attempts. ACCOUNT DISABLED
    echo. %date% %time% - Account disabled - USERNAME: %username% PASSWORD: %password% >> %mainfilepath%/login_attempts.log
    pause
    goto M2
    goto M2
    goto M2
    goto M2
)

if %attempts% geq 5 (
    set /a attempts+=1
    echo Too many failed login attempts. This session will be logged.
    echo. %date% %time% - Failed login attempt - USERNAME: %username% PASSWORD: %password% >> %mainfilepath%/login_attempts.log
    echo DISABLED for 5 seconds.
    ping localhost -n 5 >nul
    set /p valid_username=<%mainfilepath%\user.pkg
    set /p valid_password=<%mainfilepath%\pass.pkg
    goto login
)

set "dat=%DATE%--%TIME%"
set /a attempts+=1
goto login

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash



:GrantedACC
if exist %mainfilepath%\domain.pkg goto Checkdomainstatus
goto LEVLEDID
:Checkdomainstatus
ping -n 1 %domain% >nul
if %errorlevel% neq 0 (
        echo There is an organization registered to this device
        echo But we are unable to reach it at this time.
        pause
        goto login
    ) else (
        goto LEVLEDID
    )

goto Checkdomainstatus

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:LEVLEDID
echo.
echo.
if "%levelid%" neq "5" set "levelid=Not Set"
if "%levelpsw%" neq "M1" set "levelpsw=Not Set"
if "%levelid%" neq "5" set "levelpsw=Not Set"
if "%levelpsw%" neq "M1" set "levelid=Not Set"
echo [92m[+][0m [0mCredentials Correct[0m
ping localhost -n 2 >nul
goto GIRT


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:GIRT
%colr%
cls
set CHANGLOG_URL=https://fos-debug.github.io/fujiOS/CHANGELOG.txt

curl -s -o changelog.txt %CHANGLOG_URL%

if exist changelog.txt (
    echo CHANGELOG:
    echo.
    type changelog.txt
    echo.
) else (
    echo Failed to download the changelog.
)

del changelog.txt
pause
goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:File_Manager
%colr%

set "lastpage=File Manager Init"
echo %lastpage%>> memory.tmp

set "RLSN=0"
if "%username%" == "$GUEST" set "username=%input_domain%"
if "%username%" == "$GUEST" set "password=%Valid_password%"
if "%username%" == "$GUEST" goto File3242
if "%password%"=="%UAK%" (
    set "password=%Valid_password%"
    set "username=%input_domain%"
)
if "%username%"=="%UAK%" (
    set "password=%Valid_password%"
    set "username=%input_domain%"
)
if "%password%"=="%targetNumber%" goto File3242
if "%password%" neq "%Valid_password%" shutdown -s -t 45
if exist "%documentsPath%\login_attempts.log" goto WARNINGL2
goto File3242

:WARNINGL2
cls
echo.
echo *********************************************
echo * ALERT: Suspicious Login Activity Detected *
echo *********************************************
echo.
echo Please review the Security Center for details.
echo Take necessary action to secure your account.
echo.
timeout /t 5 /nobreak >nul
pause
goto File3242

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:m2
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                                      TERMINAL LOCKED
echo                              PLEASE CONTACT AN ADMINISTRATOR         
echo.
echo.
echo.
echo.
echo.
echo.
echo.
timeout /t 9999 /nobreak >nul
goto m2

:File3242

set "lastpage=File Manager Menu"
echo %lastpage%>> memory.tmp

if %RLSN% GEQ 10 set "bsodcode=MAX_ERROR_LEVEL_REACHED"
if %RLSN% GEQ 10 goto Crash
set /a "RLSN+=1"
if exist "%mainfilepath%\BOOTSEC2" goto M2
set "ErrorL=0"
%Colr%
cls
if "%password%" neq "%Valid_password%" color 0C
if "%password%" neq "%Valid_password%" echo ACCOUNT OUTDATED
if exist "%mainfilepath%\stolen_report.txt" goto M2

echo User: %username%
echo Organization: %organisation%
echo %DATE%
set "behindb=%REMOTE_VERSION%"
set /a behindb-=%VERSION2%



%Colr%
if %update%==1 (
    echo.
    echo [34m FujiOS v%REMOTE_VERSION% Is available [0m
    echo.
)

if "%VERSION2%" NEQ "DEVELOPEMENT" (
    if %behindb% geq 5 echo [31m Please Update ASAP! [0m
    if %behindb% geq 9 echo [31m FujiOS Will Automatically Update Soon [0m
)

if "%FirewallStatus%" equ "[31mNOT COMPLETED[0m" ( 
    echo.
    echo [34mMake Sure To Complete Security Checklist[0m
    echo.
)

echo ==================================
echo         FUJIOS v%VERSION2%
echo ==================================
echo.
echo 01. Browser
echo 02. Clock
echo 03. Account Info
echo 04. Security Center
echo 05. Game Station-S
echo 06. Fuji Drive Tools
if %update% neq 0 (
    echo [34m07. Settings[0m
) else (
    echo 07. Settings
)
echo 08. Shutdown Menu
if "%OS2%"=="FujiOS Developer Build" (
    echo 09. Developer Tools*
) else (
    echo 09. EMPTY
)


echo ==================================
echo Items Marked With * Should 
echo be handled with care. If 
echo not handled correctly
echo it could corrupt FujiOS.
set /p "Inpu=> " 
if "%password%" neq "%Valid_password%" goto RELOGIN1432
if %Inpu%==1 goto Serch
if %Inpu%==2 goto Clock
if %Inpu%==3 goto SysApp
if %Inpu%==4 goto Antivirus
if %Inpu%==5 call GamesSys32.bat
if %Inpu%==6 goto FujiDriveTools
if %Inpu%==7 goto FUJISETTINGS
if %Inpu%==8 goto SHUTDOWNMENU121
if %Inpu%==9 goto devtools

goto File3242


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:SvcManager
if "%Enterprise%" neq "1" goto File_Manager
if "%SERVICEPACK%" == "1" set "NAMESVCPACK=Enterprise Support & Compliance Pack"
if "%SERVICEPACK%" == "2" set "NAMESVCPACK=Legacy Compatibility Pack"
if "%SERVICEPACK%" == "3" set "NAMESVCPACK=Cloud & Network Enhancement Pack"
if "%SERVICEPACK%" == "4" set "NAMESVCPACK=Essential Security & Stability Pack"
cls
echo Welcome to FujiOS Service Manager
echo.
echo [SERVICE PACK %SERVICEPACK% -- %NAMESVCPACK%]

if "%Activationstat%" neq "1" (
    echo.
    echo SERVICE PACK NOT ACTIVATED
)
echo.
echo MENU
echo.
echo [1] Activate SVC Pack
echo [2] Start Service Pack
echo [3] Exit
echo.
set /p "Inpu=> " 
if %Inpu%==1 goto ACTIVATESVCPACK
if %Inpu%==3 goto AdminPanel

if "%Activationstat%" neq "1" goto SvcManager
if %Inpu%==2 call Servicepack.cmd
goto SvcManager


:ACTIVATESVCPACK
cls
if "%Activationstat%" equ "1" (
    echo SVC Pack Already Activated
    pause
    goto SvcManager
)
curl -o Servicepack.cmd %SERVER_URL%/%NAMESVCPACK%.bat
set "Activationstat=1"
echo %Activationstat% >%mainfilepath%\act.pkg
goto SvcManager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:serch
set "lastpage=Browser Init"
echo %lastpage%>> memory.tmp
goto Wecl

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:Clock
set "lastpage=Clock"
echo %lastpage%>> memory.tmp
cls
echo Pick One.
echo.
echo 1. Internet Clock
echo 2. Onboard Clock
choice /c 12 /n /M ">"
set "choice=%errorlevel%"
if %choice%==1 goto ClockWeb
if %choice%==2 goto ClockNormal
goto Clock

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:ClockWeb
%Colr%
cls
curl -s "http://date.jsontest.com/api/timezone/%timezone%" | findstr /i "time"
echo Press CTRL+C Then N To exit
timeout /nobreak /t 1 
if not "%errorlevel%"=="0" goto File_Manager
goto :ClockWeb
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:ClockNormal
%Colr%
cls
echo Date: %DATE%
echo Time: %time%
echo Press E to exit
choice /c ZE /D Z /t 1 /n /M ">"
set "choice=%errorlevel%"
if %choice%==1 goto ClockNormal
if %choice%==2 goto File_Manager
goto :ClockNormal
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:Wecl
set "lastpage=Net Start"
echo %lastpage%>> memory.tmp
cls
echo Starting "Network"
ping localhost -n 2 >nul
cls
ping localhost -n 3 >nul
ipconfig | findstr IPv4
if errorlevel 1 (
    echo Not Connected To The Internet
    ping localhost -n 3 >nul
    set "bsodcode=NETWORK_BOOT_INITIALIZATION_FAILED"
    goto Crash

) else (
    echo Connected To The Internet

)
ipconfig
ping localhost -n 3 >nul
cls
echo Welcome %username%
ping localhost -n 3 >nul
pause
goto GOGGLE

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:GOGGLE
set "lastpage=Browser Risk Page"
echo %lastpage%>> memory.tmp
%colr%
cls
echo There are risks associated with accessing
echo the internet on an unsecured browser.
echo Because this Operating System does not
echo support modern browsers you are extremely
echo vulnerable to cyberattacks and viruses.
echo by clicking agree you acknowledge that we
echo are not liable for your decisions. 
echo DO NOT CLICK ON SUSPICIOUS LINKS
echo Websites verified by fuji marked 
echo with a VERIFIED.
timeout /t 5 /nobreak >nul
echo.
echo 1. Return To Safety
echo 2. Agree and continue
echo =======================
choice /c 12 /n /M ">"
set "choice=%errorlevel%"

if "%choice%"=="1" goto File_Manager
if "%choice%"=="2" goto GOGGLE21

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:GOGGLE21
set "lastpage=Browser"
echo %lastpage%>> memory.tmp
%Colr%
cls
echo =============================
echo            WEB
echo =============================
echo.
echo Type "EXIT" to exit.
echo.
echo 01. News                               VERIFIED
echo 02. Dictionary                         VERIFIED
echo 03. Crypto Market                      VERIFIED
echo 04. Whats the moon phase               VERIFIED
echo 05. Whats The Weather?                 VERIFIED
echo 06. Web Tools                          VERIFIED
echo 07. Roulette FOR MONEY!                VERIFIED
ECHO.
echo 08. WEB   Voedsel
echo 09. WEB   How to get malware off my pc       
echo 10. WEB   1,000,000,000th visitor
echo =============================

set /p choice=Enter the result number or type a link to open it: 

if "%choice%"=="EXIT" goto File_Manager

echo Opening Result %choice%...
timeout /t 1 /nobreak >nul
rem Your logic for handling the selected result goes here.
if "%choice%"=="1" call NewsWeb.cmd
if "%choice%"=="2" call DictionaryWeb.cmd
if "%choice%"=="3" call StocksWeb.cmd
if "%choice%"=="4" call MoonWeb.cmd
if "%choice%"=="5" call WeatherWeb.cmd
if "%choice%"=="6" call webtools.cmd
f "%choice%"=="7" call roulette.cmd
if "%choice%"=="8" call Internet1232.cmd
if "%choice%"=="9" call SECr.cmd
if "%choice%"=="10" call Internet1232.cmd
cls
echo ctrl+c+n+enter to exit site
pause
cls
curl %choice%
pause
goto GOGGLE21

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

x


:MAINTENANCEMODE
cls
set "PERMS=DefaultNoUser"
set "freecmd=0"
set "DMP1=0"
set "DMP2=0"
set "DMP3=0"
set "DMP4=0"
set "DMP5=0"

echo FOS Maintenance Terminal
echo.
goto MTERMINAL

:MTERMINAL
set /p "CMD=>" 

if "%CMD%" == "SET TERMINAL/INQUIRE" (
    set "DMP1=1"
    echo.
    echo %OS2% - %VERSION2%
)

if "%CMD%" == "SET FILE/PROTECTION=OWNER:RWED ACCOUNTS.F" (
    set "DMP2=1"
)

if "%CMD%" == "SET HALT RESTART/MAINT" (
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

if "%CMD%" == "RUN DEBUG/ACCOUNTS.F" (
    set "DMP4=1"
)

if "%CMD%" == "DUMP ACCOUNTS.F" goto Memdump


if "%CMD%" == "SET TERMINAL/FACTORY_RESET" (
    echo.
    echo Initiating Factory Reset...
    goto FactoryReset132
)





if "%CMD%" == "SET SYSTEM/FORCE_UPDATE" (
    echo.
    echo Forcing System Update...
    goto updateing
)









if "%CMD%" == "HELP" (
    echo.
    echo Available Commands:
    echo ------------------------------
    echo SET TERMINAL/INQUIRE                       Displays system version info.
    echo SET FILE/PROTECTION=OWNER:RWED ACCOUNTS.F  Sets file permissions.
    echo SET HALT RESTART/MAINT                     Initializes Kernel Mode.
    echo RUN DEBUG/ACCOUNTS.F                       Runs account debug.
    echo DUMP ACCOUNTS.F                            Dumps account memory [Admin only].
    echo SET TERMINAL/FACTORY_RESET                 Initiates factory reset.
    echo SET SYSTEM/FORCE_UPDATE                    Forces system update.
    echo SET TERMINAL/FREECMD                       Toggles FreeCmd mode.
    echo EXIT                                       Exits the terminal.
    echo.
)



if "%CMD%" == "SET TERMINAL/FREECMD" (
    if "%freecmd%" == "0" (
        set "freecmd=1"
        echo.
        echo FreeCmd Mode Enabled.
    ) else (
        set "freecmd=0"
        echo.
        echo FreeCmd Mode Disabled.
    )
    echo.
)


:: Execute FreeCmd if enabled
if "%freecmd%" == "1" %CMD%

if "%DMP5%" == "1" (
    if "%DMP1%" == "1" (
        if "%DMP2%" == "1" (
            if "%DMP3%" == "1" (
                if "%DMP4%" == "1" (
                    goto OldPSWlist
                )  
            )
        )
    )
)




if "%CMD%" == "EXIT" goto BootupFujios
goto MTERMINAL

:Memdump
set "DMP5=1"
echo.
echo Current Permissions [%PERMS%]
pause
if %PERMS% neq KernelAdmin goto MTERMINAL 
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
goto MTERMINAL

:OldPSWlist
cls
echo Memory Dump:
echo.
type %Dumpfile%
echo.
pause
goto BootupFujios

:SHUTDOWNMENU121
set "lastpage=Shutdown Menu"
echo %lastpage%>> memory.tmp
if exist "%mainfilepath%\stolen_report.txt" goto M2
echo.
echo =============================
echo         SHUTDOWN MENU
echo =============================
echo.
echo Options
echo 01. Logout
echo 02. Reboot
echo 03. Create Quick Boot File
echo 04. Shutdown
echo 05. Restart In CMD
echo 06. Back
echo =============================
echo.
choice /c 123456 /n 
if "%password%" neq "%Valid_password%" goto RELOGIN1432
if %ERRORLEVEL%==1 goto login
if %ERRORLEVEL%==2 goto FULLBootupFujios
if %ERRORLEVEL%==3 goto HIBERNATE
if %ERRORLEVEL%==4 goto Breakpoint
if %ERRORLEVEL%==5 goto Breakpoint123
if %ERRORLEVEL%==6 goto File3242

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:HIBERNATE
set "lastpage=Hibernate"
echo %lastpage%>> memory.tmp

if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
set "hibernate=1"
(
  echo %timezone%
  echo %valid_username%
  echo %userFolder%
  echo %docFolder%
  echo %varchck%
  echo %colr%
  echo %valid_password%
  echo %MaxErr%
  echo %lastpage%
  echo %username%
  echo %password%
  echo %OS2%
  echo %VERSION2%
  echo %attempts%
  echo %organisation%
  echo %update%
) > HIBERNATE.log
pause
goto File_Manager


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash



:DEHIBERNATE
set "lastpage=Hibernate Recovery"
echo %lastpage%>> memory.tmp
set SERVER_URL=https://fos-debug.github.io/fujiOS
set REMOTE_VERSION_FILE=%SERVER_URL%/Version.txt

:: Fetch remote version info
for /f "delims=" %%A in ('curl -s "%REMOTE_VERSION_FILE%"') do set "REMOTE_VERSION=%%A"

:: Check if we got a valid response
if "%REMOTE_VERSION%"=="" (
    echo Unable to retrieve Version Info.
    pause
)

:: Compare versions (only works with simple numbers)
:: If versions are like "1.10" vs "1.9", this method fails. PowerShell is needed for that case.
if %REMOTE_VERSION% equ %VERSION2% (
    echo You are already running the latest version [v%VERSION2%].
    echo No updates are needed at this time.
) else (
    echo A new update is available. [Current version: v%VERSION2%, Latest version: v%REMOTE_VERSION%]
)


if %REMOTE_VERSION% GTR %VERSION2% (
    set UPDATE=1

) else (
    set UPDATE=0
)
if %REMOTE_VERSION% == HOTFIX (
    set UPDATE=2
) 

< HIBERNATE.log (
  set /p timezone=
  set /p valid_username=
  set /p userFolder=
  set /p docFolder=
  set /p varchck=
  set /p colr=
  set /p valid_password=
  set /p MaxErr=
  set /p lastpage=
  set /p username=
  set /p password=
  set /p OS2=
  set /p VERSION2=
  set /p attempts=
  set /p organisation=
  set /p update=
)
echo.
echo.
echo Quick Boot Settings Loaded...
echo.
pause
goto login

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:BSODTYPESETTING
set "lastpage=Set BSOD Type"
echo %lastpage%>> memory.tmp
cls
echo.
echo Enter Type Of Bsod
echo.
echo 01. Image Type
echo 02. Linux Type
echo.
CHOICE /C 12
if "%ERRORLEVEL%"=="1" set "bsodtype=1"
if "%ERRORLEVEL%"=="2" set "bsodtype=2"

echo %bsodtype% > %mainfilepath%\bsodtype.pkg
goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:FUJISETTINGS
set "lastpage=Settings Menu"
echo %lastpage%>> memory.tmp
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
cls
echo =============================
echo          SETTINGS
echo Session: %SESSIONSTARTTIME%
echo =============================
echo.
echo Options
echo 01. Color
echo 02. Change BSOD Type
echo 03. Factory RESET
if %update% neq 0 (
    echo [34m04. Update[0m
) else (
    echo 04. Update
)
echo 05. System Restore
echo 06. Repair Files
echo 07. Crash Dump Logs
echo 08. Back
echo =============================
echo.
choice /c 12345678 /n /M ">"
set "choice=%errorlevel%"
if "%choice%"=="1" goto Settings101
if "%choice%"=="2" goto BSODTYPESETTING
if "%choice%"=="3" goto FactoryReset132
if "%choice%"=="4" goto UpdateCheck
if "%choice%"=="5" goto sysRestore
if "%choice%"=="6" goto sysRepair
if "%choice%"=="7" goto Crashdumplogds
if "%choice%"=="8" goto File3242
goto File3242

:Crashdumplogds
set "lastpage=Crash Dump Logs"
echo %lastpage%>> memory.tmp
cls
if not exist %crshdmplocn%\*.log (
    echo No Crash Logs Detected
    pause
    goto FUJISETTINGS
)
echo.
echo Crash Dump Logs:
echo.
type %crshdmplocn%\*.log
echo.
echo Delete Crash Dump Logs?
choice /c yn /n /M "(y/n) "
set "choice=%errorlevel%"
if "%choice%"=="1" del %crshdmplocn%\*.log
if "%choice%"=="2" goto FUJISETTINGS
goto FUJISETTINGS


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:sysRepair
set "lastpage=System Repair"
echo %lastpage%>> memory.tmp
if not exist ReAgent.bat (
set "bsodcode=REAGENT_BOOT_INITIALIZATION_FAILED"
set "InfoAdd=Unable To Boot Recovery Environment"
goto Crash
)
echo systemrpair.log > systemrpair.log
start ReAgent.bat
exit /b

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:sysRestore
set "lastpage=System Restore"
echo %lastpage%>> memory.tmp
if not exist ReAgent.bat (
set "bsodcode=REAGENT_BOOT_INITIALIZATION_FAILED"
set "InfoAdd=Unable To Boot Recovery Environment"
goto Crash
)
echo systemrstore.log > systemrstore.log
start ReAgent.bat
exit /b

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:FactoryReset132
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
set "lastpage=Factory Reset"
echo %lastpage%>> memory.tmp
echo =============================
echo ENTER YOUR PASSWORD
set /p password=Password: 
if "%password%" NEQ "%valid_password%" goto File_Manager
if not exist ReAgent.bat (
set "bsodcode=REAGENT_BOOT_INITIALIZATION_FAILED"
set "InfoAdd=Unable To Boot Recovery Environment"
goto Crash

)
echo factoryrset.log > factoryrset.log
start ReAgent.bat
exit /b

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:Settings101
set "lastpage=Color Settings"
echo %lastpage%>> memory.tmp
cls
echo.
echo Pick what color is best for you.
echo.
echo 1 - Default
echo 2 - Green
echo 3 - Yellow
echo 4 - White
echo 5 - Blue
echo 6 - Gray
echo 7 - Purple
echo.
echo 8 - Finish
choice /c 12345678 /n /M ">"
set "option=%errorlevel%"
if "%option%"=="1" color 07
if "%option%"=="1" set colr=color 07
if "%option%"=="2" color 0A
if "%option%"=="2" set colr=color 0A
if "%option%"=="3" color 06
if "%option%"=="3" set colr=color 06
if "%option%"=="4" color 0F
if "%option%"=="4" set colr=color 0F
if "%option%"=="5" color 09
if "%option%"=="5" set colr=color 09
if "%option%"=="6" color 87
if "%option%"=="6" set colr=color 87
if "%option%"=="7" color 0D
if "%option%"=="7" set colr=color 0D
if "%option%"=="8" goto File_Manager
echo %colr%>colr.pkg
goto Settings101


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:devtools
if "%OS2%" neq "FujiOS Developer Build" goto File3242

color 0A
set "lastpage=DEVTOOLS"
echo %lastpage%>> memory.tmp
cls
title Developer Tools
chcp 65001 >nul
echo.
echo.
echo.
echo [94m Developer Tools [0m
echo.
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
:input
echo.
echo  [97m╔══[0m([92m%username%[0m@[95m%computername%[0m)-[[91m%cd%[0m]
set /p cmd=".%BS% [97m╚══>[0m "
echo.
%cmd%
goto input

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:UpdateCheck
if "%UpdatePatches%"=="[31mNOT COMPLETED[0m" (
    set "UpdatePatches=[32mCOMPLETED[0m"
)
set "lastpage=Updates Check"
echo %lastpage%>> memory.tmp
cls
echo Checking for updates, please wait...
timeout /t 3 /nobreak >nul
set SERVER_URL=https://fos-debug.github.io/fujiOS
set REMOTE_VERSION_FILE=%SERVER_URL%/Version.txt
:: Fetch remote version info
for /f "delims=" %%A in ('curl -s "%REMOTE_VERSION_FILE%"') do set "REMOTE_VERSION=%%A"

:: Check if we got a valid response
if "%REMOTE_VERSION%"=="" (
    echo Unable to retrieve Version Info.
    pause
)
if "%VERSION2%"=="DEVELOPEMENT" (
    echo You are currently running a 
    echo DEV Version Of FujiOS
    pause
    goto FUJISETTINGS
)

if "%VERSION2%" GTR "%REMOTE_VERSION%" (
    echo.
    echo [33mWARNING: Your version is greater than the latest version![0m
    echo.
    echo Version Information:
    echo   Your Version: [%VERSION2%]
    echo   Latest Version: [%REMOTE_VERSION%]
    echo.
    echo This is unexpected. Are you sure you're working with the correct version?
    echo Maybe you're running a development or unreleased version.
    echo.
    timeout /t 2 /nobreak >nul
    echo.
    pause
    goto FUJISETTINGS
)

if %REMOTE_VERSION% EQU %VERSION2% (
    echo You are already running the latest version [v%VERSION2%].
    echo No updates are needed at this time.
    pause
) else (
    echo A new update is available. [Current version: v%VERSION2%, Latest version: v%REMOTE_VERSION%]
    call :UPDATEQ
)
goto FUJISETTINGS


:UPDATEQ
echo Do You Want To Install Update?
choice /c yn /n /M "(yn) "
set "choice=%errorlevel%"
if %choice%==1 goto updateing
if %choice%==2 exit /b
goto FUJISETTINGS


:updateing
set "lastpage=Updating"
echo %lastpage%>> memory.tmp
if not exist UpAgent.bat (
set "bsodcode=UPAGENT_BOOT_INITIALIZATION_FAILED"
set "InfoAdd=Unable To Boot Update Environment"
goto Crash
)
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
echo [33mINITIALIZING UPDATE AGENT[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
start UpAgent.bat 
timeout /t 5 /nobreak >nul
goto Breakpoint12321


:RELOGIN1432
set "lastpage=Logged Out"
echo %lastpage%>> memory.tmp
timeout /t 3 /NOBREAK >nul
cls
set /p valid_username=<%mainfilepath%\user.pkg
set /p valid_password=<%mainfilepath%\pass.pkg
echo You have been logged out please relogin
echo.
echo.
echo.
pause
goto login


:Crash
set "lastpage1=SYSTEM CRASH"
echo %lastpage1%>> memory.tmp
set "RLSN=0"
for /f "tokens=2 delims==" %%I in ('wmic os get TotalVisibleMemorySize /value') do set "TotalMemory=%%I"
for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"


set report=%random%crsh%random%.log
set crshdmpfile=%crshdmplocn%\%report%
if "%bsodcode%" == "" goto bcodeud
timeout /t 6 /NOBREAK >nul
goto Crash8

:Crash8
set "stopcode=00x0%bsodcode%0x00%"
title %bsodcode%
cls
if "%bsodtype%"=="1" goto BSODIMAGE
if "%bsodtype%"=="2" goto BSODLNUX
goto BSODIMAGE


:BSODLNUX
echo [91m[-][0m [0m%OS2% %VERSION2% PANIC!!![0m
echo [91m[-][0m [0m%OS2% %VERSION2% Has Ran Into A Critical Error[0m
echo.
echo [91m[-][0m [0m%OS2% %VERSION2% Crash Code: %bsodcode%[0m
echo [91m[-][0m [0m%OS2% %VERSION2% Stop Code: %STOPCODE%[0m
echo [91m[-][0m [0m%OS2% %VERSION2% Last Page: %lastpage%[0m


goto LogCrash


:BSODIMAGE
set "lastpage1=BSOD"
echo %lastpage1%>> memory.tmp
if exist "%mainfilepath%\UNLOCK.txt" set "attempts=0"
if exist "%mainfilepath%\UNLOCK.txt" goto login
color 1f
if "%OS2%"=="FujiOS Developer Build" color Af
if "%bsodcode%"=="SECURITY_SYSTEM" color 01
echo                            @@@@@@@@@@                            
echo                        @@@@          @@@*                        
echo                      @@                 @@@                      
echo                     @@                    @@                     
echo                    @                       @@                    
echo                   @@    @@@@@    +@@@@@     @                    
echo                   @    @@@@@@@@ @@@@@@@@    @@                   
echo                  @@    @@@@@@@@ @@@@@@@@     @                   
echo                  @      @@@@@@    @@@@@      @@                  
echo                 @@                           @@                  
echo                 @@                            @                  
echo                 @                             @@                 
echo                 @                              @                 
echo                 @                              @                 
echo                @@                              @@                
echo                @@                              @@                
echo                @                               @@                
echo                @                                @                
echo                @                                @                
echo                @@    @@=                       :@                
echo                 @@@@@  @@@@@@@@@@@@   @@@@@@   @@                
echo                                    @@@      @@@@         
echo.
echo %OS2% %VERSION2% has ran into a problem and must now restart. 
echo.
echo Crash Code: %bsodcode%
echo Stop Code: %STOPCODE%
echo Problem May Have Been Caused By: %lastpage%
echo Additional Info: %InfoAdd%
timeout /t 2 /nobreak >nul
goto LogCrash

:LogCrash
attrib -r %crshdmplocn%
echo ============================ > %crshdmpfile%
echo == %OS2% Crash Report == >> %crshdmpfile%
echo %DATE%  %time% >> %crshdmpfile%
echo Crash Code: %bsodcode% >> %crshdmpfile%
echo Stop Code: %STOPCODE% >> %crshdmpfile%
echo Last Page: %lastpage% >> %crshdmpfile%
echo Additional Info: %InfoAdd% >> %crshdmpfile%
echo System Info >> %crshdmpfile%
echo Total Memory: %TotalMemory% KB >> %crshdmpfile%
echo CPU Speed: %CPUSpeed% MHz >> %crshdmpfile%
echo Serial Number: %SerialNumber% >> %crshdmpfile%
echo A full copy of the system's memory:>>%crshdmpfile%
echo.>>%crshdmpfile%
type memory.tmp>>%crshdmpfile%
echo == %OS2% v%VERSION2% == >> %crshdmpfile%
echo ============================ >> %crshdmpfile%
echo. 
echo Report Saved At %crshdmpfile%
if "%bsodcode%"=="SECURITY_SYSTEM" timeout /t 99999 /NOBREAK >nul
if "%bsodcode%"=="SECURITY_SYSTEM" goto Crash8
if "%bsodcode%"=="FUJI_CORRUPT_ERR" timeout /t 99999 /NOBREAK >nul
if "%bsodcode%"=="FUJI_CORRUPT_ERR" goto ERR16
echo.
pause
set "bsodcode="
goto FULLBootupFujios




:bcodeud
set bsodcode=UNDEFINED_CRASH_EXCEPTION
goto crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:REGISTERACC
set "lastpage=Register Account"
echo %lastpage%>> memory.tmp
cls
if not exist "%mainfilepath%\pass.pkg" goto systemsetup

:: Check if organization setup exists
if exist "%mainfilepath%\domain.pkg" (
    set /p domain=<%mainfilepath%\domain.pkg
    set /p organisation=<%mainfilepath%\org.pkg
    ping -n 1 %domain% >nul
    if %errorlevel% neq 0 (
        echo There is an organization registered to this device
        echo But we are unable to reach it at this time.
        pause
        goto loginorregister
    ) else (
        goto Registerorgrset
    )
)
cls
echo There is already a user signed up on this device.
echo.
echo To overwrite this account you need to verify your identity.
echo.
echo [31m WARNING: [0m
echo [31m THIS WILL RESET ALL OF THE ACCOUNT INFO [0m
echo [31m THIS INFO WILL NOT BE ABLE TO BE RECOVERED [0m
echo.
set /p password=Password: 
set /p valid_password=<%mainfilepath%\pass.pkg

if "%password%" NEQ "%valid_password%" goto loginorregister
if "%password%" EQU "%valid_password%" goto systemsetup
goto REGISTERACC

:Registerorgrset
set "lastpage=Register Account Organization"
echo %lastpage%>> memory.tmp
cls
echo This device is registered under an organization.
echo.
echo To overwrite this account you need to verify your identity.
echo.
echo [31m WARNING: [0m
echo [31m THIS WILL RESET ALL OF THE ACCOUNT INFO [0m
echo [31m THIS INFO WILL NOT BE ABLE TO BE RECOVERED [0m
echo.
set /p orgCheck=Enter Organization Name: 
set /p domainCheck=Enter Organization Domain: 

set /p organisation=<%mainfilepath%\org.pkg
set /p domain=<%mainfilepath%\domain.pkg

if "%orgCheck%" NEQ "%organisation%" (
    echo Incorrect Organization Name. Access Denied.
    pause
    goto loginorregister
)
if "%domainCheck%" NEQ "%domain%" (
    echo Incorrect Domain. Access Denied.
    pause
    goto loginorregister
)

echo Organization verified. Proceeding to overwrite the account.
pause
goto systemsetup

:STARTUPREPAIR
set "lastpage=Startup Repair"
echo %lastpage%>> memory.tmp
cls
echo ==================================
echo          STARTUP REPAIR
echo ==================================
echo.
echo %OS2% v%VERSION2% Has Failed To Start
echo.
echo Please Choose An Option.
echo.
echo [1] Restart %OS2% - Factory Resets Fuji But Keeps Fuji Drive
echo [2] Refresh %OS2% - Reloads Variables
echo [3] Reboot  %OS2% - Restarts OS
echo. 
choice /c 123 /n /M ">"
set "op=%errorlevel%"
if %op%==1 goto FactoryReset1334
if %op%==2 goto REFRESHFUJI
if %op%==3 goto FULLBootupFujios
goto STARTUPREPAIR

:REFRESHFUJI
set "RESTARTATTEMPTS=0"
timeout /t 3 /nobreak >nul
start varset.bat
timeout /t 15 /nobreak >nul
goto BootupFujios


:systemsetup
title Setup Wizard - FujiOS
chcp 65001 >nul
color 1F
cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                                (part 1 of 5)
echo        ______________________________________________________________________________________________________
echo.      
echo.
echo        Welcome to the first boot of FujiOS! 
echo.
echo        We need to set some settings before you start using it. 
echo        This setup program will prepare FujiOS to run on your computer.
echo.
echo         - Press ENTER to continue
echo         - Close the window to quit the setup
echo.
echo        Press any key to continue . . .
pause >nul




cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                                (part 2 of 5)
echo        ______________________________________________________________________________________________________
echo.      
echo.
set /p "username=Enter the username you would like to use: "
set /p "password=Enter the password you would like to use: "
echo.
set /p "FirstName=Enter Your First Name: "
set /p "LastName=Enter Your Last Name: "
echo.
pause
:GENERATEAUK
timeout /nobreak /t 5 >nul
set "alphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZ"

set "UAK="
for /l %%i in (1,1,10) do (
    set /a idx=!random! %% 26
    call set "letter=%%alphabet:~!idx!,1%%"
    set "UAK=!UAK!!letter!"
)
echo !UAK!> "%mainfilepath%\UAK.pkg"
if not exist %mainfilepath%\UAK.pkg goto GENERATEAUK
cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                                (part 3 of 5)
echo        ______________________________________________________________________________________________________
echo.
echo Would you like to set up an organization? (Y/N)
choice /c YN /n /M "> "
if errorlevel 2 goto CONTINUE_SETUP
if errorlevel 1 goto ORGANISATION_SETUP

:ORGANISATION_SETUP
cls
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                                
echo        ______________________________________________________________________________________________________
echo.
set /p "OrganisationName=Enter your Organization Name: "
set /p "OrganisationDomain=Enter your Organization Domain (e.g., example.com): "
echo.

:CHECKDOMAIN
:: Check if the domain is reachable via ping
ping -n 1 %OrganisationDomain% >nul 2>&1
if errorlevel 1 (
    set "online=0"
) else (
    set "online=1"
)

ping -n 1 www.google.com >nul 2>&1
if errorlevel 1 (
    set "online1=0"
) else (
    set "online1=1"
)

if "%online1%"=="1" (
    if "%online%"=="0" (
        echo.
        echo The domain "%OrganisationDomain%" is not valid.
        echo Please enter a valid domain.
        pause
        goto ORGANISATION_SETUP
    ) else (
        echo Domain setup complete.
    )
) else (
    echo.
    echo Unable to reach the network. Please check your connection.
    pause
    goto ORGANISATION_SETUP
)

echo %OrganisationName%> "%mainfilepath%\org.pkg"
echo %OrganisationDomain%> "%mainfilepath%\domain.pkg"
echo.
echo Organization setup completed.
pause

:ENTERPRISE
cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                                
echo        ______________________________________________________________________________________________________
echo.
echo Would you like to set up Enterprise Configuration? (Y/N)
choice /c YN /n /M "> "
if errorlevel 2 goto CONTINUE_SETUP
if errorlevel 1 goto ENTERPRISE_SETUP

:ENTERPRISE_SETUP
cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                             
echo        ______________________________________________________________________________________________________
echo.
echo         SERVERS:
echo.
echo         SERVER 1
echo         SERVER 4
echo         SERVER 5
echo         SERVER 6
echo         SERVER 7
echo.
echo         Enter your Server number: 
choice /c 14567 /n /M "> "
set "SERVERNUM=%errorlevel%"
echo.
echo         Service Packs:
echo.
echo         [1] SERVICE PACK 1 -- Enterprise Support and Compliance Pack
echo         [2] SERVICE PACK 2 -- Legacy Compatibility Pack
echo         [3] SERVICE PACK 3 -- Cloud and Network Enhancement Pack
echo         [4] SERVICE PACK 4 -- Essential Security and Stability Pack
echo.
echo         Select your Service Pack: 
choice /c 1234 /n /M "> "
set "SERVICEPCK=%errorlevel%"
echo.
echo %SERVICEPCK%> "%mainfilepath%\svc.pkg"
echo %SERVERNUM%> "%mainfilepath%\svr.pkg"
echo.
pause
cls
set "alphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZ"

set "adminCode="
for /l %%i in (1,1,7) do (
    set /a idx=!random! %% 26
    call set "letter=%%alphabet:~!idx!,1%%"
    set "adminCode=!adminCode!!letter!"
)
echo         Admin Username: Admin
echo         Admin Password: !adminCode!
echo         SAVE THIS CODE IN A SAFE SPACE AS IT WILL NOT BE DISPLAYED AGAIN
echo !adminCode!> "%mainfilepath%\adminCDE.pkg"
echo.
echo         Enterprise setup completed.
pause

:CONTINUE_SETUP
cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) - INSTALLATION WIZARD                                (part 4 of 5)
echo        ______________________________________________________________________________________________________
echo.
echo.
echo.
set /p "timezone=Enter your timezone (e.g., EST, PST, MST, CST): "
echo.
:: Save basic user info
echo %username%> "%mainfilepath%\user.pkg"
echo %password%> "%mainfilepath%\pass.pkg"
echo %timezone%> "%mainfilepath%\time.pkg"
pause
cls
echo.
echo        ______________________________________________________________________________________________________
echo.      
echo         FujiOS Installation (v%VERSION2%) INSTALLATION WIZARD                                  (part 5 of 5)
echo        ______________________________________________________________________________________________________
echo.      
echo.
echo        Writing...
echo.
:: (Optional) Retrieve hardware details
for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"

:: Append installation info to log file
(
    echo ====================================================
    echo Installed on %time%   %DATE%
    echo.
    echo Registered To: %FirstName% %LastName%
    echo USERNAME:
    echo %username%
    echo.
    echo TIMEZONE:
    echo %timezone%
    echo.
    echo IP ADDRESS:
    ipconfig | find /i "IPv4"
    echo.
    echo CPU Speed: %CPUSpeed% MHz
    echo Serial Number: %SerialNumber%
    echo Machine: %computer_model%
    echo.
    echo ====================================================
    echo DATA END
    echo ====================================================
) >> Installation.log
timeout /t 5 /nobreak >nul
cls
echo ====================================================
echo            Welcome %username%!
echo ====================================================
pause
:PICKCOLORFORSETUP
cls
echo.
echo Pick what color is best for you.
echo.
echo 1 - Default
echo 2 - Green
echo 3 - Yellow
echo 4 - White
echo 5 - Blue
echo 6 - Gray
echo 7 - Purple
echo.
echo 8 - Finish
choice /c 12345678 /n /M ">"
set "option=%errorlevel%"
if "%option%"=="1" color 07
if "%option%"=="1" set colr=color 07
if "%option%"=="2" color 0A
if "%option%"=="2" set colr=color 0A
if "%option%"=="3" color 06
if "%option%"=="3" set colr=color 06
if "%option%"=="4" color 0F
if "%option%"=="4" set colr=color 0F
if "%option%"=="5" color 09
if "%option%"=="5" set colr=color 09
if "%option%"=="6" color 87
if "%option%"=="6" set colr=color 87
if "%option%"=="7" color 0D
if "%option%"=="7" set colr=color 0D
if "%option%"=="8" goto Breakpoint
echo %colr%>colr.pkg
goto PICKCOLORFORSETUP

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:ADMINSETUPPAGE
if "%password%" equ "%admincode%" (
    set "username=ADMIN"
    set "password=%Valid_password%"
    set "adminstat=1"
) else (
    echo Critical Sys Error
    pause
    EXIT
    EXIT /b
)
goto InputAdmin

:InputAdmin
if "%adminstat%" neq "1" goto login
cls
echo ====================================
echo            MAIN MENU
echo ====================================
echo.
echo 1. Go to Admin Panel
echo 2. Go to File Manager
echo.
set /p choice="Enter your selection (1 or 2): "

if "%choice%"=="1" goto AdminPanel
if "%choice%"=="2" goto File_Manager
goto InputAdmin

:AdminPanel
if "%adminstat%" neq "1" goto login
cls
echo ==================================
echo         Admin Panel
echo ==================================
echo.
echo 01. Enterprise Security
echo 02. Enterprise Settings
echo 03. Enterprise Checklist
echo 04. Reset Password
echo 05. Maintenance Mode
echo 06. Service Manager
echo 07. 
echo 08. 
echo 09. 
echo 10. 
echo ==================================
echo.
set /p "Inpu=> " 
if "%password%" neq "%Valid_password%" goto RELOGIN1432
if %Inpu%==1 goto EntSecurity
if %Inpu%==2 goto EntSettings
if %Inpu%==3 goto EntChecklist
if %Inpu%==4 goto NewPass
if %Inpu%==5 goto MAINTENANCEMODE
if %Inpu%==6 goto SvcManager
if %Inpu%==7 goto 
if %Inpu%==8 goto 
if %Inpu%==9 goto 
if %Inpu%==10 goto 
goto AdminPanel

:EntChecklist
cls
echo ================================
echo    Enterprise Security Check        
echo ================================
echo.
echo Check Data Leaks          - %DataLeaks%
echo Check For Updates         - %UpdatePatches%
echo Check Suspicious Logins   - %AntivirusScan%
echo.
echo 1. Return to Main Menu
echo.
set /p option="> "
if "%option%"=="1" goto AdminPanel
goto EntChecklist

:NewPass
set "password="
set "username="
set /p username="Enter the new username: "
set /p password="Enter the new password: "
echo.
echo Verify Username: [%username%]
echo Verify Password: [%password%]
pause
echo %username%> %mainfilepath%\user.pkg
echo %password%> %mainfilepath%\pass.pkg
goto AdminPanel

:EntSettings
cls
echo =============================
echo          SETTINGS
echo Session: %SESSIONSTARTTIME%
echo =============================
echo.
echo Options
echo 01. Color
echo 02. Change BSOD Type
echo 03. Factory RESET
echo 04. Update
echo 05. System Restore
echo 06. Repair Files
echo 07. Crash Dump Logs
echo 08. Back
echo =============================
echo.
choice /c 12345678 /n /M ">"
set "choice=%errorlevel%"
if "%choice%"=="1" goto Settings101
if "%choice%"=="2" goto BSODTYPESETTING
if "%choice%"=="3" goto FactoryReset132
if "%choice%"=="4" goto UpdateCheck
if "%choice%"=="5" goto sysRestore
if "%choice%"=="6" goto sysRepair
if "%choice%"=="7" goto Crashdumplogds
if "%choice%"=="8" goto File3242
goto File3242

:EntSecurity
cls
set "leakDetected=0"
for %%F in (*.dmp) do (
    echo Processing file: %%F
    timeout /t 3 /nobreak >nul
    echo.

    set "userFound=0"
    set "passFound=0"
    set "admnFound=0"



    findstr /C:"%valid_username%" "%%F" >nul
    if not errorlevel 1 set "userFound=1"


    findstr /C:"%valid_password%" "%%F" >nul
    if not errorlevel 1 set "passFound=1"


    findstr /C:"%admincode%" "%%F" >nul
    if not errorlevel 1 set "admnFound=1"


    if !userFound! equ 1 (
        echo Username detected in data dump in %%F
        set "leakDetected=1"
    )
    if !passFound! equ 1 (
        echo Password detected in data dump in %%F
        set "leakDetected=1"
    )
    if !admnFound! equ 1 (
        echo Admin Password detected in data dump in %%F
        set "leakDetected=1"
        set "eleakDetected=1"
    )
    echo.

)

timeout /t 2 /nobreak >nul
cls
if "%eleakDetected%" == "1" (
    echo.
    echo [33mDANGER Your Account Is At Risk.[0m
    echo.
    echo [31mThe Admin Password Has Been Found In A Data Breach[0m
    echo.
    pause
    goto AdminPanel
)


if "%leakDetected%" == "1" (
    echo.
    echo [33mWARNING Your Info May Have Been Compromised.[0m
    echo.
    echo [31mYour data [Usernames Passwords etc.] may have been exposed[0m
    echo [31mPlease Change Your Password And Username ASAP[0m
    echo.
) else (
    echo.
    echo No data leaks detected. GREAT JOB!
    echo.
)
pause
goto AdminPanel


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:BLACKLIST
set "lastpage=BLACKLISTED ACCOUNT"
echo %lastpage%>> memory.tmp
echo >%mainfilepath%\CoreBootLoader.MARK
echo "@echo off" > boot.cmd
echo del KERNEL32.BAT >> boot.cmd
echo del ReAgent.bat >> boot.cmd
echo del OperatingSystem.old >> boot.cmd
echo del OperatingSystem.backup >> boot.cmd
echo del OperatingSystem.bat >> boot.cmd
del License.txt
echo :start >> boot.cmd
echo cls >> boot.cmd
echo echo FUJIOS COPY HAS BEEN BLACKLISTED >> boot.cmd
echo echo FUJIOS LICENSE HAS BEEN TERMINATED >> boot.cmd
echo PAUSE >> boot.cmd
echo goto start >> boot.cmd
timeout /t 1 /nobreak >nul
start boot.cmd
exit

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:UNSUCSSHTDWN
set "UNSUCSSHTDWN=0"
:: Clear screen and prompt user
cls
echo ==============================================
echo          Unexpected System Shutdown
echo ==============================================
echo Did your system experience a Blue Screen of Death (BSOD) 
echo or a non-BSOD crash?
echo (Example: The OS unexpectedly shut down, froze, or displayed a blue screen.)
echo.

:: Prompt for user choice
choice /c YN /n /M "(Y) Yes  (N) No: "
set "crash=%errorlevel%"

if "%crash%"=="1" (
    echo.
    echo Redirecting to feedback page...
    start FujiTroubleshooter.cmd
    timeout /t 2 >nul
    start https://docs.google.com/forms/d/e/1FAIpQLSdGiNb8u3iiSU6cVAjA9vygOxLAVbwEmaooNMHyM_DZMSxSLQ/viewform
) else (
    cls
    echo ==============================================
    echo       Improper System Shutdown Detected
    echo ==============================================
    echo Your last session did not shut down properly.
    echo Next time, please use the Shutdown menu 
    echo and select 'Shutdown' to prevent data loss.
    echo.
)

pause
goto STARTUPREPAIR


:SysApp
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
set "lastpage=Device Info"
cls
type Installation.log
pause
goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash




:FujiDriveTools
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
set "lastpage=FujiOS Drive Tools"
echo %lastpage%>> memory.tmp
cls
echo =============================
echo      Fuji Drive Tools
echo =============================
echo.
echo 01. Fuji IDE            
echo 02. Fuji Drive           
echo 03. Fuji Bank            
echo 04. Fuji Word Proccessor            
echo 05. Back
echo =============================
echo Items Marked With * Should 
echo be handled with care. If 
echo not handled correctly
echo it could corrupt FujiOS.
set /p choice=User Input: 

if "%choice%"=="1" goto FUJIIDE
if "%choice%"=="2" goto FujiDrive21
if "%choice%"=="3" call Bank.cmd
if "%choice%"=="4" call FujiWrd.cmd
if "%choice%"=="5" goto File_Manager
goto FujiDriveTools

:FujiDrive21
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
set "lastpage=Fuji Drive"
echo %lastpage%>> memory.tmp
cls
set "userFolder=%mainfilepath%"
cls
echo Directory of %userFolder%
echo.
dir /O /B %userFolder%
echo.
echo.
set /p choice=Enter file to read:
cls
echo ----------------------------------------
type %userFolder%\%choice%
echo ----------------------------------------
echo.
pause
goto File_Manager

:FUJIIDE
set "lastpage=FUJIIDE"
echo %lastpage%>> memory.tmp
cls
call call.bat
goto File_Manager
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash




:Antivirus
if "%FirewallStatus%"=="[31mNOT COMPLETED[0m" (
    set "FirewallStatus=[32mCOMPLETED[0m"
)
cls
echo ================================
echo         Security Center       
echo ================================
echo.
echo         Security Check        
echo.
echo Scan Device               - %DataLeaks%
echo Check For Updates         - %UpdatePatches%
echo Check Suspicious Logins   - %AntivirusScan%
echo.
echo ================================
echo.
echo 1. Change Credentials
echo 2. Antivirus Scan
echo 3. Suspicious Logins
echo 4. Test Antivirus
echo 5. Security Updates
echo 6. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto password132
if "%choice%"=="2" goto DATCHECK
if "%choice%"=="3" goto Safw
if "%choice%"=="4" (
    echo. >>%mainfilepath%\AntiVirusSuspTest.cmd
    echo. >>%mainfilepath%\AntiVirusSuspTest.bat
    echo. >>%mainfilepath%\AntiVirusSuspTest.exe
    echo. >>%mainfilepath%\AntiVirusVirusTest.cmd
    echo. >>%mainfilepath%\AntiVirusVirusTest.bat
    echo. >>%mainfilepath%\AntiVirusVirusTest.exe
)
if "%choice%"=="5" goto File_Manager
if "%choice%"=="6" goto File_Manager

goto Antivirus

:Safw
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
goto Safw1

:Safw1
set "lastpage=Susp Logins"
echo %lastpage%>> memory.tmp
if "%AntivirusScan%"=="[31mNOT COMPLETED[0m" (
    set "AntivirusScan=[32mCOMPLETED[0m"
)
%Colr%
cls
echo =============================
echo      Suspicous Logins 
echo =============================
echo If there is nothing here than there are no suspicious logins
echo.
type "%mainfilepath%\login_attempts.log"
echo.
if "%password%" neq "%valid_password%" echo %dat% SUSPICIOUS LOGIN
if "%password%" neq "%valid_password%" echo Password: %valid_password%
if "%password%" neq "%valid_password%" echo Input Password: %password%
echo 1. Yes This Was Me / Clear
echo 2. No This Was Not Me / Change Password
echo 3. Exit
echo =============================
choice /c 1234 /n /M ">"
set "choice=%errorlevel%"

if "%choice%"=="1" goto clear4w52
if "%choice%"=="2" goto password132
if "%choice%"=="3" goto Antivirus
goto Safw1

:clear4w52
set "lastpage=Clear Login Attempts"
echo %lastpage%>> memory.tmp
del %mainfilepath%\login_attempts.log
echo CLEARED
pause
goto Safw1

:password132
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
set "lastpage=Factory Reset"
echo %lastpage%>> memory.tmp
echo =============================
echo ENTER YOUR PASSWORD
set /p password1=Password: 
if "%password1%" NEQ "%valid_password%" goto File3242
set "password="
set "username="
:edit_username
set /p username="Enter the new username: "
if "%username%"=="" (
    echo Username cannot be empty. Please try again.
    goto edit_username
)

if "%username%"==" " (
    echo Username cannot be empty. Please try again.
    goto edit_username
)

:edit_password
set /p password="Enter the new password: "
if "%password%"=="" (
    echo Password cannot be empty. Please try again.
    goto edit_password
)

echo %username%> %mainfilepath%\user.pkg
echo %password%> %mainfilepath%\pass.pkg
:GENERATEAUK2
echo.
echo Generating Universal Access Key . . .
timeout /nobreak /t 5 >nul
set "alphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZ"

set "UAK="
for /l %%i in (1,1,10) do (
    set /a idx=!random! %% 26
    call set "letter=%%alphabet:~!idx!,1%%"
    set "UAK=!UAK!!letter!"
)
echo !UAK!> "%mainfilepath%\UAK.pkg"
if not exist %mainfilepath%\UAK.pkg goto GENERATEAUK2

pause
goto Antivirus



:DATCHECK
set "virusnmbr=0"

if "%DataLeaks%"=="[31mNOT COMPLETED[0m" (
    set "DataLeaks=[32mCOMPLETED[0m"
)
cls
echo Starting Virus Detection . . .
timeout /t 1 /nobreak >nul

set "quarantinepath=%mainfilepath%\quarantine"
if not exist "%quarantinepath%" mkdir "%quarantinepath%"

if exist viruslist.txt (
    set /p filelist=<viruslist.txt
) else (
    set "filelist=virus.exe malware.bat trojan.dll suspicious.docx AntiVirusSuspTest.cmd AntiVirusSuspTest.bat AntiVirusSuspTest.exe"
    set "defaultvrslst=1"
)

if %defaultvrslst% == 1 (
    echo.
    echo [33mCAUTION:[0m Virus List File Not Found. Default Virus List Loaded.
    echo.
)
echo Scanning folder: %mainfilepath% 

echo. 

:: Loop through file list
for %%F in (%filelist%) do (
    echo Checking For %%F.
    if exist "%mainfilepath%\%%F" (
        set /a virusnmbr+=1
        echo [33mALERT:[0m [31mFound Virus - %%F [0m
        move /Y "%mainfilepath%\%%F" "%quarantinepath%\%%F" >nul
        set "quarantinestatus=%errorlevel%"
        if %quarantinestatus% neq 0 echo [33mERROR:[0m [34mVIRUS MAY HAVE NOT BEEN QUARENTINED[0m
    )
)
echo.
echo Scan complete, Found %virusnmbr% Viruses.
Pause
cls
echo Starting Suspicious File Detection . . .
timeout /t 1 /nobreak >nul
echo Scanning folder: %mainfilepath% 
echo. 

:: Scan for suspicious files
for %%F in (%mainfilepath%\*.exe %mainfilepath%\*.bat %mainfilepath%\*.cmd) do (
    echo [33mALERT:[0m [31mSuspicious file detected - %%~nxF[0m
    :: Prompt user for action
    choice /C QI /M "Quarantine (Q) or Ignore (I) %%~nxF?"
    if errorlevel 2 (
        echo Ignored: %%~nxF
    ) else (
        move /Y "%%F" "%quarantinepath%\%%~nxF" >nul
        set "quarantinestatus=%errorlevel%"
        if %quarantinestatus% neq 0 echo [33mERROR:[0m [34mFILE MAY HAVE NOT BEEN QUARENTINED[0m
    )
)
echo.
echo Scan complete.
pause
cls

echo Starting Data Leak Detection . . .
timeout /t 1 /nobreak >nul

set "regvarnumber=Registration Number [32mNOT DETECTED[0m"
set "Uservarname=Username [32mNOT DETECTED[0m"
set "Passvarword=Password [32mNOT DETECTED[0m"
set "UAvarK=Universal Access Key [32mNOT DETECTED[0m"

if "%valid_username%"=="" (
    echo Error: valid_username variable is not set.
    exit /b 1
)
if "%valid_password%"=="" (
    echo Error: valid_password variable is not set.
    exit /b 1
)


set "leakDetected=0"
for %%F in (*.dmp) do (
    echo Analyzing file: %%F
    timeout /t 3 /nobreak >nul
    echo.

    set "userFound=0"
    set "passFound=0"
    set "regnumberFound=0"
    set "UAKFound=0"

    findstr /C:"%valid_username%" "%%F" >nul
    if not errorlevel 1 set "userFound=1"

    findstr /C:"%valid_password%" "%%F" >nul
    if not errorlevel 1 set "passFound=1"

    findstr /C:"%regnumber%" "%%F" >nul
    if not errorlevel 1 set "regnumberFound=1"

    findstr /C:"%UAK%" "%%F" >nul
    if not errorlevel 1 set "UAKFound=1"



    if !regnumberFound! equ 1 (
        echo Registration Number detected in data dump in %%F
        set "regvarnumber=Regnumbr [31mDETECTED[0m"
        set "leakDetected=1"
    )
    if !userFound! equ 1 (
        echo Username Credentials detected in data dump in %%F
        set "Uservarname=Username [31mDETECTED[0m"
        set "leakDetected=1"
    )
    if !passFound! equ 1 (
        echo Password Credentials detected in data dump in %%F
        set "Passvarword=Password [31mDETECTED[0m"
        set "leakDetected=1"
    )
    if !UAKFound! equ 1 (
        echo Universal Access Key detected in data dump in %%F
        set "UAvarK=Universal Access Key [31mDETECTED[0m"
        set "leakDetected=1"
        set "leak2Detected=1"
    )
    echo.


)

if "%password%"=="%UAK%" goto GrantedACC


timeout /t 2 /nobreak >nul
cls
if "%leakDetected%" == "1" (
    echo.
    echo [33mWARNING Your Account May Be At Risk.[0m
    echo.
    echo [33mYour data [Usernames Passwords etc.] may have been exposed[0m
    echo [33mPlease Change Your Password And Username ASAP[0m
    if %leak2Detected% == 1 echo.
    if %leak2Detected% == 1 echo [31mDANGER:[0m [34mUniveral Access Key Has Been Leaked, Secure Account Immediately.[0m
    if %leak2Detected% == 1 echo [34mThe Univeral Access Key Can Give The Attacker Full Access To Your Account.[0m
    echo.
    echo ==============================================
    echo.
    echo %regvarnumber% In Data Leak
    echo %Uservarname% In Data Leak
    echo %Passvarword% In Data Leak
    echo %UAvarK% In Data Leak
    echo.
    echo ==============================================
    echo.
) else (
    echo.
    echo No data leaks detected. GREAT JOB!
    echo.
)
pause
goto Antivirus



:ABORT121
set "lastpage=Abort Shutdown"
echo %lastpage%>> memory.tmp
cls
color 0F
set "password=%valid_password%"
set "username=%valid_username%"
shutdown -a
shutdown -a
shutdown -a
shutdown -a
goto File3242

:Telenet
set "lastpage=Telenet"
echo %lastpage%>> memory.tmp
cls
echo Common Telnet Websites
echo rainmaker.wunderground.com
echo telehack.com
echo towel.blinkenlights.nl 23
echo eclipse.cs.pdx.edu 7680 
set /p Site=Enter Telesite: 
cls
telnet %Site%
goto File_Manager



:FINISHUPDATING
set "lastpage=Finish Updates"
echo %lastpage%>> memory.tmp
echo Finishing Updates . . .
timeout /t 3 /nobreak >nul
if not exist UpAgent.bat (
set "bsodcode=UPAGENT_BOOT_INITIALIZATION_FAILED"
goto Crash
)
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
echo [33mUPDATING FIRMWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
del UpAgent.bat
ren UpAgent.cmd UpAgent.bat
timeout /t 5 /nobreak >nul
goto Breakpoint12321


:EOCF
set "bsodcode=END_OF_CODE"
goto Crash

:Breakpoint
cls
set "lastpage=SHUTDOWN1"
echo %lastpage%>> memory.tmp
echo SHUTTING DOWN...
timeout /t 5 /nobreak >nul
set "crash=0"
del memory.tmp
if exist memory.tmp del memory.tmp

if %hibernate% neq 1 del HIBERNATE.log
cls
color 06
echo %OS2% v%VERSION2% 
echo IS READY TO BE SHUT DOWN.
ECHO YOU MAY CLOSE THIS WINDOW
set "crash=0"
timeout /t 9999 /nobreak >nul
set "crash=0"
goto Breakpoint

:Breakpoint12321
set "lastpage=SHUTDOWN2"
echo %lastpage%>> memory.tmp
del memory.tmp
del memory.tmp
del memory.tmp
set "crash=0"

exit /b

:Breakpoint123
set "lastpage=SHUTDOWN3"
echo %lastpage%>> memory.tmp
del memory.tmp
del memory.tmp
del memory.tmp
set "crash=0"
set "RSTCMD=1"
exit /b 




