::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::NO COMMANDS BEFORE PREBOOTUPFUJIOS ALLOWED
@echo off
:PREBootupFujios
if exist UpAgent.cmd goto FINISHUPDATING
set "hibernate=0"
set "RESTARTATTEMPTS=0"
set "ErrorL2=0"
set "UNSUCSSHTDWN=0"
set "SESSIONSTARTTIME=%date%   %TIME%"
set "DefaultDomain=ptie.org"
set "DefaultOrg=PTI ENTERPRISE"
set startuprepair=false
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"
if not exist %mainfilepath% mkdir %mainfilepath%

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


if not exist %mainfilepath%\domain.pkg (
   set "domain=%DefaultDomain%"
   set "organisation=%DefaultOrg%"
   set "organisationstatus=0"
) else (
   set /p organisation=<%mainfilepath%\org.pkg
   set /p domain=<%mainfilepath%\domain.pkg
   set "organisationstatus=1"
)
if exist memory.tmp set "UNSUCSSHTDWN=1"

:BootupFujios
set "lastpage=BootupFujios"

set "ERRORLEVEL="
color 07
cls
set "bsodcode="
set "InfoAdd="
if "%debug1453%" NEQ "1" set "debug1453=0"

if "%debug1453%"=="1" @echo on
set "ErrorL=0"
	
set "lastpage=DiskWriteTest"
echo Performing write-protection test...
echo %random% >>wtest.tmp
ping localhost -n 2 >nul

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
    set "InfoAdd=Error Level NEQ 0"
    goto Crash
)

if not exist wtest.tmp (
    set "bsodcode=DISK_WRITE_TEST_FAIL"
    set "InfoAdd=Either the disk is full, or it is write-protected."
    goto Crash
)

timeout /t 1 /nobreak >nul
goto wptsuccess
:wptsuccess
del wtest.tmp


echo [92m[+][0m [97mWPT Test Success[0m
goto FILESCHECK123
:FILESCHECK123
set "lastpage=Kernel32"
set "errors=0"



if exist KERNEL32.bat (
	echo [92m[+][0m [97mKERNEL32 OK[0m
) else (
        set "F1=KERNEL32.bat "
        set /a "errors+=1"
        echo [91m[-][0m [97mKERNEL32.bat May Be Missing[0m

)
if exist GamesSys32.bat (
	echo [92m[+][0m [97mGamesSys32 OK[0m
) else (
        set "F2=GameSys32.bat "
        set /a "errors+=1"
        echo [91m[-][0m [97mGamesSys32.bat May Be Missing[0m
)
if exist FujiWrd.cmd (
	echo [92m[+][0m [97mFujiWrd OK[0m
) else (
        set "F3=FujiWrd.cmd "
        set /a "errors+=1"
        echo [91m[-][0m [97mFujiWrd.cmd May Be Missing[0m
)
if exist 6Bit.bat (
	echo [92m[+][0m [97m6Bit OK[0m
        
) else (
        set "F4=6Bit.bat "
        set /a "errors+=1"
        echo [91m[-][0m [97m6Bit.bat May Be Missing[0m
)
if exist 8bit.bat (
	echo [92m[+][0m [97m8bit OK[0m
) else (
        set "F5=8bit.bat "
        set /a "errors+=1"
        echo [91m[-][0m [97m8bit.bat May Be Missing[0m
)
if exist Antivirus.bat (
	echo [92m[+][0m [97mAntivirus OK[0m
) else (
        set "F6=Antivirus.bat "
        set /a "errors+=1"
        echo [91m[-][0m [97mAntivirus.bat May Be Missing[0m
)
if exist cdbit.bat (
	echo [92m[+][0m [97mcdbit OK[0m
) else (
        set "F7=cdbit.bat "
        set /a "errors+=1"
        echo [91m[-][0m [97mcdbit.bat May Be Missing[0m
)
if exist Webtools.cmd (
	echo [92m[+][0m [97mWebtools OK[0m
) else (
        set "F8=Webtools.cmd "
        set /a "errors+=1"
        echo [91m[-][0m [97mWebtools.cmd May Be Missing[0m
)
if exist settings2.ini (
	echo [92m[+][0m [97msettings2 OK[0m
) else (
        set "F9=settings2.ini "
        set /a "errors+=1"
        echo [91m[-][0m [97msettings2.ini May Be Missing[0m
)
if exist settings.ini (
	echo [92m[+][0m [97msettings OK[0m
) else (
        set "F10=settings.ini "
        set /a "errors+=1"
        echo [91m[-][0m [97m settings.ini May Be Missing[0m
)
timeout /t 3 /nobreak >nul
if %errors% neq 0 (
        set "InfoAdd=%F1%%F2%%F2%%F3%%F4%%F5%%F6%%F7%%F8%%F9%%F10%"
        set "bsodcode=BOOT_INITIALIZATION_FAILED"
        goto Crash
)

goto SecurityCheck

:SecurityCheck
goto KernalCheck
:KernalCheck
set "lastpage=Kernel Error Check"

for /f %%i in ('type "settings.ini"') do set "targetNumber=%%i"
echo %targetNumber% %targetNumber% %targetNumber%
if "%targetNumber%"  equ "111" goto Aftercheckerrors
if "%targetNumber%"  equ "000" goto Aftercheckerrors
if "%targetNumber%"  equ "101" goto Aftercheckerrors
if "%targetNumber%"  equ "010" goto Aftercheckerrors
if "%targetNumber%"  equ "001" goto Aftercheckerrors
if "%targetNumber%"  equ "100" goto Aftercheckerrors
if "%targetNumber%"  equ "110" goto Aftercheckerrors
if "%targetNumber%"  equ "011" goto Aftercheckerrors
set "bsodcode=KERNEL_MODE_EXCEPTION_NOT_HANDLED"
goto Crash
goto Crash
goto Crash

:Aftercheckerrors
for /f %%i in ('type "settings2.ini"') do set "targetNumber=%%i"
if exist "HIBERNATE.log" goto DEHIBERNATE
echo %targetNumber% %targetNumber% %targetNumber%
if "%targetNumber%"  equ "001" goto ContinueErrorcheck
if "%targetNumber%"  equ "111" goto ContinueErrorcheck
if "%targetNumber%"  equ "000" goto ContinueErrorcheck
if "%targetNumber%"  equ "101" goto ContinueErrorcheck
if "%targetNumber%"  equ "010" goto ContinueErrorcheck
set "bsodcode=KERNEL_MODE_EXCEPTION_NOT_HANDLED"
goto Crash
goto Crash
goto Crash
:ContinueErrorcheck
set "lastpage=Variable Error Check"

if "%ErrorL%"=="" (
    set "bsodcode=VARIABLES_NOT_SET1"
    goto Crash
)
if "%varchck%" neq "VariablesPassed" (
    set "bsodcode=VARIABLES_NOT_SET2"
    goto Crash
)
if "%MaxErr%"=="" (
    set "bsodcode=VARIABLES_NOT_SET3"
    goto Crash
)
if "%userFolder%"=="" (
    set "bsodcode=VARIABLES_NOT_SET4"
    goto Crash
)
if "%docFolder%"=="" (
    set "bsodcode=VARIABLES_NOT_SET5"
    goto Crash
)
if "%playerScore%"=="" (
    set "bsodcode=VARIABLES_NOT_SET6"
    goto Crash
)
if "%computerScore%"=="" (
    set "bsodcode=VARIABLES_NOT_SET7"
    goto Crash
)
if "%valid_username%"=="" (
    set "bsodcode=VARIABLES_NOT_SET8"
    echo ERROR USER NOT SET
    pause
)
if "%valid_password%"=="" (
    set "bsodcode=VARIABLES_NOT_SET9"
    echo ERROR PASSWRD NOT SET
    pause
)

goto continueFujiBOOTUP
:continueFujiBOOTUP
echo [92m[+][0m [97mKernal Check Pass[0m
echo [92m[+][0m [97mVariables Check Pass[0m

cls
set "documentsFolder="
if exist "%mainfilepath%\BOOTSEC2" goto M2

:RSTAH
if exist "%mainfilepath%\FACTORYRESETNXT.log" (
    goto FactoryReset1334
)
if "%Errl%"  equ "1" goto Exit101
if "%Err2l%" neq "1" goto Error12871

:E121
for /f %%i in ('type "%mainfilepath%\kencr"') do set "targetNumber=%%i"
set "Retry=0"
set "attempts=0"
echo. >> "%AppDataFolder%\Bootlog.log" Boot time %DATE% %TIME% Authentication: %SERTB% 
set "AuthCode=1011"
goto AuthCode
:Ostart2

set "AuthCode=0000"
set "documentsFolder=%mainfilepath%"
if exist "%documentsFolder%\WindowsBootLog.dll" (
    goto ERR16
) else (
    goto Ostart3
)

:Ostart3
if exist "%documentsFolder%\BOOTSEC2" (
    goto Exit101
) else (
    goto OSSST
)



:OSSST

set "ErrorL=0"
set "MaxErr=2"
shutdown -a
if exist "%documentsFolder%\BURGER.dll" (
    set "Colr=Color 07"
    set /a "ErrorL2+=1"
) else (
    goto OSST
)


:OSST
set "lastpage=FujiOS Main Bootup"

set "4=4"
if exist "%mainfilepath%\FACTORYRESETNXT.log" (
    goto FactoryReset1334
)
color 0F
call Systart.bat
set "MaxErr=2"
set /a "RESTARTATTEMPTS+=1"
cls
title %OS2% v%VERSION2%
%colr%
timeout /t 1 /NOBREAK >nul
if "%Root%"=="true" goto PSST
cls
echo.
echo.
echo.
echo ********   *******    ********     101 101 101
echo /**/////   **/////**  **//////     001 001 001
echo /**       **     //**/**           001       001
echo /******* /**      /**/*********    00100100100100100%RESTARTATTEMPTS%
echo /**////  /**      /**////////**    00100100
echo /**      //**     **        /**    00100100
echo /**       //*******   ********     00100100
echo //         ///////   ////////      00100100
echo.
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
ping localhost -n 3 >nul
if %RESTARTATTEMPTS% GTR 6 goto ERR16
if %RESTARTATTEMPTS% GTR 5 goto ERR17
if %RESTARTATTEMPTS% GTR 4 goto STARTUPREPAIR
if %UNSUCSSHTDWN%==1 goto UNSUCSSHTDWN
if exist "%documentsFolder%\WindowsBootLog.dll" goto ERR16
if exist "%mainfilepath%\BOOTSEC2" goto M2
goto PSST


:PSST
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


:: Compare versions (only works with simple numbers)
:: If versions are like "1.10" vs "1.9", this method fails. PowerShell is needed for that case.
if %REMOTE_VERSION% GTR %VERSION2% (
    echo Update Available.

) else (
    echo You are up to date!
)

if %REMOTE_VERSION% GTR %VERSION2% (
    set UPDATE=1

) else (
    set UPDATE=0
)
if %REMOTE_VERSION% == HOTFIX (
    set UPDATE=2
) 
timeout /t 5 /nobreak >nul
:skipupdate
cls
echo.
echo.
echo =
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo =
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ==
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ===
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ===
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ====
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ====
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo =====
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo =====
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ======
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ======
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ========
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ========
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ===========
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ===========
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo =============
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo =============
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ===============
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ===============
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ==================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ====================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ====================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ======================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ======================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ========================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ========================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.

cls
echo.
echo.
echo ==========================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==========================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
cls
echo.
echo.
echo ============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo.
echo.
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
echo.
echo.
cls
echo.
echo.
echo ===============================
echo ********   *******    ******** 
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
echo     Copyright 2022-2025
echo.
echo.
echo.
if not exist icd.ini goto PSST
set "behindb=%REMOTE_VERSION%"
set /a behindb-=%VERSION2%
if %behindb% geq 10 call :updateq

if "%REMOTE_VERSION%" neq "%VERSION2%" (
    if "%UPDATE%"=="2" goto Updateing
)

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
(
  echo %timezone%
  echo %valid_username%
  echo %mainfilepath%
  echo %docFolder%
  echo %bsodtype%
  echo %varchck%
  echo %colr%
  echo %valid_password%
  echo %MaxErr%
) > memory.tmp
echo  Please Wait 5 Seconds
CHOICE /C MC /t 5 /d C >nul
if "%ERRORLEVEL%"=="1" goto M1
if exist "%%mainfilepath%\FACTORYRESETNXT.log" (
    goto FactoryReset1334
)

goto start1

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:start1232
goto loginorregister




:start1

if exist "%documentsFolder%\BOOTSEC.sys" (
    goto start
) else (
    goto 1r2
)

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:start
if %ErrorL% geq %MaxxErr% goto ERR15
goto loginorregister

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:loginorregister
set "lastpage=loginorregister"
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

:GIRT
%colr%
cls
echo Welcome to the Internet!
echo You are now on the Start page.
echo.
echo INTRODUCING FUJI DRIVE!
echo Fuji Drive Is A New
echo Feature where you
echo can save your files
echo and even if fujiOS
echo is deleted, your files
echo get saved Because they
echo are saved locally!
echo.
pause
goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:login
set "lastpage=login"
%colr%
cls
set "SL=0"
cls

set "CAPCHA=%RANDOM%"
set "theusername=Default"
set "thepassword=123456A"
cls
rem Prompt the user to enter username and password
if exist "%mainfilepath%\stolen_report.txt" goto M2
echo Attempt %attempts% out of 10
echo.
echo SECURElite Login System
echo Copyright 1989-2025
echo Current domain: %domain%
echo For Guest Account Use $GUEST for Domain
if "%OS2%"=="FujiOS Developer Build" echo Username: [%Valid_Username%]
if "%OS2%"=="FujiOS Developer Build" echo Password: [%Valid_password%]
if "%OS2%"=="FujiOS Developer Build" echo Backup Password: [%targetNumber%]
echo.
set /p "input_domain=Enter domain: "
set /p "username=Enter username: "
set /p "password=Enter password: "


if "%input_domain%" equ "$GUEST" (
    echo LOGGING IN AS GUEST
    pause
    goto File_Manager
)


if "%input_domain%" neq "%domain%" (
    echo Invalid domain name "%input_domain%"
    pause
    goto Start
)




if "%username%" neq "%valid_username%" goto login
if "%password%"=="%valid_password%" goto GrantedACC
if "%password%"=="%targetNumber%" goto GrantedACC
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
    echo DISABLED for 10 seconds.
    ping localhost -n 10 >nul
    set /p valid_username=<%mainfilepath%\user.pkg
    set /p valid_password=<%mainfilepath%\pass.pkg
    goto login
)

set "dat=%DATE%--%TIME%"
%password%

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




:Wecl
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

:File_Manager

set "lastpage=File_Manager"
set "RLSN=0"
if "%input_domain%" equ "$GUEST" set "username=%input_domain%"
if "%input_domain%" equ "$GUEST" set "password=%Valid_password%"
if "%input_domain%" equ "$GUEST" goto File3242
if "%password%"=="%targetNumber%" goto File3242
if "%password%" neq "%Valid_password%" shutdown -s -t 45
if exist "%documentsPath%\login_attempts.log" goto WARNINGL2

goto File3242

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:File3242


set "lastpage=File3242"

if %RLSN% GEQ 10 set "bsodcode=MAX_ERROR_LEVEL_REACHED"

if %RLSN% GEQ 10 goto Crash

set /a "RLSN+=1"

set "Employee=12342"
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
if %behindb% geq 5 echo [31m Please Update ASAP! [97m
if %behindb% geq 9 echo [31m FujiOS Will Automatically Update Soon [97m
echo ==================================
echo         FUJIOS v%VERSION2%
echo ==================================
echo.
echo 01. Browser
echo 02. Clock
echo 03. System Tools*
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

:FUJISETTINGS
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
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
echo 07. Back
echo =============================
echo.
choice /c 1234567 /n /M ">"
set "choice=%errorlevel%"
if "%choice%"=="1" goto Settings101
if "%choice%"=="2" goto BSODTYPESETTING
if "%choice%"=="3" goto password132
if "%choice%"=="4" goto FactoryReset132
if "%choice%"=="5" goto UpdateCheck
if "%choice%"=="6" goto sysRestore

if "%choice%"=="7" goto File3242
goto FUJISETTINGS

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:sysRestore
if not exist ReAgent.bat (
set "bsodcode=REAGENT_BOOT_INITIALIZATION_FAILED"
goto Crash
)
echo systemrstore.log > systemrstore.log
start ReAgent.bat
exit /b


:UpdateCheck
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
if %REMOTE_VERSION% equ %VERSION2% (
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
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo.
echo ===============================
start UpAgent.bat 
timeout /t 5 /nobreak >nul
goto Breakpoint12321


:Deviceinfo1
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
set "lastpage=Deviceinfo1"
cls
type Installation.log
pause
goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:FujiDrive21
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
set "lastpage=FujiDrive21"
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


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash



:SHUTDOWNMENU121
set "lastpage=SHUTDOWNMENU121"
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
if %ERRORLEVEL%==2 goto BootupFujios
if %ERRORLEVEL%==3 goto HIBERNATE
if %ERRORLEVEL%==4 goto Breakpoint
if %ERRORLEVEL%==5 goto Breakpoint123
if %ERRORLEVEL%==6 goto File3242

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:HIBERNATE
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
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

:FactoryReset132
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
set "lastpage=FactoryReset132"
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

:CHOICEtest2
if "%choice%"=="16" goto DeveloperTools724
goto File_Manager

:FactoryReset1334
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" exit /b
set "lastpage=FactoryReset132"
echo =============================
echo ENTER YOUR PASSWORD
set /p password=Password: 
if "%password%" NEQ "%valid_password%" exit /b

if not exist ReAgent.bat (
set "bsodcode=REAGENT_BOOT_INITIALIZATION_FAILED"
goto Crash

)
echo factoryrset.log > factoryrset.log
start ReAgent.bat
exit /b

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash



:WARNINGL2
set "lastpage=WARNINGL2"
cls
echo WARNING! Suspicious Login Attempts. Check "Suspicious Logins"
echo Your account may be at risk
echo.
echo.
pause
goto File3242

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash





:RELOGIN1432
set "lastpage=RELOGIN1432"
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

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:FUJIIDE
set "lastpage=FUJIIDE"
cls
call call.bat
goto File_Manager
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash
:Mail
set "lastpage=Mail"
ping google.com -n 2 | find "TTL=" 

if errorlevel 1 (
    echo Not Connected To The Internet
    timeout /nobreak /t 8 >nul
    goto File_Manager
) else (
    echo Loading...
    timeout /nobreak /t 3 >nul
    goto Mail1
)

:Mail1
%Colr%
cls
echo Mail
echo -----------------------
set /p to=Enter recipient's email address: 
set /p subject=Enter email subject: 
set /p body=Enter email body: 

echo -----------------------
echo To: %to%
echo Subject: %subject%
echo Body: %body%
echo -----------------------

echo Press Space To Continue
pause >nul
goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:Crash
set "RLSN=0"
for /f "tokens=2 delims==" %%I in ('wmic os get TotalVisibleMemorySize /value') do set "TotalMemory=%%I"
for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
set "crshdmplocn=%mainfilepath%\CrashLogs"
REM Ensure the USERdocuments folder exists
if not exist "%crshdmplocn%" mkdir "%crshdmplocn%"
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

goto LogCrash


:BSODIMAGE
if exist "%mainfilepath%\UNLOCK.txt" set "attempts=0"
if exist "%mainfilepath%\UNLOCK.txt" goto m1
color 4f
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
goto LogCrash


:LogCrash
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
goto BootupFujios

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:ERRexit
set "documentsPath=%mainfilepath%"
echo. > "%documentsPath%\WindowsBootLog.dll"
exit /b

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:bcodeud
set bsodcode=UNKNOWN_CRASH_EXCEPTION
goto crash


:ERR12
set "bsodcode=BOOT_ERROR"
set "%InfoAdd%=Boot Attempt Fail"
goto Crash

:ERR13
set "bsodcode=POST_ERROR"
goto Crash


:ERR14
%Colr%
cls
echo Malfunction 15
echo.
echo Error PSW Pin Removed
echo Error No Password
pause
goto chkpsw

:ERR15
set "Colr=Color 07"
%Colr%
cls
echo Smart Failure Predicted on FujiOS Installation %DATE% %time%
echo.
echo Malfunction 16
echo.
echo WARNING: Immediatly back-up your data and replace
echo your FujiOS. A failure may be imminent
echo.
echo Press P to Proceed or T to Troubleshoot
set /p choice= 

if "%choice%"=="P" goto OSST
if "%choice%"=="p" goto OSST
if "%choice%"=="T" goto Call1
if "%choice%"=="t" goto Call1
exit /b 

:ERR16
set "documentsPath=%mainfilepath%"
echo. > "%documentsPath%\WindowsBootLog.dll"
set "Colr=Color 07"
set "bsodcode=FUJI_CORRUPT_ERR"
set "InfoAdd=FujiOS Has Been Corrupted Reinstall FujiOS."
goto Crash

:ERR17
set "bsodcode=TOO_MANY_BOOT_ATTEMPTS"
set "%InfoAdd%=Please Exit And Restart The Program"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:BSODTYPESETTING
set "lastpage=BSODTYPESETTING"
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

:devtools
if "%OS2%" neq "FujiOS Developer Build" goto File_Manager

color 0A
set "lastpage=DEVTOOLS"
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


:Safw
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
goto Safw1

:Safw1
set "lastpage=Safw1"

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



:clear4w52
set "lastpage=clear4w52"
del %mainfilepath%\login_attempts.log
echo CLEARED
pause
goto Safw1
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:GOGGLE
set "lastpage=GOGGLE"

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
set "lastpage=GOGGLE21"

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

:serch
set "lastpage=SERCH"

goto Wecl

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Terminal
set "lastpage=Terminal"

%Colr%
cls
goto Term1
goto ERR9

:Term1
echo TERMINAL COMMAND PROCCESSOR 
set /p Choice=User Input: 

%Choice%
goto Term1

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:TROJAN
set "lastpage=TROJAN"

cls
color 0C
echo.
echo :[
echo.
echo YOU HAVE BEEN PWNED MWAHAHAHAHAHAHAHAHAHAHAHAH
echo.
echo P.S.
echo   This is an antivirus message
pause
set "bsodcode=PAGE_FAULT_IN_PAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:chkpsw
set "lastpage=chkpsw"

%Colr%
cls
echo Check PSWD Validity
echo.
set /p valid_password=Input: 
echo Password Successfully Changed
Pause
goto login
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Clock
set "lastpage=Clock"
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

:m1
set "lastpage=m1"

cls
echo.
echo.
echo.
echo                           !MAINTENANCE MODE!
echo.
echo.
echo.
echo.
timeout /t 10 /nobreak >nul
:m1b2
echo.
echo.
echo.
echo.
echo Authorized Technicians Only
set /p op=Mode:
if %op%==help echo bypass - File_Manager
if %op%==help echo mode1 - Maintenance
if %op%==help echo mode2 - Maintenance2
if %op%==BYPASS goto File_Manager
if %op%==MODE1 goto Maintenance
if %op%==MODE2 goto Maintenance2
goto m1b2

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:maintenance
set "lastpage=maintenance"

%Colr%
cls
echo.
echo Maintenance Terminal
echo ====================
echo.
echo [1] Lock Terminal
echo [2] Call Technician
echo [3] Request Parts
echo [4] End
echo.
set /p op=User Input:
if %op%==1 goto m2
if %op%==2 goto techsupport
if %op%==3 goto services
if %op%==4 goto Ostart2

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:STARTUPREPAIR
set "lastpage=STARTUPREPAIR"
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
if %op%==3 goto BootupFujios
goto STARTUPREPAIR

:STARTUPREPAUR
set "lastpage=BOOTREPAIR"
cls
echo ==================================
echo           BOOT REPAIR
echo ==================================
echo.
echo %OS2% v%VERSION2% Was Unable To Start
echo.
echo DIAGNOSING . . .
timeout /t 5 /nobreak >nul
pause
echo. 
del colr.pkg
del memory.tmp
del Bootlog.log
goto start1


:REFRESHFUJI
set "RESTARTATTEMPTS=0"
start fds.bat
timeout /t 3 /nobreak >nul
start 6Bit.bat
timeout /t 15 /nobreak >nul
goto BootupFujios


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:m2
set "bsodcode=SECURITY_SYSTEM"
timeout /t 1 /NOBREAK >nul
cls
set "crshdmplocn=%mainfilepath%\CrashLogs"

REM Ensure the USERdocuments folder exists
if not exist "%crshdmplocn%" mkdir "%crshdmplocn%"

set report=%random%crsh%random%.log
set crshdmpfile=%crshdmplocn%\%report%
goto M2345
:M2345
goto crash

:techsupport
%Colr%
cls
timeout /t 5 /nobreak >nul
echo Contacting Tech Support...
timeout /t 5 /nobreak >nul
cls
echo Technician Called
timeout /t 5 /nobreak >nul
Start iexplore https://63755044dc9d4.site123.me/maintenance
timeout /t 5 /nobreak >nul
goto maintenance

:services
set "lastpage=services"

%Colr%
cls
echo.
echo.
echo.
echo Please Fill Out Form
timeout /t 5 /nobreak >nul
pause
cls
echo.
echo Order Request Form:
echo ===================
echo.
echo [1] Screen
echo [2] Keyboard
echo [3] Drive
echo [4] Core
echo [5] Casing
echo.
echo Type Name Of Part
set /p name=
timeout /t 10 /nobreak >nul
echo Type Part Number
set /p op=Part Number:
if %op%==1 goto Order
if %op%==2 goto Order
if %op%==3 goto Order
if %op%==4 goto Order
if %op%==5 goto Order

set "bsodcode=PAGE_FAULT_IN_PAGED_AREA"
goto Crash

:Order
%Colr%
cls
echo %name% Has Been Ordered
timeout /t 1 /nobreak >nul
echo Parts Will Arrive In 5-10 Days
timeout /t 10 /nobreak >nul
pause
goto maintenance

:maintlogs 
set "lastpage=maintlogs"

set "bsodcode=CLOSED_PAGE_ERROR"
goto Crash
%Colr%
setlocal enabledelayedexpansion
cls
echo Maintenance Log System
echo ----------------------

echo 1. Create Maintenance Log
echo 2. Display Logs
echo 3. View Log
echo 4. Edit Log
echo 5. Delete All Logs
echo 6. Exit

set /p choice=Enter your choice: 

if "%choice%"=="1" (
    call :createLog
) else if "%choice%"=="2" (
    call :displayLogs
) else if "%choice%"=="3" (
    call :viewLogContents
) else if "%choice%"=="4" (
    call :editLog
) else if "%choice%"=="5" (
    call :deleteAllLogs
) else if "%choice%"=="6" (
    goto OSST
) else (
    echo Invalid choice. Please try again.
    timeout /nobreak /t 2 >nul
    goto maintlogs 
)

exit /b

:createLog
set "bsodcode=CLOSED_PAGE_ERROR"
goto Crash

:VT100
%Colr%
set /p input="VT100> "
echo %input%
goto VT100

goto ERR6

:LineFeed
set "lastpage=LineFeed"

%Colr%
cls
echo Line Feed
echo Type exit to exit line feed.
echo.
set /p row="Enter row (1-24): "
set /p col="Enter column (1-80): "
cls
goto Output1012

:Output1012
%Colr%
set /p input="Line> "
echo %input%
if %input%==exit goto File_Manager
if %input%==RUNT79AC goto T79AC
goto Output1012


:Settings101
set "lastpage=Settings101"

cls
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



:ScreenS
cls
echo.
pause >nul
goto File_Manager


:clrtst
set "bsodcode=CLOSED_PAGE_ERROR"
goto Crash
cls
echo Are you sure?
echo Once started there is 
echo no way to stop it until
echo it ends.
echo.
echo [1] Yes
echo [2] No
echo.
echo Y/N
set /p HGF=

if %HGF%==1 goto ColorTest
if %HGF%==2 goto File_Manager


:ColorTest
set "bsodcode=CLOSED_PAGE_ERROR"
goto Crash
cls
echo.
color 01
timeout /nobreak /t 3 >nul
cls
echo.
color 10
timeout /nobreak /t 3 >nul
cls
echo.
color 21
timeout /nobreak /t 3 >nul
cls
echo.
color 31
timeout /nobreak /t 3 >nul
cls
echo.
color 41
timeout /nobreak /t 3 >nul
cls
echo.
color 51
timeout /nobreak /t 3 >nul
cls
echo.
color 61
timeout /nobreak /t 3 >nul
cls
echo.
color 71
timeout /nobreak /t 3 >nul
cls
echo.
color 81
timeout /nobreak /t 3 >nul
cls
echo.
color 91
timeout /nobreak /t 3 >nul
cls
echo.
color A0
timeout /nobreak /t 3 >nul
cls
echo.
color B0
timeout /nobreak /t 3 >nul
cls
echo.
color C0
timeout /nobreak /t 3 >nul
cls
echo.
color D0
timeout /nobreak /t 3 >nul
cls
echo.
color E0
timeout /nobreak /t 3 >nul
cls
echo.
color F0
timeout /nobreak /t 3 >nul
goto File_Manager



:Maintenance2
set "lastpage=Maintenance2"

cls
timeout /nobreak /t 3 >nul
echo Welcome to the Maintenance Recovery Tool
echo.
echo.
echo.
echo.
echo You are currently in maintenance mode.
echo.
timeout /nobreak /t 2 >nul
echo Current date: %DATE%
timeout /nobreak /t 2 >nul
echo Current time: %time%
timeout /nobreak /t 2 >nul
call Antivirus.bat
timeout /nobreak /t 2 >nul
call FujiTroubleshooter.cmd
timeout /nobreak /t 2 >nul
goto Maintenance
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash




:ABORT121
set "lastpage=ABORT121"

cls
color 0F
set "password=%valid_password%"
set "username=%valid_username%"
shutdown -a
shutdown -a
shutdown -a
shutdown -a
goto File3242

:password132
REM Batch file to edit user.pkg and pass.pkg files

:edit_username12
set /p username="Enter the new username: "
if "%username%"=="" (
    echo Username cannot be empty. Please try again.
    goto edit_username
)

echo %username%> %mainfilepath%\user.pkg
echo Username updated successfully.

:edit_password12
set /p password="Enter the new password: "
if "%password%"=="" (
    echo Password cannot be empty. Please try again.
    goto edit_password
)

echo %password%> %mainfilepath%\pass.pkg
echo Password updated successfully.

pause
goto file3242
echo Shutting Down
timeout /nobreak /t 5 >nul
cls
echo.
pause >nul
cls
goto OSST

:T79AC
cls
echo [1] CONTINUE
echo [2] ABORT
echo.
set /p op=User Input:
if %op%==1 goto 7AC
if %op%==2 goto OSST

:7AC 
cls
    echo Are you sure you want to delete all logs? (Y/N)
    set /p "confirmation="
    if /i "%confirmation%"=="Y" (
        echo All logs deleted successfully.
        timeout /nobreak /t 2 >nul
        goto 632T1
        timeout /nobreak /t 2 >nul
  )





:BCLS
set "lastpage=BCLS"
cls
echo.
echo.
echo.
echo       ERR Incorrect Password
pause
goto login


:Custom
set "lastpage=Custom"
set "documentsPath=%mainfilepath%"
echo. > "%documentsPath%\BURGER.dll"
echo Error Compiling Batch
echo Error LvL 6
timeout /nobreak /t 5 >nul
goto OSSST


:12
If "%choice%"=="goto 12" goto BCLEY
If "%choice%"=="Goto 12" goto BCLEY
echo. > "%documentsFolder%\%file1Name2%"
goto OSST









:BCLEY2
cls
echo. > "%documentsFolder%\BOOTSEC2"
goto BCLEY


goto OSST
goto OSST
goto OSST
goto OSST
goto OSST
goto OSST
goto OSST
goto OSST





:BCLEY123
set "lastpage=BCLEY123"

set "bsodcode=CLOSED_PAGE_ERROR"
goto Crash
cls
title Please Delete FujiOS
color 01
echo.
echo.
echo        TERMINAL LOCKED
timeout /nobreak /t 999999 >nul
goto BCLEY123












:Custom7t832
set "lastpage=Custom7t832"

cls
echo Type In Ip Address Of Other Computer
echo Both Computers Must Have FujiOS
echo You Need To Type In The IP Of Each
echo Others Computer
echo EX: 192.168.1.1
echo.

set /p IP_ADDRESS=User Input: 
echo Pinging %IP_ADDRESS%...
ping %IP_ADDRESS%

if %errorlevel% equ 0 (
    echo Ping successful. Device Ready To Connect.
) else (
    echo Ping failed. The network is unreachable.
    timeout /t 3 /NOBREAK >nul
    goto PINDA
)

pause
goto File_Manager
set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:PINDA
set "lastpage=PINDA"

set "ErrorL=0"
set "MaxErr=9"
set /a "ErrorL+=1"
if %ErrorL% geq %MaxErr% goto ERR9
cls
ping %IP_ADDRESS%

if %errorlevel% equ 0 (
    echo Ping successful. Device Ready To Connect.
timeout /t 3 /NOBREAK >nul
    goto File_Manager

) else (
    echo Ping failed. The network is unreachable.
timeout /t 3 /NOBREAK >nul
    goto PINDA
)


:Call1
set "lastpage=Call1"

cls
setlocal enabledelayedexpansion

echo Launching...

set "dots="
for /l %%i in (1,1,50) do (
    set "dots=!dots!."
    cls
    echo Loading!dots!
    timeout /nobreak /t 1 >nul
)

echo Done loading.
pause
goto Trouble
pause
goto OSST

:Trouble
cls
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\BOOTSEC.sys" (
    echo No Problems Found With BootMGR

) else (
    echo. > "%documentsPath%\BOOTSEC.sys"
    echo Error BootMGR is Missing
)
Pause
goto Trouble1

:Trouble1
cls
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\BOOTSEC2" (
    echo Error BootSec Bug 
    del "%documentsPath%\BOOTSEC2"
) else (
    echo No BootSec Bugs
)
Pause
goto Trouble2

:Trouble2
cls
set "documentsPath=%mainfilepath%"

if exist "%documentsPath%\BURGER.dll" (
    echo Corrupted Fuji Installation
    timeout /nobreak /t 4 >nul
    goto BROKE

) else (
    echo DONE!
)
Pause
cls
echo No further problems have been found
pause
goto OSSST

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash



:BROKE
cls
echo We were unable to fix your
echo FujiOS installation
echo.
echo.
echo.
pause

goto OSSST


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Root1
cls
set "Root=true"
echo Root Access Granted
pause
goto Ostart2

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:AuthCode
set "lastpage=AuthCode"

set /a "Retry+=1"
set "NameFold=%mainfilepath%"
echo. > "%NameFold%\BootTime1" %Date%
set "AuthCode1=2033"
set "BE=10112"
if "%valid_AuthCode%"=="%BE%" goto ERR14
if "%AuthCode%"=="%BE%" goto ERR14
if "%AuthCode%"=="%BE%" goto ERR14
if "%AuthCode%"=="%BE%" goto ERR14
if "%AuthCode%"=="%BE%" goto ERR14
if "%AuthCode%"=="%BE%" goto ERR14
if "%valid_AuthCode%"=="%AuthCode1%" goto Root1
if "%AuthCode%"=="%valid_AuthCode%" goto Ostart2
echo Unable to parse authentication code
echo Authentication code is not valid!
if %Retry% geq 10 goto Auth20121
echo.
echo press any key to retry
echo.
echo.
pause >nul

goto AuthCode

goto AuthCode

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Auth20121
cls
goto Auth2012
goto Auth2012
goto Auth2012
goto Auth2012

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Auth2012
set "lastpage=Auth2012"

for /f %%i in ('type "%mainfilepath%\kencr"') do set "targetNumber=%%i"
set "AuthCode1=2033"
set "BE=10112"
if "%valid_AuthCode%"=="%BE%" goto ERR14
if "%AuthCode%"=="%BE%" goto ERR14
if "%valid_AuthCode%"=="%AuthCode1%" goto Root1
if "%AuthCode%"=="%valid_AuthCode%" goto Ostart2
echo Unable to parse authentication code
echo Authentication code is not valid!
echo.
echo Enter API Key To Continue Manually 
set /p BECA=Enter Key:
echo.
echo.
if "%BECA%" equ "%targetNumber%" goto Ostart2


goto Auth2012

goto Auth2012

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Antivirus
set "lastpage=Antivirus"

cls
call Antivirus.bat

goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Gamesstat
set "lastpage=Gamesstat"

cls
setlocal enabledelayedexpansion
echo Game Station-S
echo.
echo Type EXIT to exit.
echo.
:: Initialize counter
set "count=0"

:: Loop through .cmd files and add them to the numbered list
for %%f in (*.cmd) do (
    set /a count+=1
    set "file[!count!]=%%f"
    echo !count! - %%f
)

:: Check if any .cmd files were found
if %count%==0 (
    echo No .cmd files found in the current directory.
    pause
    exit /b
)

:run
:: Prompt the user to choose a file to run
set /p "choice=Enter the number of the file you want to run: "

:: Validate input
if "!file[%choice%]!"=="" (
    echo Invalid choice. No such file number.
    pause
    goto File_Manager
)

:: Run the selected .cmd file and check for errors
echo Running "!file[%choice%]!"
echo.
echo.
call "!file[%choice%]!" || (
    echo.
    echo.
    echo Error: Failed to execute "!file[%choice%]!".
    pause
    goto File_Manager
)
goto File_Manager
goto Gamesstat


set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:LoginBtff1
cls
echo Warning: Your account may be at risk. Unusual login attempts detected.
echo Check the file "%logFilePath%" for details.
pause
goto login

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash




:FujiDriveTools
if "%input_domain%" equ "$GUEST" echo NOT AVAILABLE AS GUEST
if "%input_domain%" equ "$GUEST" pause
if "%input_domain%" equ "$GUEST" goto File_Manager
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



:SysApp
set "lastpage=SysApp"

cls
echo =============================
echo         System Apps
echo =============================
echo.
echo 01. VT100 Terminal*
echo 02. Line Feed*
echo 03. Fuji Connect*
echo 04. Telenet*
echo 05. Settings*
echo 06. Account Info*
echo 07. Hacking Tools*
echo 08. Back
echo =============================
echo Items Marked With * Should 
echo be handled with care. If 
echo not handled correctly
echo it could corrupt FujiOS.
choice /c 12345678 /n /M ">"
set "choice=%errorlevel%"
if "%choice%"=="1" goto VT100
if "%choice%"=="2" goto LineFeed
if "%choice%"=="3" goto Custom7t832
if "%choice%"=="4" goto Telenet
if "%choice%"=="5" goto FUJISETTINGS
if "%choice%"=="6" goto Deviceinfo1
if "%choice%"=="7" goto HackingTOols
if "%choice%"=="8" goto File_Manager

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash


:HackingTOols
cls
echo =============================
echo        Hacking Tools
echo =============================
echo.
echo 01. GeoLocate IP
echo 02. Trace DNS
echo 03. Trace Mac Address
echo 04. DDOS
echo 05. Trace IP
echo 06. View Connections
echo 07. 
echo 08. 
echo 09. Back
echo =============================
echo Items Marked With * Should 
echo be handled with care. If 
echo not handled correctly
echo it could corrupt FujiOS.
set /p choice=User Input: 

if "%choice%"=="1" call geolocate.cmd
if "%choice%"=="2" call TraceDNS.cmd
if "%choice%"=="3" call Macaddres.cmd
if "%choice%"=="4" call DDOS.bat
if "%choice%"=="5" call TraceIP.cmd
if "%choice%"=="6" call Viewconn.cmd
if "%choice%"=="9" goto File_Manager
goto HackingTOols


:Telenet
set "lastpage=Telenet"

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

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Error12871
cls
echo Invalid Variable Configuration
echo Invalid Boot Time Configuration
echo Invalid BIOS Configuration
pause
cls
goto E121

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:REGISTERACC
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

echo There is already a user signed up on this device.
echo.
echo To overwrite this account, please type in the 
echo password of the account.
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




:systemsetup
set "lastpage=systemsetup"

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
goto Settings101

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Exit101
exit /b

set "bsodcode=PAGE_FAULT_IN_NONPAGED_AREA"
goto Crash

:Breakpoint
cls
echo SHUTTING DOWN...
timeout /t 5 /nobreak >nul

del memory.tmp
if %hibernate% neq 1 del HIBERNATE.log
cls
color 06
echo %OS2% v%VERSION2% 
echo IS READY TO BE SHUT DOWN.
ECHO YOU MAY CLOSE THIS WINDOW
timeout /t 9999 /nobreak >nul
goto Breakpoint



:UNSUCSSHTDWN
cls
echo.
echo.
echo.
set "UNSUCSSHTDWN=0"
echo %OS2% v%VERSION2% Was Not Shut Down Properly
echo Last Session. Next Time Please Use The Shutdown
echo Menu And Select Shutdown.
echo.
echo.
echo.
pause
goto STARTUPREPAIR

:FINISHUPDATING
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

:Breakpoint12321
del memory.tmp
exit

:Breakpoint123
del memory.tmp
