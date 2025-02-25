
@echo off
set "caller="
set "OPERATINGSYS1=EMPTY"
set "OPERATINGSYS2=EMPTY"
set "OPERATINGSYS3=EMPTY"
set "OPERATINGSYS4=EMPTY"
set "OPERATINGSYS5=EMPTY"
cls
set "mainfilepath=%userprofile%\FUJIOS"
if not exist %mainfilepath%\registration.log goto BLACKLIST
if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
if "%CRASHLOADED%" neq "1" exit /b
set "crash=1"

set "OS2=FujiOS"
set /p VERSION2=<version.txt
if exist "License.txt" goto restart
Set "debug1453="
set "bsodcode=BOTLDR_LICENSE_REVOKED"
set "crash=1"
exit /b

:restart
if exist %userprofile%\AppData\Local\lcnse.log goto FJJ
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
if "%errorlevel%" equ "1" call :acceptaggreements

goto FJJ

:FJJ
if exist OperatingSystem.Backup (
    start UpAgent.bat
    exit
)
:Check1
set /p foscd=<icd.ini
< settings.ini (
  set /p Pin1=
  set /p Pin2=
  set /p Pin3=
  set /p Pin4=
  set /p Pin5=
  set /p Pin6=
  set /p Pin7=
  set /p Pin8=
  set /p PinVerif=
)

set "validOSFiles=OperatingSystem.bat OperatingSystem1.bat OperatingSystem3.bat OperatingSystem4.bat OperatingSystemINDEV.bat"
set validCount=0

if "%foscd%" neq "1121" goto BCW
if "%PinVerif%" neq "01000110.01001111.01010011" goto BCW
for %%F in (%validOSFiles%) do (
    if exist "%%F" (
        set /a validCount+=1
        set "osfile[!validCount!]=%%F"
    )
)

set "documentsPath=%mainfilepath%"

if %validCount%==0 (
    set "bsodcode=BOTLDR_NO VALID OS"
    set "crash=1"
    exit /b
)

if %validCount% GTR 1 (
    goto DualBoot
)


goto check2

:check2
goto bob

:bob
set "mainfilepath=%userprofile%\FUJIOS"
if not exist %mainfilepath%\registration.log goto BLACKLIST
if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
title %os2%
cls
echo %OS2% Bootloader v%VERSION2%
echo.
goto bob15
:bob15
set "Apps=0"
if exist "HIBERNATE.log" echo %OS2% v%VERSION2% is Ready For Quick Boot.
if not exist "HIBERNATE.log" echo %OS2% v%VERSION2% is NOT Ready For Quick Boot.
echo.
echo 1. BOOT %OS2% v%VERSION2% (Wifi Required)
echo 2. Quick Boot %OS2% v%VERSION2% (Wifi Required)
echo 3. Boot Apps (Wifi Optional)
echo 4. Advanced Mode

echo 5. Exit Bootloader
choice /c 123456 /n /m "Choice:"
set choice=%errorlevel%

if %choice% equ 1 goto start1
if %choice% equ 2 goto HIBER1
if %choice% equ 3 (
    set "Apps=1"
    goto Start
)
if %choice% equ 4 goto bob12
if %choice% equ 5 exit
if %choice% equ 6 goto UIC

goto bob

set "bsodcode=BOTLDR_INTERPAGE JUMP"
set "crash=1"
exit /b

:DualBoot
cls
set count=0
set osIndex=1
set validCount=0

for %%F in (%validOSFiles%) do (
    if exist "%%F" (
        set /a validCount+=1
        set "osfile[!validCount!]=%%F"
    )
)

echo %OS2% Bootloader v%VERSION2%
echo Multi Boot Menu
echo.
echo.


for /L %%I in (1,1,5) do (
    if %%I LEQ !validCount! (
        rem Use call to properly expand the dynamic variable name.
        call set "OPERATINGSYS%%I=%%osfile[%%I]%%"
    )
)
echo Multiple OS files found.
echo [1] !OPERATINGSYS1!
echo [2] !OPERATINGSYS2!
echo [3] !OPERATINGSYS3!
echo [4] !OPERATINGSYS4!
echo [5] !OPERATINGSYS5!
)


echo.
choice /c 12345 /n /m "Boot> "
set "choice=%errorlevel%"
if %choice%==1 (
    set "Caller=%OPERATINGSYS1%"
    goto custombootOS
)
if %choice%==2 (
    set "Caller=%OPERATINGSYS2%"
    goto custombootOS
)
if %choice%==3 (
    set "Caller=%OPERATINGSYS3%"
    goto custombootOS
)
if %choice%==4 (
    set "Caller=%OPERATINGSYS4%"
    goto custombootOS
)
if %choice%==5 (
    set "Caller=%OPERATINGSYS5%"
    goto custombootOS
)

:custombootOS
cls
set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini
if %Caller%==OperatingSystemINDEV.bat (
    set "OS2=FujiOS Developer Build"
    set "VERSION2=DEVELOPEMENT"
)
call Varset.bat
if %varchck% neq VariablesPassed (
    echo A Error Has Occurred In VARSET.bat
    pause
)
Call "%Caller%"
cls
echo %Caller% Was Exited
pause
goto DualBoot

set "bsodcode=BOTLDR_INTERPAGE JUMP"
set "crash=1"
exit /b

:UIC
set "bsodcode=BOTLDR_USER_INIT_CRASH"
set "crash=1"
exit /b

set "bsodcode=BOTLDR_INTERPAGE JUMP"
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
if "%op%"=="start\q" goto Start
if "%op%"=="cls" goto bob
if "%op%"=="Cls" goto bob
if "%op%"=="CLS" goto bob
if "%op%"=="root" set "Root=true" 
if "%op%"=="root" echo ROOT BOOTLOADER 
if "%op%"=="SCAN" call Antivirus.bat
%op%
goto bob12

set "bsodcode=BOTLDR_INTERPAGE JUMP"
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
    goto BOOTLOADERERR

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
set "mainfilepath=%userprofile%\FUJIOS"

if not exist %mainfilepath%\CoreBootLoader.MARK goto cont7yfg73gf43uf
echo >%mainfilepath%\CoreBootLoader.MARK
set "targetDir=%userprofile%\Appdata\Local\temporaryfos"
if not exist "%targetDir%" mkdir "%targetDir%"
for %%F in (*.bat) do (
    copy "%%F" "%TARGET_DIR%"
)

for %%F in (*.cmd) do (
    copy "%%F" "%TARGET_DIR%"
)
del /Q "*.old"
del /Q "*.backup"
del License.txt
del /Q "*.bat"
timeout /t 5 /nobreak >nul
exit


:cont7yfg73gf43uf

if exist %mainfilepath%\registration.log goto cont64ewr7tf843g7r74
echo >%mainfilepath%\CoreBootLoader.MARK
set "targetDir=%userprofile%\Appdata\Local\temporaryfos"
if not exist "%targetDir%" mkdir "%targetDir%"
for %%F in (*.bat) do (
    copy "%%F" "%TARGET_DIR%"
)

for %%F in (*.cmd) do (
    copy "%%F" "%TARGET_DIR%"
)
del /Q "*.old"
del /Q "*.backup"
del License.txt
del /Q "*.bat"
timeout /t 5 /nobreak >nul
exit


:cont64ewr7tf843g7r74


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
) else (
    set "Caller=OperatingSystem.bat"
)
if "%apps%" == "1" set "Caller=GamesSys32.bat"
call %Caller%
cls
echo %Caller% Was Exited
pause
goto bob1

:bob1
cls
goto bob

:KernelERR
set "bsodcode=BOTLDR_INTERPAGE JUMP"
set "crash=1"
exit /b


:BLACKLIST
echo >%mainfilepath%\CoreBootLoader.MARK
set "targetDir=%userprofile%\Appdata\Local\temporaryfos"
if not exist "%targetDir%" mkdir "%targetDir%"
for %%F in (*.bat) do (
    copy "%%F" "%TARGET_DIR%"
)

for %%F in (*.cmd) do (
    copy "%%F" "%TARGET_DIR%"
)
del /Q "*.old"
del /Q "*.backup"
del License.txt
del /Q "*.bat"
timeout /t 5 /nobreak >nul
exit


:HIBER1
set "mainfilepath=%userprofile%\FUJIOS"

if not exist %mainfilepath%\CoreBootLoader.MARK goto contt657874367496
echo >%mainfilepath%\CoreBootLoader.MARK
set "targetDir=%userprofile%\Appdata\Local\temporaryfos"
if not exist "%targetDir%" mkdir "%targetDir%"
for %%F in (*.bat) do (
    copy "%%F" "%TARGET_DIR%"
)

for %%F in (*.cmd) do (
    copy "%%F" "%TARGET_DIR%"
)
del /Q "*.old"
del /Q "*.backup"
del License.txt
del /Q "*.bat"
timeout /t 5 /nobreak >nul
exit


:contt657874367496

if exist %mainfilepath%\registration.log goto cont435678436543
echo >%mainfilepath%\CoreBootLoader.MARK
set "targetDir=%userprofile%\Appdata\Local\temporaryfos"
if not exist "%targetDir%" mkdir "%targetDir%"
for %%F in (*.bat) do (
    copy "%%F" "%TARGET_DIR%"
)

for %%F in (*.cmd) do (
    copy "%%F" "%TARGET_DIR%"
)
del /Q "*.old"
del /Q "*.backup"
del License.txt
del /Q "*.bat"
timeout /t 5 /nobreak >nul
exit


:cont435678436543








set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini
call OSCrashProcessor.bat
goto bob1

set "bsodcode=BOTLDR_INTERPAGE JUMP"
set "crash=1"
exit /b

:BCW
cls
echo Possible BIOS Corruption 
echo Press any key to repair
pause >nul
echo 1121>icd.ini
goto SETCODES




:SETCODES
(
  echo 0
  echo 0
  echo 0
  echo 0
  echo 1
  echo 1
  echo 1
  echo 1
  echo 01000110.01001111.01010011
) > settings.ini
goto restart

:acceptaggreements
(
    echo ----------------------------------------
    echo User [%USERNAME%] Accepted License Agreements for FujiOS
    echo Date: %DATE%  Time: %TIME%
    echo ----------------------------------------
    echo.
    echo License Agreements That Were Agreed To:
    echo.
    type License.txt
    echo.
    echo ----------------------------------------
) >> "%userprofile%\AppData\Local\lcnse.log"
exit /b
