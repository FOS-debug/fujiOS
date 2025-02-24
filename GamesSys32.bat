@echo off
setlocal enabledelayedexpansion 

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
timeout /t 5 /nobreak >nul

call :Initialize_Apps2
< %Appfolder%\%pkgName%.ini (
  set /p AppName=
  set /p UID=
  set /p AppGenre=
  set /p Developer=
  set /p var2=
  set /p var3=
  set /p var4=
  set /p var5=
  set /p var6=
  set /p var7=
  set /p var8=
  set /p var9=
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
echo Downloading %pkgName% from %downloadURL%...
curl -L -o -s "%downloadFolder%\%pkgName%.APPCONFIG" "%downloadURL%.APPCONFIG" >nul
curl -L -o -s "%downloadFolder%\%pkgName%.APP" "%downloadURL%.APP" >nul
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
< %Appfolder%\%pkgName%.ini (
  set /p AppName=
  set /p UID=
  set /p AppGenre=
  set /p Developer=
  set /p var2=
  set /p var3=
  set /p var4=
  set /p var5=
  set /p var6=
  set /p var7=
  set /p var8=
  set /p var9=
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
    echo.
    choice /c yn /n /m "Confirm disabling safety warnings? [Y/N] "
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
