@echo off
setlocal enabledelayedexpansion 
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

:: Initialize default setting for safety warning if not already set

< Store_Settings.ini (
  set /p SafetyWarning=
  set /p Theme=
  set /p BACKGROUNDCOLOR=
  set /p FOREGROUNDCOLOR=
  set /p LastSaved=
)

if not defined LastSaved set "LastSaved=NEVER"
if not defined SafetyWarning set "SafetyWarning=Yes"
if not defined Theme (
    set "Theme=Dark"
)
:InitializeFolders
:: Define Applications folder and FujiAPPs Store folder
set "manifestFile=manifest.txt"
set "manifestURL=https://fos-debug.github.io/Packages/%manifestFile%"
set "downloadFolder=%cd%"
set "Appfolder=%USERPROFILE%\Applications"

if not exist "%Appfolder%" mkdir "%Appfolder%"
call :Initialize_Apps

:store_splashscreen
< Store_Settings.ini (
  set /p SafetyWarning=
  set /p Theme=
  set /p BACKGROUNDCOLOR=
  set /p FOREGROUNDCOLOR=
  set /p LastSaved=
)

if "%Theme%" == "Custom" (
    color %BACKGROUNDCOLOR%%FOREGROUNDCOLOR% 
)
if "%Theme%" == "Dark" (
    color 0F
)
if "%Theme%" == "Light" (
    color F0
)
cls
echo.
echo ------------------------------------------------------------------------------    _____ __ version: %VERSION2%
echo                                                                                  / ___// /_____  ________ 
echo Welcome to the FujiAPPs Store.                                         FujiAPPs  \__ \/ __/ __ \/ ___/ _ \
echo Here, you can install third party apps!                                          ___/ / /_/ /_/ / /  /  __/
echo                                                                                /____/\__/\____/_/   \___/ 
echo ------------------------------------------------------------------------------
echo. 
echo.
echo Welcome to the main menu. Pick one item.
echo.
echo Options:
echo [1] Application Manager
echo [2] Settings
echo [3] Quit FujiAPPs Store
echo.
choice /c 12345 /n /m "> "
if %ERRORLEVEL% == 1 goto store_manage
if %ERRORLEVEL% == 2 goto store_settings
if %ERRORLEVEL% == 3 goto store_quit

:store_quit
cls
echo.
echo Quitting FujiAPPs Store...
ping localhost -n 2 >nul
exit /b


:store_manage
< Store_Settings.ini (
  set /p SafetyWarning=
  set /p Theme=
  set /p BACKGROUNDCOLOR=
  set /p FOREGROUNDCOLOR=
  set /p LastSaved=
)

if "%Theme%" == "Custom" (
    color %BACKGROUNDCOLOR%%FOREGROUNDCOLOR% 
)
if "%Theme%" == "Dark" (
    color 0F
)
if "%Theme%" == "Light" (
    color F0
)
cls
echo =====================================
echo       FujiOS Package Manager
echo =====================================
echo.
echo Downloading package manifest...
echo.
curl -s -o  "%manifestFile%" "%manifestURL%"
if errorlevel 1 (
    echo WARNING
    echo Error downloading manifest file. Functionality Is Limited.
    echo.
    pause
)

cls
echo =====================================
echo         Available Packages
echo =====================================
echo.
:: List all available packages from the manifest file
:: (Each line in the manifest should be in the format: PackageName|DownloadURL)
for /f "tokens=1,2 delims=|" %%A in (%manifestFile%) do (
    echo  %%A
)
echo.
echo =====================================
echo         Installed Packages
echo =====================================
echo.
for %%f in ("%Appfolder%\*.cmd") do echo %%~nf
echo.
echo =====================================
echo.
echo Enter package name (or type 'back' to go back):
set /p pkgName="> "
if /i "%pkgName%"=="Back" goto store_splashscreen
if /i "%pkgName%"=="back" goto store_splashscreen
if /i "%pkgName%"=="BACK" goto store_splashscreen
if /i "%pkgName%"=="Bakc" goto store_splashscreen
if /i "%pkgName%"=="bakc" goto store_splashscreen
if /i "%pkgName%"=="BAKC" goto store_splashscreen

:: Check if the package is already installed by testing for its .cmd file.
if exist "%Appfolder%\%pkgName%.cmd" (
    echo.
    echo Package "%pkgName%" is already installed.
    echo.
    echo [U] Uninstall  [R] Reinstall  [S] Start  [B] Back
    choice /c URSB /m "Choose an option: "
    if errorlevel 4 goto store_manage
    if errorlevel 3 goto runPackage
    if errorlevel 2 goto reinstallPackage
    if errorlevel 1 goto uninstallPackage
) else (
    echo.
    echo Package "%pkgName%" is not installed.
    echo.
    echo [I] Install  [B] Back
    choice /c IB /m "Choose an option: "
    if errorlevel 2 goto store_manage
    if errorlevel 1 goto installPackage
)

:installPackage
cls
echo Disclaimer:
echo We are not responsible for any third-party applications, 
echo including those listed in the official manifest. These 
echo applications are developed and maintained by independent 
echo entities, and we do not guarantee their safety, 
echo functionality, or compliance with privacy regulations.
echo.
echo Please be aware that third-party applications may collect 
echo and process your user data under their own privacy policies, 
echo which are separate from ours. We strongly recommend reviewing 
echo each applications privacy policy and terms of service before installation.
echo.
echo Additionally, some applications may pose security risks, 
echo including but not limited to malware, data breaches, or 
echo other malicious activities that could harm your device or 
echo compromise your information. By downloading and using any 
echo third-party application, you acknowledge that you do so at 
echo your own risk, and we disclaim any liability for any 
echo damages or issues that may arise.
echo.
echo If you have concerns about an application, we encourage you 
echo to research it thoroughly and use appropriate security measures.
timeout /t 5 /nobreak >nul
pause
cls
echo Installing package: %pkgName%
:: Refresh the manifest to be sure it is up-to-date.
curl -s -o "%manifestFile%" "%manifestURL%" >nul
if errorlevel 1 (
    echo Error downloading manifest file.
    pause
    goto store_manage
)

set "found="
for /f "tokens=1,* delims=|" %%A in (%manifestFile%) do (
    if /i "%%A"=="%pkgName%" (
        set "found=1"
        set "downloadURL=%%B"
    )
)
if not defined found (
    echo Package "%pkgName%" not found in the manifest.
    pause
    goto store_manage
)
echo.
echo Downloading package info for %pkgName% from %downloadURL%...
curl -L -s -o "%downloadFolder%\%pkgName%.APPCONFIG" "%downloadURL%.APPCONFIG" 
if errorlevel 1 (
    echo Error downloading package info.
    pause
    goto store_manage
)
if not exist "%downloadFolder%\%pkgName%.APPCONFIG" (
    echo Error downloading package info.
    pause
    goto store_manage
)
echo Package info for %pkgName% downloaded successfully.
timeout /t 2 /nobreak >nul

set "AppName="
set "UID="
set "AppGenre="
set "Developer="

call :Initialize_Apps2
set "iniFile=%Appfolder%\%pkgName%.ini"

set count=0
for /f "usebackq delims=" %%A in ("%iniFile%") do (
    set /a count+=1
    if !count! equ 1 set "AppName=%%A"
    if !count! equ 2 set "UID=%%A"
    if !count! equ 3 set "AppGenre=%%A"
    if !count! equ 4 set "Developer=%%A"
)

if not defined AppName (
    echo ERROR: AppName is missing or empty.
    pause
)
if not defined UID (
    echo ERROR: UID is missing or empty.
    pause
)
if not defined AppGenre (
    echo ERROR: AppGenre is missing or empty.
    pause
)
if not defined Developer (
    echo ERROR: Developer is missing or empty.
    pause
)
cls
echo.
echo App Info:
echo      Name: %AppName% [%UID%]
echo     Genre: %AppGenre%
echo Developer: %Developer%
echo.
echo [33mWARNING: Are you sure you want this app?
echo If this is a malicious app, it could harm your PC.
echo Only download apps from sources you trust. [97m
echo.
choice /c yn /n /m "[Y/N] "
if errorlevel 2 goto Euninstallpackage
echo Continuing Installation
timeout /t 5 /nobreak >nul
curl -L -s -o "%downloadFolder%\%pkgName%.APP" "%downloadURL%.APP" 
if errorlevel 1 (
    echo Error downloading package.
    pause
    goto store_manage
)
if not exist "%downloadFolder%\%pkgName%.APP" (
    echo Error downloading package.
    pause
    goto store_manage
)
echo %pkgName% downloaded successfully.
timeout /t 5 /nobreak >nul
call :Initialize_Apps
goto store_manage

:Euninstallpackage
cls
echo Removing App Info . . .
echo.
timeout /t 1 /nobreak >nul
del "%Appfolder%\%pkgName%.ini"
goto store_manage

:reinstallPackage
cls
echo Reinstalling package: %pkgName%
if not exist "%Appfolder%\%pkgName%.cmd" (
    echo The package "%pkgName%" is not installed.
    pause
    goto store_manage
)
curl -s -o "%manifestFile%" "%manifestURL%"

if errorlevel 1 (
    echo Error downloading manifest file.
    pause
    goto store_manage
)
set "found="
for /f "tokens=1,* delims=|" %%A in (%manifestFile%) do (
    if /i "%%A"=="%pkgName%" (
        set "found=1"
        set "downloadURL=%%B"
    )
)
if not defined found (
    echo Package "%pkgName%" does not exist in the manifest.
    echo It may no longer be available.
    pause
    goto store_manage
)
:: Remove the installed package and its data.
del "%Appfolder%\%pkgName%.cmd"
echo Package %pkgName% uninstalled (file deleted).
if not exist "%Appfolder%\%pkgName%.ini" (
    echo No data for %pkgName% exists.
    pause
    goto Continue_Reinstalling
) 
del "%Appfolder%\%pkgName%.ini"
echo Package data for %pkgName% uninstalled (file deleted).
:Continue_Reinstalling
echo.
echo Downloading package info for %pkgName% from %downloadURL%...
curl -L -s -o "%downloadFolder%\%pkgName%.APPCONFIG" "%downloadURL%.APPCONFIG" 
timeout /t 5 /nobreak >nul
curl -L -s -o "%downloadFolder%\%pkgName%.APP" "%downloadURL%.APP" 

if errorlevel 1 (
    echo Error downloading package.
    pause
    goto store_manage
)
if not exist "%downloadFolder%\%pkgName%.APP" (
    echo Error downloading package.
    pause
    goto store_manage
)
echo Package %pkgName% downloaded successfully.
pause
call :Initialize_Apps
goto store_manage

:uninstallPackage
cls
echo Uninstalling package: %pkgName%
if not exist "%Appfolder%\%pkgName%.cmd" (
    echo The package "%pkgName%" is not installed.
    pause
    goto store_manage
)
:: Optionally check if package is still in the manifest.
set "found="
for /f "tokens=1,* delims=|" %%A in (%manifestFile%) do (
    if /i "%%A"=="%pkgName%" (
        set "found=1"
        set "downloadURL=%%B"
    )
)
if not defined found (
    cls
    echo.
    echo Package "%pkgName%" is not available in the store.
    echo If it is deleted you might not be able to get it back.
    echo.
    echo Are you sure you want to delete it?
    echo.
    choice /c yn /n /m "Delete? [Y/N] "
    if errorlevel 2 goto store_manage
)
del "%Appfolder%\%pkgName%.cmd"
echo Package %pkgName% uninstalled (file deleted).

if not exist "%Appfolder%\%pkgName%.ini" (
    echo No data for %pkgName% exists.
    pause
)
del "%Appfolder%\%pkgName%.ini"
echo Package data for %pkgName% uninstalled (file deleted).
pause
goto store_manage

:runPackage
cls
set "AppName="
set "UID="
set "AppGenre="
set "Developer="
set "iniFile=%Appfolder%\%pkgName%.ini"

set count=0
for /f "usebackq delims=" %%A in ("%iniFile%") do (
    set /a count+=1
    if !count! equ 1 set "AppName=%%A"
    if !count! equ 2 set "UID=%%A"
    if !count! equ 3 set "AppGenre=%%A"
    if !count! equ 4 set "Developer=%%A"
)

if not defined AppName (
    echo ERROR: AppName is missing or empty.
    pause
)
if not defined UID (
    echo ERROR: UID is missing or empty.
    pause
)
if not defined AppGenre (
    echo ERROR: AppGenre is missing or empty.
    pause
)
if not defined Developer (
    echo ERROR: Developer is missing or empty.
    pause
)
cls
echo. [97m

if not exist %Appfolder%\%pkgName%.ini (
    echo [31mWARNING:[33m There Is No Data Associated With This Application.
    echo This App May Be A Virus Or It Might Not Even Be A
    echo Valid FujiOS Application.
    echo.
    echo Please Carefully Review The App Before You Continue [97m
    echo.
    choice /c yn /n /m "Continue? [Y/N] "
    if errorlevel 2 goto store_splashscreen
    cls
) else (
    echo App Info:
    echo      Name: %AppName% [%UID%]
    echo     Genre: %AppGenre%
    echo Developer: %Developer%

)
echo.
if "%SafetyWarning%"=="Yes" (
    echo.
    echo [33mWARNING: Are you sure you want to open this app?
    echo If this is a malicious app, it could harm your PC.[97m
    choice /c yn /n /m "Proceed? [Y/N] "
    if errorlevel 2 goto store_manage
)
set "riskyCommands=del format erase shutdown rmdir reg delete vssadmin taskkill powershell certutil"

:: Scan for risky commands
set "foundCommands="
for %%C in (%riskyCommands%) do (
    findstr /I /C:"%%C " "%Appfolder%\%pkgName%.cmd" >nul && (
        set "foundCommands=!foundCommands! %%C"
    )
)

:: If risky commands are found, prompt user
if defined foundCommands (
    cls
    echo Safety Warning:
    echo [33mAre you sure you want to run this program?
    echo By clicking Yes you are allowing it to 
    echo execute the following commands:[97m
    echo.

    :: Display the risky commands in a list
    setlocal enabledelayedexpansion
    for %%I in (!foundCommands!) do (
        echo %%I
    )
    echo.

    timeout /t 5 /nobreak >nul
    choice /c yn /n /m "Proceed? [Y/N] "
    if errorlevel 2 goto store_manage
)

goto start_app
:start_app
cls
echo Starting %pkgName% . . .
Timeout /t 2 /nobreak >nul
call %Appfolder%\%pkgName%.cmd
cls
echo %AppName% has ended.
echo.
pause
chcp 65001 > nul
cls

:: Set console size (adjust as needed)
mode con: cols=80 lines=30

:: Enable virtual terminal processing for ANSI escape codes

:: Loop to fill the screen with random numbers and colors
for /L %%y in (1,1,30) do (
    setlocal EnableDelayedExpansion
    set "line="
    for /L %%x in (1,1,80) do (
        set /A "randNum=!random! %% 10"
        set /A "randColor=!random! %% 8 + 30"
        for %%A in (!randNum!) do set "line=!line![!randColor!m%%A "
    )
    echo !line![0m
    endlocal
)

timeout /t 5 /nobreak >nul
goto store_manage

:store_settings
cls
echo.
echo FujiAPPs Store Settings:
echo.
echo [1] Toggle App Safety Warning (Currently: %SafetyWarning%)
echo [2] Theme Settings (Currently: %Theme%)
echo [3] Save Settings (Last Saved: %LastSaved%)
echo [4] Back to Main Menu
echo.
choice /c 1234E /n /m "Choose an option: "
if errorlevel 5 goto store_splashscreen
if errorlevel 4 goto store_splashscreen
if errorlevel 3 goto save_settings
if errorlevel 2 goto theme_settings
if errorlevel 1 goto toggle_safety

:theme_settings
cls
echo.
echo Theme/Appearance Settings:
echo [1] Dark Theme (Black background, white text)
echo [2] Light Theme (White background, black text)
echo [3] Custom Theme
echo [4] Back to Settings Menu
echo.
choice /c 12345 /n /m "Choose a theme option: "
if %ERRORLEVEL%==4 goto store_settings

if %ERRORLEVEL%==1 (
    set "Theme=Dark"
    color 0F
    echo Dark theme applied.
    pause
    goto theme_settings
)

if %ERRORLEVEL%==2 (
    set "Theme=Light"
    color F0
    echo Light theme applied.
    pause
    goto theme_settings
)

if %ERRORLEVEL%==3 (
    set /p BACKGROUND1COLOR="Enter background color code (0-9, A-F): "
    set /p FOREGROUND1COLOR="Enter text color code (0-9, A-F): "
    set "Theme=Custom"
    color %BACKGROUND1COLOR%%FOREGROUND1COLOR%
    echo Custom theme applied.
    pause
    goto theme_settings
)

:save_settings
(
  echo %SafetyWarning%
  echo %Theme%
  echo %BACKGROUND1COLOR%
  echo %FOREGROUND1COLOR%
  echo %DATE%
) > Store_Settings.ini

< Store_Settings.ini (
  set /p SafetyWarning=
  set /p Theme=
  set /p BACKGROUNDCOLOR=
  set /p FOREGROUNDCOLOR=
  set /p LastSaved=
)
echo.
echo Settings Saved Successfully.
pause
goto store_settings

:toggle_safety
if "%SafetyWarning%"=="Yes" (
    echo.
    echo.
    echo [33mWARNING: Disabling safety warnings may expose your system to potential risks.[97m
    echo Are you sure you want to proceed?
    echo We highly recommend against disabling safety warnings.
    echo.
    choice /c yn /n /m "Confirm disabling safety warnings? [Y/N] "
    if errorlevel 2 goto store_settings
    choice /c yn /n /m "Are You Sure? [Y/N] "
    if errorlevel 2 goto store_settings
)



if "%SafetyWarning%"=="Yes" (
    set "SafetyWarning=No"
    echo Safety Warning disabled.
) else (
    set "SafetyWarning=Yes"
    echo Safety Warning enabled.
)
pause
goto store_settings

:Initialize_Apps
move *.APP "%Appfolder%" >nul 2>&1

FOR /R "%Appfolder%" %%f IN (*.APP) DO (
    ren "%%f" *.cmd
)
goto Initialize_Apps2
:Initialize_Apps2
move *.APPCONFIG "%Appfolder%" >nul 2>&1

FOR /R "%Appfolder%" %%f IN (*.APPCONFIG) DO (
    ren "%%f" *.ini
)
exit /b


exit
exit
exit
exit
exit
