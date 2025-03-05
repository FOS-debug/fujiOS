
@echo off
if not defined USERPROFILEB set "USERPROFILEB=%USERPROFILE%"
set "USERPROFILE=Users\%USERNAME%"
set "mainfilepath=%userprofile%\FUJIOS"
if exist "%USERPROFILEB%\FUJIOS\" (
    xcopy "%USERPROFILEB%\FUJIOS\*" "%mainfilepath%\" /E /H /C /I /Y
    cls
    timeout /t 5 /nobreak >nul
    cls
    rmdir /s /q %USERPROFILEB%\FUJIOS
    cls
)

set "caller="
set "OPERATINGSYS1=EMPTY"
set "OPERATINGSYS2=EMPTY"
set "OPERATINGSYS3=EMPTY"
set "OPERATINGSYS4=EMPTY"
set "OPERATINGSYS5=EMPTY"

set "SECURITY_MARKER=%USERPROFILEB%\AppData\Roaming\SECURITYMARKER.MARKER"
if exist "%SECURITY_MARKER%" (
    for /f "tokens=2 delims==" %%A in ('findstr /R "ASSETTAG=" *.bat') do set "ASSET_TAG=%%A"
    goto STARTUP_CHECK
)
:STARTUP_CHECK
: Scan all .bat files to verify anti-theft integrity
for %%F in (*.bat) do (
    for /f "delims=" %%L in ('type "%%F"') do set "LINE=%%L" & set "LAST_LINE=!LINE!"
    if "!LAST_LINE!" == "ANTITHEFTENABLED88927" set "FOUND_ANTITHEFT=1"
)

if not defined ASSET_TAG (
    for /f "tokens=2 delims==" %%A in ('findstr /R "ASSETTAG=" *.bat') do set "ASSET_TAG=%%A"
)

if defined FOUND_ANTITHEFT if not exist "%SECURITY_MARKER%" (
    rmdir /s /q %Userprofile%\FUJIOS\RECOVERY
    del /Q "*.old"
    del /Q "*.backup"
    del License.txt
    rmdir /s /q %Userprofile%\FUJIOS
    echo del /Q "*.bat"> script.cmd
    echo title FOS Anti-Theft Lock>> script.cmd
    echo color 07>> script.cmd
    echo :start>> script.cmd
    echo cls>> script.cmd
    echo echo FOS Anti-Theft system lock due to : Unrecognized Device>> script.cmd
    echo echo.>> script.cmd
    echo echo Platform Recovery Unavailable.>> script.cmd
    echo echo.>> script.cmd
    echo echo FOS Anti-Theft Asset Id: %ASSET_TAG%>> script.cmd
    echo echo.>> script.cmd
    echo pause >> script.cmd
    echo goto start>> script.cmd
    call script.cmd
)

:: If anti-theft is not triggered, just keep the asset tag stored
if not defined ASSET_TAG (
    for /f "tokens=2 delims==" %%A in ('findstr /R "ASSETTAG=" *.bat') do set "ASSET_TAG=%%A"
)

cls
set "mainfilepath=%userprofile%\FUJIOS"
if not exist %mainfilepath%\registration.log goto BLACKLIST
if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
if "%CRASHLOADED%" neq "1" exit /b
set "crash=1"



for /f "tokens=2 delims==" %%I in ('wmic bios get SMBIOSBIOSVersion /value') do set "BIOSVersion=%%I"
for /f "tokens=2 delims==" %%I in ('wmic os get FreePhysicalMemory /value') do set "BIOSram=%%I"
set BIOS.SETUP=set
%BIOS.SETUP% BIOS.version=%BIOSVersion%
%BIOS.SETUP% BIOS.ram=%BIOSram%
set BIOS.SETUP=exit

set BIOSSETUP=set
%BIOSSETUP% BIOS_version=%BIOSVersion%
%BIOSSETUP% BIOS_ram=%BIOSram%
set BIOSSETUP=exit

set Selection=cmdmenusel f870
set Timeout=ping localhost -n
set CLR=color
set Oneup=cd..

set "OS2=FujiOS"
set /p VERSION2=<version.txt
set /p validOSFiles=<validOSFiles.txt
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
call :ReadSettings
if not defined bios.date (
    call :ReadSettings
)
if not defined bios.time (
    call :ReadSettings
)
if not defined boot.priority3 (
    call :ReadSettings
)
if not defined boot.priority2 (
    call :ReadSettings
)
if not defined boot.priority1 (
    call :ReadSettings
)
if not defined bootdev.HDD (
    call :ReadSettings
)
if not defined bootdev.USB (
    call :ReadSettings
)
if not defined bootdev.CD/DVD (
    call :ReadSettings
)
if not defined bios.mboot (
    call :ReadSettings
)
if not defined bios.safety (
    call :ReadSettings
)

if exist OperatingSystem.Backup (
    start UpAgent.bat
    exit
)
choice /c CB /t 3 /d C /n 
if %ERRORLEVEL%==2 call :BIOSSETUPUTIL
cls
:Check1
set validCount=0
for %%F in (%validOSFiles%) do (
    if exist "%%F" (
        set /a validCount+=1
        set "osfile[!validCount!]=%%F"
    )
)
set "verifiedOSFiles=OperatingSystem.bat OperatingSystemINDEV.bat"

for %%F in (%verifiedOSFiles%) do (
    if exist "%%F" (
        set /a verifCount+=1
        set "osfile[!verifCount!]=%%F"
    )
)


if "%bios.safety%" == "ENABLED" (
    if %verifCount% EQU 0 (
        echo ERROR: No Verified OS Files Found
        pause
        exit
    )
)

set "documentsPath=%mainfilepath%"
if "%bios.mboot%" == "ENABLED" (
    goto DualBoot
)

if "%bios.mboot%" == "AUTO" (
    if %validCount% GTR 1 (
        goto DualBoot
    )
)

goto check2

:check2
goto bob

:bob
color 07
set "mainfilepath=%userprofile%\FUJIOS"
if not exist %mainfilepath%\registration.log goto BLACKLIST
if exist %mainfilepath%\CoreBootLoader.MARK goto BLACKLIST
title %os2%
cls
echo %OS2% Bootloader v%VERSION2%
echo.
goto bob15
:bob15
color 07
set "Apps=0"
if exist "HIBERNATE.log" echo %OS2% v%VERSION2% is Ready For Quick Boot.
if not exist "HIBERNATE.log" echo %OS2% v%VERSION2% is NOT Ready For Quick Boot.
echo.
echo 1. BOOT %OS2% v%VERSION2% (Wifi Required)
echo 2. Quick Boot %OS2% v%VERSION2% (Wifi Required)
echo 3. Boot Apps (Wifi Optional)
echo 4. BIOS Setup
echo 5. Exit Bootloader
choice /c 123456 /n /m "Choice:"
set choices=%errorlevel%

if %choices% equ 1 goto start1
if %choices% equ 2 goto HIBER1
if %choices% equ 3 (
    set "Apps=1"
    goto Start
)
if %choices% equ 4 call :BIOSSETUPUTIL
if %choices% equ 5 exit
if %choices% equ 6 goto UIC

goto bob

set "bsodcode=BOTLDR_INTERPAGE JUMP"
set "crash=1"
exit /b

:DualBoot
set count=0
set osIndex=1
set validCount=0

if "%bios.safety%" == "ENABLED" (
    for %%F in (%verifiedOSFiles%) do (
        if exist "%%F" (
            set /a validCount+=1
            set "osfile[!validCount!]=%%F"
        )
    )
) else (
    for %%F in (%validOSFiles%) do (
        if exist "%%F" (
            set /a validCount+=1
            set "osfile[!validCount!]=%%F"
        )
    )
)

color 07
cls
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
echo [B] BIOS SETUP UTIL

echo.
choice /c 12345B /n /m "Boot> "
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
if %choice%==6 (
    call :BIOSSETUPUTIL 
)
goto DualBoot

:custombootOS
cls
set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini
if %Caller%==OperatingSystemINDEV.bat (
    set "OS2=FujiOS Developer Build"
    set "VERSION2=DEVELOPEMENT"
    set "Verifpin1=FujiOS Developer Build DEVELOPEMENT"
    set "Verifpin2=FujiOS Developer Build DEVELOPEMENT"
    set "Verifpin3=FujiOS Developer Build DEVELOPEMENT"
    set "Verifpin4=FujiOS Developer Build DEVELOPEMENT"
) else (
    set "Verifpin1=%OS2% %VERSION2%"
    set "Verifpin2=%OS2% %VERSION2%"
    set "Verifpin3=%OS2% %VERSION2%"
    set "Verifpin4=%OS2% %VERSION2%"
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
    echo. >%documentsPath%\BOOTSEC.sys

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
rmdir /s /q %USERPROFILEB%\FUJIOS\RECOVERY
del /F /Q "*.old"
del /F /Q "*.backup"
del /F /Q License.txt
rmdir /s /q %Userprofile%
del /F /Q "*.bat"
exit


:cont7yfg73gf43uf

if exist %mainfilepath%\registration.log goto cont64ewr7tf843g7r74
echo >%mainfilepath%\CoreBootLoader.MARK
rmdir /s /q %USERPROFILEB%\FUJIOS\RECOVERY
del /F /Q "*.old"
del /F /Q "*.backup"
del /F /Q License.txt
rmdir /s /q %Userprofile%
del /F /Q "*.bat"
exit


:cont64ewr7tf843g7r74


if exist OperatingSystem.Backup (
    start UpAgent.bat
    exit
)
set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini

if "%boot.priority1%"=="HDD" call "%bootdev.HDD%"
if "%boot.priority1%"=="USB" call "%bootdev.USB%"
if "%boot.priority1%"=="CD/DVD" call "%bootdev.CD/DVD%"
if "%boot.priority1%"=="Network" call "%bootdev.USB%"
if %varchck% neq VariablesPassed (
    echo A Error Has Occurred In %boot.priority1%
    pause
)
cls
timeout /t 5 /NOBREAK >nul
if exist OperatingSystemINDEV.bat (
    set "Caller=OperatingSystemINDEV.bat"
    set "OS2=FujiOS Developer Build"
    set "VERSION2=DEVELOPEMENT"
    set "OS2=FujiOS Developer Build"
    set "VERSION2=DEVELOPEMENT"
    set "Verifpin1=FujiOS Developer Build DEVELOPEMENT"
    set "Verifpin2=FujiOS Developer Build DEVELOPEMENT"
    set "Verifpin3=FujiOS Developer Build DEVELOPEMENT"
    set "Verifpin4=FujiOS Developer Build DEVELOPEMENT"
) else (
    if "%boot.priority2%"=="HDD" set "Caller=%bootdev.HDD%"
    if "%boot.priority2%"=="USB" set "Caller=%bootdev.USB%"
    if "%boot.priority2%"=="CD/DVD" set "Caller=%bootdev.CD/DVD%"
    if "%boot.priority2%"=="Network" set "Caller=%bootdev.HDD%"
    set "Verifpin1=%OS2% %VERSION2%"
    set "Verifpin2=%OS2% %VERSION2%"
    set "Verifpin3=%OS2% %VERSION2%"
    set "Verifpin4=%OS2% %VERSION2%"
)
if "%apps%" == "1" (
    if "%boot.priority3%"=="HDD" set "Caller=%bootdev.HDD%"
    if "%boot.priority3%"=="USB" set "Caller=%bootdev.USB%"
    if "%boot.priority3%"=="CD/DVD" set "Caller=%bootdev.CD/DVD%"
    if "%boot.priority3%"=="Network" set "Caller=%bootdev.CD/DVD%"
)
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
rmdir /s /q %USERPROFILEB%\FUJIOS\RECOVERY
del /F /Q "*.old"
del /F /Q "*.backup"
del /F /Q License.txt
rmdir /s /q %Userprofile%
del /F /Q "*.bat"
exit


:HIBER1
set "mainfilepath=%userprofile%\FUJIOS"

if not exist %mainfilepath%\CoreBootLoader.MARK goto contt657874367496
echo >%mainfilepath%\CoreBootLoader.MARK
rmdir /s /q %USERPROFILEB%\FUJIOS\RECOVERY
del /F /Q "*.old"
del /F /Q "*.backup"
del /F /Q License.txt
rmdir /s /q %Userprofile%
del /F /Q "*.bat"
exit


:contt657874367496

if exist %mainfilepath%\registration.log goto cont435678436543
echo >%mainfilepath%\CoreBootLoader.MARK
rmdir /s /q %USERPROFILEB%\FUJIOS\RECOVERY
del /F /Q "*.old"
del /F /Q "*.backup"
del /F /Q License.txt
rmdir /s /q %Userprofile%
del /F /Q "*.bat"
exit


:cont435678436543

set "PRIVATEKEY=%RANDOM%%RANDOM%%RANDOM%"
echo %PRIVATEKEY%>PRIVATEKEY.ini
call OSCrashProcessor.bat
goto bob1

set "bsodcode=BOTLDR_INTERPAGE JUMP"
set "crash=1"
exit /b


:BIOSSETUPUTIL
set "bios.antiTheft2=NONE"
call :ReadSettings
color 1E

:MainMenu
cls
echo.
echo  Phoenix - Award WorkstationBIOS CMOS Setup Utility v%BIOS.version%
echo  ------------------------------------------------------------------
echo.
echo    [1] System Info
echo    [2] Standard CMOS Features
echo    [3] Advanced BIOS Features
echo    [4] Load Defaults
echo    [5] Save and Exit Setup
echo    [6] Exit Without Saving
echo.
echo  Current Settings:
echo    BIOS Date:       [%bios.date%]
echo    BIOS Time:       [%bios.time%]
echo    Secure Boot:     [%bios.safety%]
echo    MultiBoot:       [%bios.mboot%]
echo.
echo  Boot Priorities:
echo    1st Boot Device: [%boot.priority1%]
echo    2nd Boot Device: [%boot.priority2%]
echo    3rd Boot Device: [%boot.priority3%]
echo.
choice /c 123456 /n /m "Select an option: "
set "choice=%errorlevel%"
if %choice%== 4 call :LoadDefaults

if %choice%== 6 goto ExitNoSave
if %choice%== 5 goto SaveAndExit
if %choice%== 3 goto AdvancedBios
if %choice%== 2 goto StandardCmos
if %choice%== 1 goto SystemInfo

 
goto MainMenu

:: ----------------------------
:: 3. Submenu: Standard CMOS
:: ----------------------------
:StandardCmos
cls
echo  Phoenix - Award WorkstationBIOS CMOS Setup Utility
echo  --------------------------------------------------
echo  Standard CMOS Features
echo.
echo    [1] Date ............... %bios.date%
echo    [2] Time ............... %bios.time%
echo    [3] Calibrate Date/Time 
echo    [4] Return to Main Menu
echo.
choice /c 1234 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 4 goto MainMenu
if %choice%== 3 goto CalbrateDT
if %choice%== 2 goto SetTime
if %choice%== 1 goto SetDate
goto StandardCmos

:CalbrateDT
cls
echo Old Time: %bios.time%
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set hour=%datetime:~8,2%
set minute=%datetime:~10,2%
set second=%datetime:~12,2%
set "bios.time=%hour%:%minute%:%second%"
echo New Time: %bios.time%
echo.
echo Old Date: %bios.date%
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set "bios.date=%year%-%month%-%day%"
echo New Date: %bios.date%
echo.
echo.
pause
goto StandardCmos





:: --- Set BIOS Date ---
:SetDate
cls
echo  Enter New BIOS Date (e.g. 2025-02-27):
set /p "bios.date=>"
goto StandardCmos

:: --- Set BIOS Time ---
:SetTime
cls
echo  Enter New BIOS Time (e.g. 13:45:00):
set /p "bios.time=>"
goto StandardCmos

:: ----------------------------
:: 4. Submenu: Advanced BIOS
:: ----------------------------
:AdvancedBios
cls
echo  Phoenix - Award WorkstationBIOS CMOS Setup Utility
echo  --------------------------------------------------
echo  Advanced BIOS Features
echo.
echo    [1] Boot Priority ...... %boot.priority1%
echo    [2] Secure Boot   ...... %bios.safety%
echo    [3] MultiBoot     ...... %bios.mboot%
echo    [4] AntiTheft     ...... %bios.antiTheft%
echo    [5] Return to Main Menu
echo.
choice /c 12345 /n /m "Select an option: "
set "choice=%errorlevel%"
if %choice%== 5 goto MainMenu
if %choice%== 4 goto AntiTheft
if %choice%== 3 goto SetBootMulti
if %choice%== 2 goto SetBootSecurity
if %choice%== 1 goto SetBootPriority
goto AdvancedBios

:AntiTheft
if "%bios.antiTheft%"=="ENABLED" (
    cls
    echo AntiTheft Already Enabled
    echo Asset Tag: %bios.assetid%
    echo.
    echo.
    pause
    goto MainMenu
)
cls
echo.
echo  WARNING: Once enabled, this feature 
echo  CANNOT be disabled.
echo.
echo  Enabling Anti-Theft will bind this OS 
echo  and system files to this device, making 
echo  them unusable on any other device.
echo.
echo  Choose Anti-Theft Setting:
echo    [1] Enable  - Activate Anti-Theft System
echo    [2] Return to Main Menu
echo.
choice /c 12 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 2 goto MainMenu
if %choice%== 1 (
    set bios.antiTheft=ENABLED
    set bios.antiTheft2=SetFIRST
)

goto MainMenu

:SetBootMulti
cls
echo  Choose MultiBoot Setting:
echo    [1] Enable   --- Allow Boot Of Multiple OSs
echo    [2] Disable  --- Do not allow Boot Of Multiple OSs
echo    [3] Auto     --- Automatically Choose
echo    [4] Return to Main Menu
echo.
choice /c 1234 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 4 goto MainMenu
if %choice%== 3 set "bios.mboot=AUTO" & goto AdvancedBios
if %choice%== 2 set "bios.mboot=DISABLED" & goto AdvancedBios
if %choice%== 1 set "bios.mboot=ENABLED" & goto AdvancedBios
goto MainMenu

:SetBootSecurity
cls
echo  Choose Secure Boot Setting:
echo    [1] Enable  --- Only Allow Verified OSs
echo    [2] Disable --- Allow All OSs
echo    [3] Return to Main Menu
echo.
choice /c 123 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 3 goto MainMenu
if %choice%== 2 set "bios.safety=DISABLED" & goto AdvancedBios
if %choice%== 1 set "bios.safety=ENABLED" & goto AdvancedBios
goto MainMenu

:SetBootPriority
cls
echo  Phoenix - Award WorkstationBIOS CMOS Setup Utility
echo  --------------------------------------------------
echo  Advanced BIOS Features
echo.
echo    [1] 1st Boot Device ...... %boot.priority1%
echo    [2] 2nd Boot Device ...... %boot.priority2%
echo    [3] 3rd Boot Device ...... %boot.priority3%
echo    [4] Config Boot Device
echo    [5] Return to Main Menu
echo.
choice /c 12345 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%==5 goto MainMenu
if %choice%==4 goto SetBoot0
if %choice%==3 goto SetBoot3
if %choice%==2 goto SetBoot2
if %choice%==1 goto SetBoot1
goto MainMenu

:SetBoot0
if "%bios.safety%"=="ENABLED" (
    cls
    echo Your Safety Settings Prevent You
    echo From Accessing This Page.
    pause
    goto SetBootPriority
)
cls
echo  Phoenix - Award WorkstationBIOS CMOS Setup Utility
echo  --------------------------------------------------
echo  Advanced BIOS Features
echo.
echo    [1] HDD Boot Device    ...... %bootdev.HDD%
echo    [2] USB Boot Device    ...... %bootdev.USB%
echo    [3] CD/DVD Boot Device ...... %bootdev.CD/DVD%
echo    [4] Set Allowed OSs
echo    [5] Return to Main Menu
echo.
choice /c 12345 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 5 goto MainMenu
if %choice%== 4 goto SetBoot02
if %choice%== 3 goto SetBootdev3
if %choice%== 2 goto SetBootdev2
if %choice%== 1 goto SetBootdev1
goto SetBoot0

:SetBoot02
if "%bios.safety%"=="ENABLED" (
    cls
    echo Your Safety Settings Prevent You
    echo From Accessing This Page.
    pause
    goto SetBootPriority
)
cls

echo.
echo STOP
echo You are about to edit the list of valid OS files for the Master Boot Record.
echo Modifying this list incorrectly may result in boot failures or system instability.
echo Proceed only if you understand the changes you are making.
echo.
echo Do You Want To Continue?
choice /c YN /n /m "(Y/N): "
set "choice=%errorlevel%"
if %choice% neq 1 goto SetBoot0
echo Are You Sure You Want To Continue?
choice /c YN /n /m "(Y/N): "
set "choice=%errorlevel%"
if %choice% neq 1 goto SetBoot0
goto SetBoot023
:SetBoot023
cls
echo.
echo Current List:
type validOSFiles.txt
echo.
echo.
echo WARNING: The list of valid OS files must follow the correct format.
echo Each OS filename should be separated by a single space.
echo Example: OperatingSystem.bat OperatingSystem1.bat OperatingSystem3.bat
echo Incorrect formatting may cause boot failures.
echo.
echo.
echo Enter Valid OS Files.
set /p VALIDOSFILES="> "
echo.
echo %VALIDOSFILES%
echo.
echo Is This Correct?
choice /c YN /n /m "(Y/N): "
set "choice=%errorlevel%"
if %choice% neq 1 goto SetBoot023
echo %VALIDOSFILES%> validOSFiles.txt
goto SetBoot02

:SetBootdev3
cls
echo  Set Boot Device For CD/DVD (Current: %bootdev.CD/DVD%):
echo.
set /p bootdev.CD/DVD="> "
goto SetBoot0

:SetBootdev2
cls
echo  Set Boot Device For USB (Current: %bootdev.USB%):
echo.
set /p bootdev.USB="> "
goto SetBoot0

:SetBootdev1
cls
echo  Set Boot Device For HDD (Current: %bootdev.HDD%):
echo.
set /p bootdev.HDD="> "
goto SetBoot0

:: --- Set 1st Boot Device ---
:SetBoot1
cls
echo  Choose 1st Boot Device:
echo    [1] HDD
echo    [2] USB
echo    [3] CD/DVD
echo    [4] Network
echo.
choice /c 1234 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 4 set "boot.priority1=Network" & goto SetBootPriority
if %choice%== 3 set "boot.priority1=CD/DVD"  & goto SetBootPriority
if %choice%== 2 set "boot.priority1=USB"     & goto SetBootPriority
if %choice%== 1 set "boot.priority1=HDD"     & goto SetBootPriority
goto SetBootPriority

:: --- Set 2nd Boot Device ---
:SetBoot2
cls
echo  Choose 2nd Boot Device:
echo    [1] HDD
echo    [2] USB
echo    [3] CD/DVD
echo    [4] Network
echo.
choice /c 1234 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 4 set "boot.priority2=Network" & goto SetBootPriority
if %choice%== 3 set "boot.priority2=CD/DVD"  & goto SetBootPriority
if %choice%== 2 set "boot.priority2=USB"     & goto SetBootPriority
if %choice%== 1 set "boot.priority2=HDD"     & goto SetBootPriority
goto SetBootPriority

:: --- Set 3rd Boot Device ---
:SetBoot3
cls
echo  Choose 3rd Boot Device:
echo    [1] HDD
echo    [2] USB
echo    [3] CD/DVD
echo    [4] Network
echo.
choice /c 1234 /n /m "Select an option: "
set "choice=%errorlevel%"

if %choice%== 4 set "boot.priority3=Network" & goto SetBootPriority
if %choice%== 3 set "boot.priority3=CD/DVD"  & goto SetBootPriority
if %choice%== 2 set "boot.priority3=USB"     & goto SetBootPriority
if %choice%== 1 set "boot.priority3=HDD"     & goto SetBootPriority
goto SetBootPriority

:saveat
set bios.antiTheft=ENABLED
set "ASSET_TAG=A%RANDOM%S%RANDOM%S%RANDOM%E%RANDOM%T"
set "bios.assetid=%ASSET_TAG%"
for %%F in (*.bat) do (
    echo.>> "%%F"
    echo ASSETTAG=!ASSET_TAG!>> "%%F"
    echo ANTITHEFTENABLED88927>> "%%F"
)
echo Antitheft for %USERNAME%> "%SECURITY_MARKER%"
echo Anti-Theft enabled with Asset Tag: !ASSET_TAG!
pause
exit /b

:SaveAndExit
if %bios.antiTheft2%==SetFIRST call :saveat
call :WriteSettings
timeout /t 1 /nobreak >nul
cls
echo  Saving settings to CMOS
echo  Settings saved successfully!
echo.
echo  Press any key to exit...
pause >nul
color 07
exit /b


:: ----------------------------
:: 6. Exit Without Saving
:: ----------------------------
:ExitNoSave
cls
echo  Exiting without saving changes...
echo.
echo  Press any key to exit...
pause >nul
for /f "usebackq tokens=1,* delims==" %%A in ("settings.ini") do (
    if /i "%%A"=="bios.date"       set "bios.date=%%B"
    if /i "%%A"=="bios.time"       set "bios.time=%%B"
    if /i "%%A"=="bootdev.HDD"     set "bootdev.HDD=%%B"
    if /i "%%A"=="bootdev.USB"     set "bootdev.USB=%%B"
    if /i "%%A"=="bootdev.CD/DVD"  set "bootdev.CD/DVD=%%B"
    if /i "%%A"=="boot.priority1"  set "boot.priority1=%%B"
    if /i "%%A"=="boot.priority2"  set "boot.priority2=%%B"
    if /i "%%A"=="boot.priority3"  set "boot.priority3=%%B"
    if /i "%%A"=="bios.mboot"      set "bios.mboot=%%B"
    if /i "%%A"=="bios.safety"     set "bios.safety=%%B"
    if /i "%%A"=="bios.POST"       set "bios.POST=%%B"
    if /i "%%A"=="bios.antiTheft"  set "bios.antiTheft=%%B"
    if /i "%%A"=="bios.assetid"    set "bios.assetid=%%B"
)
color 07
exit /b

:: ---------------------------------------------------------
:: Function: ReadSettings
:: Reads settings from settings.ini if it exists
:: ---------------------------------------------------------
:ReadSettings
if not exist settings.ini (
    echo Creating default settings.ini ...
    set "bios.date=2000-01-01"
    set "bios.time=00:00:00"
    set "bootdev.HDD=OperatingSystem.bat"
    set "bootdev.USB=Varset.bat"
    set "bootdev.CD/DVD=GamesSys32.bat"
    set "boot.priority1=USB"
    set "boot.priority2=HDD"
    set "boot.priority3=CD/DVD"
    set "bios.mboot=AUTO"
    set "bios.safety=ENABLED"
    set "bios.POST=ENABLED"
    set "bios.antiTheft=DISABLED"
    set "bios.assetid=UNDEFINED"
    call :WriteSettings
    goto :EOF
)



for /f "usebackq tokens=1,* delims==" %%A in ("settings.ini") do (
    if /i "%%A"=="bios.date"       set "bios.date=%%B"
    if /i "%%A"=="bios.time"       set "bios.time=%%B"
    if /i "%%A"=="bootdev.HDD"     set "bootdev.HDD=%%B"
    if /i "%%A"=="bootdev.USB"     set "bootdev.USB=%%B"
    if /i "%%A"=="bootdev.CD/DVD"  set "bootdev.CD/DVD=%%B"
    if /i "%%A"=="boot.priority1"  set "boot.priority1=%%B"
    if /i "%%A"=="boot.priority2"  set "boot.priority2=%%B"
    if /i "%%A"=="boot.priority3"  set "boot.priority3=%%B"
    if /i "%%A"=="bios.mboot"      set "bios.mboot=%%B"
    if /i "%%A"=="bios.safety"     set "bios.safety=%%B"
    if /i "%%A"=="bios.POST"       set "bios.POST=%%B"
    if /i "%%A"=="bios.antiTheft"  set "bios.antiTheft=%%B"
    if /i "%%A"=="bios.assetid"    set "bios.assetid=%%B"
)


if not defined bios.date (
    goto CorruptedBIOS
)
if not defined bios.time (
    goto CorruptedBIOS
)
if not defined boot.priority3 (
    goto CorruptedBIOS
)
if not defined boot.priority2 (
    goto CorruptedBIOS
)
if not defined boot.priority1 (
    goto CorruptedBIOS
)
if not defined bootdev.HDD (
    goto CorruptedBIOS
)
if not defined bootdev.USB (
    goto CorruptedBIOS
)
if not defined bootdev.CD/DVD (
    goto CorruptedBIOS
)
if not defined bios.mboot (
    goto CorruptedBIOS
)
if not defined bios.safety (
    goto CorruptedBIOS
)


if "%bios.time%" neq "00:00:00" (
echo Old Time: %bios.time%
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set hour=%datetime:~8,2%
set minute=%datetime:~10,2%
set second=%datetime:~12,2%
set "bios.time=%hour%:%minute%:%second%"
echo New Time: %bios.time%
echo.
echo Old Date: %bios.date%
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set "bios.date=%year%-%month%-%day%"
echo New Date: %bios.date%
echo.
echo.
)
call :WriteSettings
exit /b


:WriteSettings
cls
(
    echo bios.date=%bios.date%
    echo bios.time=%bios.time%
    echo bootdev.HDD=%bootdev.HDD%
    echo bootdev.USB=%bootdev.USB%
    echo bootdev.CD/DVD=%bootdev.CD/DVD%
    echo boot.priority1=%boot.priority1%
    echo boot.priority2=%boot.priority2%
    echo boot.priority3=%boot.priority3%
    echo bios.mboot=%bios.mboot%
    echo bios.safety=%bios.safety%
    echo bios.POST=%bios.POST%
    echo bios.antiTheft=%bios.antiTheft%
    echo bios.assetid=%bios.assetid%
) > settings.ini
exit /b

:LoadDefaults
set "bios.date=2000-01-01"
set "bios.time=00:00:00"
set "bootdev.HDD=OperatingSystem.bat"
set "bootdev.USB=Varset.bat"
set "bootdev.CD/DVD=GamesSys32.bat"
set "boot.priority1=USB"
set "boot.priority2=HDD"
set "boot.priority3=CD/DVD"
set "bios.mboot=AUTO"
set "bios.safety=ENABLED"
set "bios.POST=ENABLED"
set "bios.antiTheft=DISABLED"
set "bios.assetid=UNDEFINED"
call :WriteSettings
echo.
echo Defaults Loaded
pause
exit /b

:SystemInfo
cls
echo ==============================================
echo                BIOS INFORMATION              
echo ==============================================
echo.

:: Get BIOS Version
for /f "skip=1 delims=" %%A in ('wmic bios get SMBIOSBIOSVersion ^| findstr /R /V "^$"') do echo BIOS Version:       %%A

:: Get Service Tag
for /f "skip=1 delims=" %%A in ('wmic csproduct get IdentifyingNumber ^| findstr /R /V "^$"') do echo Service Tag:      %%A

:: Get Asset Tag
for /f "skip=1 delims=" %%A in ('wmic systemenclosure get SerialNumber ^| findstr /R /V "^$"') do echo Asset Tag:        %%A

:: Get Manufacturing Date (Formatted)
for /f "skip=1 delims=" %%A in ('wmic bios get ReleaseDate ^| findstr /R /V "^$"') do set rawDate=%%A
set MFG_Date=%rawDate:~0,4%-%rawDate:~4,2%-%rawDate:~6,2%
echo MFG Date:         %MFG_Date%

:: Get Ownership Date (Using OS Install Date as Approximation, Formatted)
for /f "skip=1 delims=" %%A in ('wmic os get InstallDate ^| findstr /R /V "^$"') do set rawDate=%%A
set Ownership_Date=%rawDate:~0,4%-%rawDate:~4,2%-%rawDate:~6,2%
echo Ownership Date:    %Ownership_Date%

:: Get Express Service Code (UUID as Approximation)
for /f "skip=1 delims=" %%A in ('wmic csproduct get UUID ^| findstr /R /V "^$"') do echo Express Service Code: %%A

echo.
echo ----------------------------------------------
echo                SYSTEM INFORMATION            
echo ----------------------------------------------

:: Use PowerShell to calculate Installed Memory correctly
for /f %%A in ('powershell -command "[math]::round((Get-WmiObject Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB, 0)"') do set InstalledMemory=%%A
echo Installed Memory:  %InstalledMemory% GB

:: Get Processor Name
for /f "skip=1 delims=" %%A in ('wmic cpu get Name ^| findstr /R /V "^$"') do echo Processor Name:    %%A

echo ==============================================
pause
goto MainMenu

:CorruptedBIOS
cls
echo ======================================================
echo                CORRUPTED BIOS ERROR!
echo.
echo   One or more BIOS settings are missing or invalid.
echo   The system BIOS appears to be corrupted.
echo   Please restore your BIOS settings from a backup.
echo ======================================================
echo.
pause
del settings.ini

exit /b 1

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

