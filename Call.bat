::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
setlocal enabledelayedexpansion

:: Initialize IDE Directory
set "GameIDE=%USERPROFILE%\BatchGameIDE"
set "GameFolder=%GameIDE%\Games"
if not exist "%GameFolder%" mkdir "%GameFolder%"

:startscreen
cls
echo.
echo Pick what color is best for you.
echo.
echo 1 - Green
echo 2 - Yellow
echo 3 - White
echo 4 - Blue
echo 5 - Gray
echo 6 - CONTINUE
echo.
echo 7 - Exit
set /p "option=Enter your choice (1-7): "

if "%option%"=="1" color 0A
if "%option%"=="2" color 06
if "%option%"=="3" color 0F
if "%option%"=="4" color 09
if "%option%"=="5" color 87
if "%option%"=="6" goto mainmenu
if "%option%"=="7" exit /b
goto startscreen

:mainmenu
cls
echo =============================
echo      Batch Game IDE
echo =============================
echo 1) Create New Game
echo 2) Edit Game
echo 3) Test Game
echo 4) Deploy Game
echo 5) Exit
choice /c 12345 /m "Select an option: "

if %errorlevel% equ 1 goto create_game
if %errorlevel% equ 2 goto edit_game
if %errorlevel% equ 3 goto test_game
if %errorlevel% equ 4 goto deploy_game
if %errorlevel% equ 5 exit /b

goto mainmenu

:create_game
cls
echo Enter game name (without extension):
set /p gamename=
if exist "%GameFolder%\%gamename%.cmd" (
    echo Game already exists!
    pause
    goto mainmenu
)
echo @echo off > "%GameFolder%\%gamename%.cmd"
echo echo Welcome to %gamename%! >> "%GameFolder%\%gamename%.cmd"
echo pause >> "%GameFolder%\%gamename%.cmd"
echo Game created successfully!
pause
goto mainmenu

:edit_game
cls
echo Available Games:
dir /B "%GameFolder%\*.cmd"
echo.
echo Enter game name to edit (without extension):
set /p gamename=
if not exist "%GameFolder%\%gamename%.cmd" (
    echo Game not found!
    pause
    goto mainmenu
)
notepad "%GameFolder%\%gamename%.cmd"
goto mainmenu

:test_game
cls
echo Available Games:
dir /B "%GameFolder%\*.cmd"
echo.
echo Enter game name to test (without extension):
set /p gamename=
if not exist "%GameFolder%\%gamename%.cmd" (
    echo Game not found!
    pause
    goto mainmenu
)
call "%GameFolder%\%gamename%.cmd"
pause
goto mainmenu

:deploy_game
cls
echo Available Games:
dir /B "%GameFolder%\*.cmd"
echo.
echo Enter game name to deploy (without extension):
set /p gamename=
if not exist "%GameFolder%\%gamename%.cmd" (
    echo Game not found!
    pause
    goto mainmenu
)
ren "%GameFolder%\%gamename%.cmd" "%gamename%.game"
echo Game deployed as %gamename%.game
pause
goto mainmenu


