::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
setlocal
cls
set "userFolder=%USERPROFILE%\USERdocuments"

REM Ensure the USERdocuments folder exists
if not exist "%userFolder%" mkdir "%userFolder%"
cd %userFolder%
if exist %userFolder%\*.RECOVERY goto Backup
:OGSTART
cls
echo FujiOS Drive System
echo ----------------------------------------
echo Directory of %userFolder%
echo.
dir /O %userFolder%
echo.
echo ----------------------------------------
echo 1. Create Text File
echo 2. Delete Text File
echo 3. Backup Files
echo 4. Exit
echo ----------------------------------------
set /p choice=Enter your choice:

if "%choice%"=="1" goto Start123421
if "%choice%"=="2" goto deleteTextFile
if "%choice%"=="3" goto Backup1232
if "%choice%"=="4" goto exit

goto OGSTART



:deleteTextFile
cls
echo Directory of %userFolder%
echo.
dir /O /B %userFolder%
echo.
echo.
set /p choice=Enter file to delete:
if "%choice%"=="exp_date.txt" goto OGSTART
if "%choice%"=="card_number.txt" goto OGSTART
if "%choice%"=="balance.txt" goto OGSTART
if "%choice%"=="cvv.txt" goto OGSTART
if "%choice%"=="debt.txt" goto OGSTART
cls
echo ----------------------------------------
type %userFolder%\%choice%
echo ----------------------------------------
echo.
timeout /t 2 /nobreak >nul
del /p %userFolder%\%choice%
pause
goto OGSTART



:Start123421
set LINENUM=0 
cls
echo Enter Name Of File To Save (Without File Extension)
set /p File2=">"
set File=%File2%.RECOVERY
cls
:TXT12Start
cls
echo Type In Each Line Of Text Then Press CRTL+C To Save It.
timeout /nobreak /t 3 >nul
echo.
echo.
:TXT
set /a "LINENUM+=1"
set /p command="Line %LINENUM% >"
echo %command% >> %userFolder%\%File%
timeout /nobreak /t 3 >nul
if not "%errorlevel%"=="0" goto End
goto TXT

:End
pause
goto OGSTART

:Backup
cls
echo The Following Files Are Not Backed Up
echo ----------------------------------------
for %%F in ("%userFolder%\*.RECOVERY") do (
    echo %%~nF
)
echo ----------------------------------------
echo.
pause
goto OGSTART

:Backup1232
cls
FOR /R "%userFolder%" %%f IN (*.RECOVERY) DO REN "%%f" *.txt

goto OGSTART

:exit
exit /b
exit /b
exit /b
exit /b
exit /b
exit /b