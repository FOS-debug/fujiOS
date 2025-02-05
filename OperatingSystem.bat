::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::NO COMMANDS BEFORE PREBOOTUPFUJIOS ALLOWED
@echo off
setlocal enabledelayedexpansion
:PREBootupFujios
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"

if not exist PRIVATEKEY.ini (
    set "bsodcode=PRIVATE_KEY_VERIF_FAIL"
    goto Crash
)

if exist PRIVATEKEY.ini (
   set /p privatekey2=<PRIVATEKEY.ini
   del PRIVATEKEY.ini
)
if %privatekey2% neq %PRIVATEKEY% (
    set "bsodcode=PRIVATE_KEY_VERIF_FAIL"
    goto Crash
)


if exist "memory.tmp" (
    set "UNSUCSSHTDWN=1" 
) else (
    set "UNSUCSSHTDWN=0" 
)
set "attempts=0"



:FULLBootupFujios
set "lastpage=Full Bootup Fujios"
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"

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
set "crshdmplocn=%mainfilepath%\CrashLogs"

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
   set "organisationstatus=0"
) else (
   set /p organisation=<%mainfilepath%\org.pkg
   set /p domain=<%mainfilepath%\domain.pkg
   set "organisationstatus=1"
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

echo [92m[+][0m [97mWPT Test Success[0m
del %LOCAL_BLACKLIST_FILE%

:BootupFujios
:Ostart3
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
echo.
echo.
echo.
timeout /t 5 /nobreak >nul
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



if "%username%" neq "%valid_username%" goto login
if "%password%"=="%valid_password%" goto GrantedACC

goto checkattempts
:checkattempts
echo.
echo.
echo [91m[-][0m [97mCredentials Incorrect[0m
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
echo [92m[+][0m [97mCredentials Correct[0m
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
if "%username%" equ "$GUEST" set "username=%input_domain%"
if "%username%" equ "$GUEST" set "password=%Valid_password%"
if "%username%" equ "$GUEST" goto File3242
if "%password%"=="%targetNumber%" goto File3242
if "%password%" neq "%Valid_password%" shutdown -s -t 45
if exist "%documentsPath%\login_attempts.log" goto WARNINGL2

goto File3242

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:m2
set "bsodcode=SECURITY_SYSTEM"
timeout /t 1 /NOBREAK >nul
cls
if not exist "%crshdmplocn%" mkdir "%crshdmplocn%"

set report=%random%crsh%random%.log
set crshdmpfile=%crshdmplocn%\%report%
goto M2345
:M2345
goto crash


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

if %update%==1 (
echo.
echo [34m FujiOS v%REMOTE_VERSION% Is available [97m
echo.
)
if "%VERSION2%" NEQ "DEVELOPEMENT" (
    if %behindb% geq 5 echo [31m Please Update ASAP! [97m
    if %behindb% geq 9 echo [31m FujiOS Will Automatically Update Soon [97m
)
echo ==================================
echo         FUJIOS v%VERSION2%
echo ==================================
echo.
echo 01. Browser
echo 02. Clock
echo 03. Account Info
echo 04. Suspicious Logins
echo 05. AntiVirus
echo 06. Game Station-S
echo 07. Fuji Drive Tools
if %update% neq 0 (
    echo [34m08. Settings[97m
) else (
    echo 08. Settings
)
echo 09. Shutdown Menu
if "%OS2%"=="FujiOS Developer Build" (
    echo 10. Developer Tools*
) else (
    echo 10. EMPTY
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
if %Inpu%==4 goto Safw
if %Inpu%==5 goto Antivirus
if %Inpu%==6 call GamesSys32.bat
if %Inpu%==7 goto FujiDriveTools
if %Inpu%==8 goto FUJISETTINGS

if %Inpu%==9 goto SHUTDOWNMENU121
if %Inpu%==10 goto devtools

goto File3242




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
echo 03. Change Credentials
echo 04. Factory RESET
if %update% neq 0 (
    echo [34m05. Update[97m
) else (
    echo 05. Update
)
echo 06. System Restore
echo 07. Repair Files
echo 08. Crash Dump Logs
echo 09. Back
echo =============================
echo.
choice /c 123456789 /n /M ">"
set "choice=%errorlevel%"
if "%choice%"=="1" goto Settings101
if "%choice%"=="2" goto BSODTYPESETTING
if "%choice%"=="3" goto password132
if "%choice%"=="4" goto FactoryReset132
if "%choice%"=="5" goto UpdateCheck
if "%choice%"=="6" goto sysRestore
if "%choice%"=="7" goto sysRepair
if "%choice%"=="8" goto Crashdumplogds
if "%choice%"=="9" goto File3242

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
echo 1 - Green
echo 2 - Yellow
echo 3 - White
echo 4 - Blue
echo 5 - Gray
echo 6 - Purple
echo.
echo 7 - Finish
choice /c 1234567 /n /M ">"
set "option=%errorlevel%"

if "%option%"=="1" color 0A
if "%option%"=="1" set colr=color 0A
if "%option%"=="2" color 06
if "%option%"=="2" set colr=color 06
if "%option%"=="3" color 0F
if "%option%"=="3" set colr=color 0F
if "%option%"=="4" color 09
if "%option%"=="4" set colr=color 09
if "%option%"=="5" color 87
if "%option%"=="5" set colr=color 87
if "%option%"=="6" color 0D
if "%option%"=="6" set colr=color 0D
if "%option%"=="7" goto File_Manager
echo %colr% >colr.pkg
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
if "%bsodcode%"=="PAGE_FAULT_IN_NONPAGED_AREA" set "stopcode=0x0001000"
if "%bsodcode%"=="UNKNOWN_CRASH_EXCEPTION" set "stopcode=0x0002000"
if "%bsodcode%"=="BOOT_ERROR" set "stopcode=0x0003000"
if "%bsodcode%"=="POST_ERROR" set "stopcode=0x0004000"
if "%bsodcode%"=="FUJI_CORRUPT_ERR" set "stopcode=0x000xxx000"
if "%bsodcode%"=="PAGE_FAULT_IN_PAGED_AREA" set "stopcode=0x0006000"
if "%bsodcode%"=="SECURITY_SYSTEM" set "stopcode=0x0007000"
if "%bsodcode%"=="CLOSED_PAGE_ERROR" set "stopcode=0x0008000"
if "%bsodcode%"=="END_OF_CODE" set "stopcode=0x000EOF000"
if "%bsodcode%"=="MAX_ERROR_LEVEL_REACHED" set "stopcode=0x0009000"
if "%bsodcode%"=="DISK_WRITE_TEST_FAIL" set "stopcode=0x000DSK000"
if "%bsodcode%"=="KERNEL_MODE_EXCEPTION_NOT_HANDLED" set "stopcode=0x000KERR000"
if "%bsodcode%"=="VARIABLES_NOT_SET" set "stopcode=0x000NVER000"
if "%bsodcode%"=="NETWORK_BOOT_INITIALIZATION_FAILED" set "stopcode=0x000NTWRK000"
if "%bsodcode%"=="TOO_MANY_BOOT_ATTEMPTS" set "stopcode=0x000RSTRT000"
if "%stopcode%" == "" set "stopcode=0x0002000"
title %bsodcode%
cls
if "%bsodtype%"=="1" goto BSODIMAGE
if "%bsodtype%"=="2" goto BSODLNUX
goto BSODIMAGE


:BSODLNUX
echo [91m[-][0m [97m%OS2% %VERSION2% PANIC!!![0m
echo [91m[-][0m [97m%OS2% %VERSION2% Has Ran Into A Critical Error[0m
echo.
echo [91m[-][0m [97m%OS2% %VERSION2% Crash Code: %bsodcode%[0m
echo [91m[-][0m [97m%OS2% %VERSION2% Stop Code: %STOPCODE%[0m
echo [91m[-][0m [97m%OS2% %VERSION2% Last Page: %lastpage%[0m


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
pause

goto LogCrash

:LogCrash
pause
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
goto FULLBootupFujios



:bcodeud
set "lastpage=Unknown Crash"
echo %lastpage%>> memory.tmp
set bsodcode=UNKNOWN_CRASH_EXCEPTION
goto crash


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
start fds.bat
timeout /t 3 /nobreak >nul
start 6Bit.bat
timeout /t 15 /nobreak >nul
goto BootupFujios


:systemsetup
set "lastpage=Setup Screen"
echo %lastpage%>> memory.tmp
color 0F
cls
echo Welcome To FujiOS
pause
echo Enter the username you would like to use.
set /p username=Username: 
echo Enter the password you would like to use.
set /p password=Password: 
echo Enter Your First Name
set /p FirstName=First Name: 
echo Enter Your Last Name
set /p LastName=Last Name: 
echo Would you like to set up an organisation?
echo (Y/N)
choice /c yn /n /M "> "
set "choice=%errorlevel%"
if "%choice%"=="1" goto ORGANISATIONSET
if "%choice%"=="2" goto CONTINTUEIG

:ORGANISATIONSET
cls
echo Enter your Organisation Name:
set /p OrganisationName=Organisation Name: 
echo Enter your Organisation Domain (e.g., example.com):
set /p OrganisationDomain=Organisation Domain: 

:CHECKDOMAIN
ping -n 1 %OrganisationDomain% >nul 2>&1
if %errorlevel% neq 0 (
    set "online=0"
) else (
    set "online=1"
)

ping www.google.com /n 1 >nul
if %errorlevel% neq 0 (
    set "online1=0"
) else (
    set "online1=1"
)


if %online1%==1 (
    if "%online%"=="0" (
    echo The domain %OrganisationDomain% is not a valid domain.
    echo Please enter a valid domain.
    pause
    goto ORGANISATIONSET
    ) else (
    echo Domain Setup Complete
    )
) ELSE (
    if %online1%==0 echo Unable To Reach Domain, Please Check Network
    pause
    goto ORGANISATIONSET
)
echo %OrganisationName%> %mainfilepath%\org.pkg
echo %OrganisationDomain%> %mainfilepath%\domain.pkg

echo Organisation setup completed.
pause
goto CONTINTUEIG

:CONTINTUEIG
set /p timezone="Enter your timezone (e.g., EST, PST, MST, CST): "
echo %Date% %time%
echo %username%> %mainfilepath%\user.pkg
echo %password%> %mainfilepath%\pass.pkg
echo %timezone%> %mainfilepath%\time.pkg
pause
cls
echo We Are Setting Up Your Account
goto Setup142

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Setup142
set "lastpage=Setup142"
for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
echo %username%> %mainfilepath%\user.pkg    
echo %password%> %mainfilepath%\pass.pkg
echo %timezone%> %mainfilepath%\time.pkg
echo ================================================ > Installation.log
echo Installed on %time%   %DATE% >> Installation.log
echo. >> Installation.log
echo Registered To: %FirstName% %LastName% >> Installation.log
echo USERNAME: >> Installation.log
echo %username% >> Installation.log
echo. >> Installation.log
echo TIMEZONE: >> Installation.log
echo %timezone% >> Installation.log
echo. >> Installation.log
echo IP ADDRESS: >> Installation.log
ipconfig | find /i "IPv4">> Installation.log
echo. >> Installation.log
echo CPU Speed: %CPUSpeed% MHz >> Installation.log
echo Serial Number: %SerialNumber% >> Installation.log
echo Machine: %computer_model% >> Installation.log
echo. >> Installation.log
echo ================================================ >> Installation.log
echo DATA END >> Installation.log
echo ================================================ >> Installation.log
setlocal enabledelayedexpansion

echo We Are Setting Up Your Account...

set "dots="
for /l %%i in (1,1,20) do (
    set "dots=!dots!."
    cls
    echo We Are Setting Up Your Account!dots!
    timeout /nobreak /t 1 >nul
)
endlocal
cls
echo Welcome %username%
pause
cls
goto Breakpoint

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

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:BLACKLIST
set "lastpage=BLACKLISTED ACCOUNT"
echo %lastpage%>> memory.tmp
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
exit /b

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
echo Did you experience a non-BSOD related crash? 
echo (Example: OS stopped and closed unexpectedly)
echo.

:: Prompt for user choice
choice /c YN /n /M "(Y) Yes  (N) No: "
set "crash=%errorlevel%"

if "%crash%"=="1" (
    echo.
    echo Redirecting to feedback page...
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


:Safw
if "%Guest%" equ "1" echo NOT AVAILABLE AS GUEST
if "%Guest%" equ "1" pause
if "%Guest%" equ "1" goto File_Manager
goto Safw1

:Safw1
set "lastpage=Susp Logins"
echo %lastpage%>> memory.tmp
%Colr%
cls
echo =============================
echo      Suspicous Logins 
echo =============================
echo If there is nothing here than there are no suspicious logins
echo.
type "%mainfilepath%\login_attempts.log"
if "%password%" neq "%valid_password%" echo %dat% SUSPICIOUS LOGIN
if "%password%" neq "%valid_password%" echo Password: %valid_password%
if "%password%" neq "%valid_password%" echo Input Password: %password%
echo 1. Yes This Was Me
echo 2. No This Was Not Me
echo 3. Clear
echo 4. Exit
echo =============================
choice /c 1234 /n /M ">"
set "choice=%errorlevel%"

if "%choice%"=="1" goto ABORT121
if "%choice%"=="2" goto password132
if "%choice%"=="3" goto clear4w52
if "%choice%"=="4" goto File_Manager
goto Safw1
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

:clear4w52
set "lastpage=Clear Login Attempts"
echo %lastpage%>> memory.tmp
del %mainfilepath%\login_attempts.log
echo CLEARED
pause
goto Safw1
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

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

pause
goto file3242

:Antivirus
set "lastpage=Antivirus"
echo %lastpage%>> memory.tmp
cls
call Antivirus.bat

goto File_Manager

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

del memory.tmp
if exist memory.tmp del memory.tmp

if %hibernate% neq 1 del HIBERNATE.log
cls
color 06
echo %OS2% v%VERSION2% 
echo IS READY TO BE SHUT DOWN.
ECHO YOU MAY CLOSE THIS WINDOW
timeout /t 9999 /nobreak >nul
goto Breakpoint

:Breakpoint12321
set "lastpage=SHUTDOWN2"
echo %lastpage%>> memory.tmp
del memory.tmp
del memory.tmp
del memory.tmp

exit /b

:Breakpoint123
set "lastpage=SHUTDOWN3"
echo %lastpage%>> memory.tmp
del memory.tmp
del memory.tmp
del memory.tmp

