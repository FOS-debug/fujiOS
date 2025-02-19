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
set "Appfolder=%USERPROFILE%\Applications"
if not exist "%Appfolder%" mkdir "%Appfolder%"

move *.APP "%Appfolder%" >nul 2>&1
FOR /R "%Appfolder%" %%f IN (*.APP) DO (
    ren "%%f" *.cmd
)
move *.APPCONFIG "%Appfolder%" >nul 2>&1
FOR /R "%Appfolder%" %%f IN (*.APPCONFIG) DO (
    ren "%%f" *.ini
)

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
echo [1] Installed FujiAPPs
echo [2] Settings
echo [3] Manage FujiAPPs
echo [4] Quit FujiAPPs Store
echo.
choice /c 12345 /n /m "> "
if %ERRORLEVEL% == 1 goto store_installed
if %ERRORLEVEL% == 2 goto store_settings
if %ERRORLEVEL% == 3 goto store_manage
if %ERRORLEVEL% == 4 goto store_quit

:store_quit
cls
echo.
echo Quitting FujiAPPs Store...
ping localhost -n 2 >nul
exit /b

:store_manage
cls
echo Installed Apps:
echo.

setlocal enabledelayedexpansion
set "index=0"

rem Loop through the .cmd files and number them
for %%F in ("%Appfolder%\*.cmd") do (
    set /a index+=1
    set "app[!index!]=%%~nF"
    echo [!index!] %%~nF
)

echo.
set /p choice="Del> "

rem Validate input
if not defined app[%choice%] (
    echo Invalid Number!
    pause
    goto store_splashscreen
)
set "APPLICATIONDEL=!app[%choice%]!"

choice /c yn /n /m "%APPLICATIONDEL%.cmd, Delete (Y/N)? "
if %errorlevel% neq 1 goto store_splashscreen
del /f %Appfolder%\%APPLICATIONDEL%.cmd
del /f %Appfolder%\%APPLICATIONDEL%.ini
echo Deleted %APPLICATIONDEL%.cmd
pause
goto store_splashscreen

:store_installed
cls
echo Installed Apps:
echo.

setlocal enabledelayedexpansion
set "index=0"

rem Loop through the .cmd files and number them
for %%F in ("%Appfolder%\*.cmd") do (
    set /a index+=1
    set "app[!index!]=%%~nF"
    echo [!index!] %%~nF
)
if %index% == 0 (
    cls
    echo.
    echo.
    echo *cricket sounds*...
    timeout /t 3 /nobreak >nul
    echo.
    echo "You know, its a little lonely. Maybe its time to go download some apps?"
    echo.
    echo.
    timeout /t 3 /nobreak >nul
    pause
    goto store_splashscreen
)
echo.
set /p choice="Run> "

rem Validate input
if not defined app[%choice%] (
    echo Invalid Number!
    pause
    goto store_splashscreen
)

set "APPLICATION=!app[%choice%]!"

< %Appfolder%\%APPLICATION%.ini (
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

if not exist %Appfolder%\%APPLICATION%.ini (
    echo [31mWARNING:[33m There Is No Data Associated With This Application.
    echo This App May Be A Virus Or It Might Not Even Be A
    echo Valid FujiOS Application.
    echo.
    echo Please Carefully Review The App Before You Continue
    echo.
    pause [97m
    cls
) else (
    echo App Info:
    echo      Name: %AppName% [%UID%]
    echo     Genre: %AppGenre%
    echo Developer: %Developer%

)

echo.
if "%SafetyWarning%"=="Yes" (

    echo [33mWARNING: Are you sure you want to open this app?
    echo If this is a malicious app, it could harm your PC.[97m
    choice /c yn /n /m "Proceed? [Y/N] "
    if errorlevel 2 goto store_splashscreen
)
goto start_app

:start_app
cls
call "%Appfolder%\%APPLICATION%.cmd"
cls
echo %APPLICATION% has ended.
echo.
pause
goto store_splashscreen

:store_settings
cls
echo.
echo FujiAPPs Store Settings:
echo.
echo [1] Toggle Safety Warning (Currently: %SafetyWarning%)
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
    set "SafetyWarning=No"
    echo Safety Warning disabled.
) else (
    set "SafetyWarning=Yes"
    echo Safety Warning enabled.
)
pause
goto store_settings

