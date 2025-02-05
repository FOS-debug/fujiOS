@echo off
setlocal enabledelayedexpansion 
:InitializeGames
set "Score=0"
set "Score2=0"
set "var1=0"
set "var2=0"
set "var3=0"
set "var4=0"
set "var5=0"
set "var6=0"
set "SupportGame=Unknown"
set "Gamefolder=%USERPROFILE%\FujiGames"
if not exist "%Gamefolder%" mkdir "%Gamefolder%"
move *.Game %Gamefolder%
FOR /R "%Gamefolder%" %%f IN (*.Game) DO REN "%%f" *.cmd
:startoptions
cls
echo.
echo Save Game Details
echo.
echo Score2: %Score2%
echo Score: %Score%
echo var1: %var1%
echo var2: %var2%
echo var3: %var3%
echo var4: %var4%
echo var5: %var5%
echo var6: %var6%
echo Supported Game: %SupportGame%
echo.
echo.
echo.
echo.
echo.
echo Start Options
echo.
echo 1) Start game
echo 2) Load slot
echo 3) Save slot 
echo 4) Return
echo.
echo.
choice /c 1234
   
if %errorlevel% equ 1 (
    goto newgame
)
if %errorlevel% equ 2 (
    goto GameSlots2
)
if %errorlevel% equ 3 (
    goto GameSlots
)
if %errorlevel% equ 4 (
    exit /b
)






:GameSlots
set "SLOTNUM="
cls
echo     Save Game slots
echo.
echo 1) Slot 1
echo 2) Slot 2
echo 3) Slot 3
echo 4) Back
echo.
echo Select the slot you want to update, remember that this
echo feature is still in a BETA state and might not work properly,
echo expect data losses or corruptions.
echo.
choice /c 1234 /m "Which slot are you UPDATING? "
if %errorlevel% equ 1 (
    set SLOTNUM=SLOT1
    goto Update
)
if %errorlevel% equ 2 (
    set SLOTNUM=SLOT2
    goto Update
)
if %errorlevel% equ 3 (
    set SLOTNUM=SLOT3
    goto Update
)
if %errorlevel% equ 4 (
    goto startoptions
)

goto startoptions




:Update

(
  echo %Score%
  echo %Score2%
  echo %var1%
  echo %var2%
  echo %var3%
  echo %var4%
  echo %var5%
  echo %var6%
  echo %INPUT%
) > %SLOTNUM%.ini

echo. 
echo %SLOTNUM% Updated
pause
goto GameSlots

:GameSlots2
set "SLOTNUM="
cls
echo     Load Game slots
echo.
echo 1) Slot 1
echo 2) Slot 2
echo 3) Slot 3
echo 4) Back
echo.
echo Select the slot you want to load.
echo.
choice /c 1234 /m "Which slot are you loading? "
if %errorlevel% equ 1 (
    set SLOTNUM=SLOT1
    goto Load
)
if %errorlevel% equ 2 (
    set SLOTNUM=SLOT2
    goto Load
)
if %errorlevel% equ 3 (
    set SLOTNUM=SLOT3
    goto Load
)
if %errorlevel% equ 4 (
    goto startoptions
)

goto startoptions

:Load
< %SLOTNUM%.ini (
  set /p Score=
  set /p Score2=
  set /p var1=
  set /p var2=
  set /p var3=
  set /p var4=
  set /p var5=
  set /p var6=
  set /p SupportGame=
)
echo. 
echo %SLOTNUM% Loaded
pause
goto GameSlots2




:newgame
cls
echo Game Station-S
echo.
dir /O /B %Gamefolder%
echo.
set /p INPUT=Enter Game: 
:: Run the selected .Game file and check for errors
echo Running %INPUT%
echo.
echo.
call %Gamefolder%\%INPUT% (
    echo.
    echo.
    echo Error: Failed to execute %INPUT%.
    pause
    goto startoptions
)
goto startoptions




