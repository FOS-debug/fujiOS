
@echo off
cls
setlocal enabledelayedexpansion
echo Booting Integrated Development Environment . . .
timeout /t 5 /nobreak >nul
:: Initialize IDE Directory
:RESTART
set "Appfolder=%USERPROFILE%\IDEApplications"
if not exist "%Appfolder%" mkdir "%Appfolder%"

if not exist "%Appfolder%\User.pkg" goto Usercreate
if exist "%Appfolder%\User.pkg" set /p DEVUSERNAME=<%Appfolder%\User.pkg

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
if "%option%"=="6" goto realmainmenu
if "%option%"=="7" exit /b
goto startscreen

:realmainmenu
cls
echo =============================
echo      FOS Application IDE
echo =============================
echo Select One:
echo.
echo 1) Create New App
echo 2) Select App
choice /c 12 /m "Select an option: "

if %errorlevel% equ 1 goto create_App
if %errorlevel% equ 2 goto Select_App
goto realmainmenu

:Select_App
cls
echo Available apps:
dir /B "%Appfolder%\*.cmd"
echo.
echo Enter app name to select:
set /p MYAPPLICATIONSELECT=
if not exist "%Appfolder%\%MYAPPLICATIONSELECT%.cmd" (
    echo App not found!
    pause
    goto realmainmenu
)
goto mainmenu

:mainmenu
< %Appfolder%\%MYAPPLICATIONSELECT%.ini (
  set /p AppName=
  set /p UID=
  set /p AppGenre=
  set /p AUTHOR=
)
cls
echo =============================
echo      FOS Application IDE
echo =============================
echo APP DETAILS:
echo App Name:       %AppName%
echo Universal ID:   %UID%
echo Genre:          %AppGenre%
echo.
echo 1) Edit App
echo 2) Test App
echo 3) Deploy App
echo 4) Back
echo 5) Exit
choice /c 12345 /m "Select an option: "

if %errorlevel% equ 1 goto edit_App
if %errorlevel% equ 2 goto test_App
if %errorlevel% equ 3 goto deploy_App
if %errorlevel% equ 4 goto realmainmenu
if %errorlevel% equ 5 exit /b

goto mainmenu

:create_App
cls
echo NOTICE: USE UNDERSCORES NOT SPACES
echo.
echo Enter The Name Of The App You Are Making:
set /p AppName=
echo.
echo Select The Genre Of The App You Are Making:
echo 1. Gaming
echo 2. Finance
echo 3. LifeStyle
echo 4. Social Networking
echo 5. Ecommerce
echo 6. Dev Tools
echo 7. Education
echo 8. Utilities
echo 9. Shopping
echo 10. No Genre


set /p GenreChoice=Choose a number (1-10) :
echo.

if "%GenreChoice%"=="1" (
    set AppGenre=Gaming
    goto CONfIRMATION
)
if "%GenreChoice%"=="2" (
    set AppGenre=Finance
    goto CONfIRMATION
)
if "%GenreChoice%"=="3" (
    set AppGenre=LifeStyle
    goto CONfIRMATION
)
if "%GenreChoice%"=="4" (
    set AppGenre=Social Networking
    goto CONfIRMATION
)
if "%GenreChoice%"=="5" (
    set AppGenre=Ecommerce
    goto CONfIRMATION
)
if "%GenreChoice%"=="6" (
    set AppGenre=Dev Tools
    goto CONfIRMATION
)
if "%GenreChoice%"=="7" (
    set AppGenre=Education
    goto CONfIRMATION
)
if "%GenreChoice%"=="8" (
    set AppGenre=Utilities
    goto CONfIRMATION
)
if "%GenreChoice%"=="9" (
    set AppGenre=Shopping
    goto CONfIRMATION
)

set AppGenre=N/A 
goto CONfIRMATION

:CONfIRMATION
cls
echo.
echo.
echo.
echo App Name: %AppName%
echo App Genre: %AppGenre%
echo.
timeout /t 5 /nobreak >nul
echo Is This Info Correct?
choice /c yn /n /m "(Y/N) "
if %errorlevel% equ 2 goto create_App
echo %AppName%> %Appfolder%\%AppName%.ini
set "AppUID=%RANDOM%%RANDOM%%RANDOM%"
echo %AppUID%>> %Appfolder%\%AppName%.ini
echo %AppGenre%>> %Appfolder%\%AppName%.ini
echo %DEVUSERNAME%>> %Appfolder%\%AppName%.ini
echo @echo off> %Appfolder%\%AppName%.cmd
timeout /t 2 /nobreak >nul
echo App created successfully!
pause
goto realmainmenu


:edit_App
cls
if not exist "%Appfolder%\%MYAPPLICATIONSELECT%.cmd" (
    echo App not found!
    pause
    goto mainmenu
)
notepad "%Appfolder%\%MYAPPLICATIONSELECT%.cmd"
goto mainmenu


:deploy_App
cls
if not exist "%Appfolder%\%MYAPPLICATIONSELECT%.cmd" (
    echo App not found!
    pause
    goto mainmenu
)
ren "%Appfolder%\%MYAPPLICATIONSELECT%.cmd" "%MYAPPLICATIONSELECT%.APP"
ren "%Appfolder%\%MYAPPLICATIONSELECT%.ini" "%MYAPPLICATIONSELECT%.APPCONFIG"
set "DEST_FOLDER=SharePrograms"
if not exist "%DEST_FOLDER%" mkdir "%DEST_FOLDER%"
copy "%Appfolder%\%MYAPPLICATIONSELECT%.APPCONFIG" "%DEST_FOLDER%" /Y
copy "%Appfolder%\%MYAPPLICATIONSELECT%.APP" "%DEST_FOLDER%" /Y
cls
echo.
echo App deployed as %MYAPPLICATIONSELECT%.APP
echo.
echo A copy of your app is ready in SharePrograms. Make sure to share it with your friends.
echo.
echo.
pause
goto mainmenu

:Usercreate
cls
echo Please create a username. You will not be able to change this later.
echo This username will show up on all apps you develop.
echo.
echo USERNAME:
set /p DEVUSERNAME="> "
echo.
echo CONFIRM USERNAME:
set /p "option=> "
if %option% neq %DEVUSERNAME% goto CREATEUSERNAME
echo.
echo Your username is "%DEVUSERNAME%"
echo Make sure this is correct, as it cannot be changed later.
echo If it is incorrect please exit this script now and restart.
timeout /t 5 /nobreak >nul
echo.
echo %DEVUSERNAME%> %Appfolder%\User.pkg
pause
goto RESTART

:test_App
cls
if not exist "%Appfolder%\%MYAPPLICATIONSELECT%.cmd" (
    echo App not found!
    pause
    goto mainmenu
)
call "%Appfolder%\%MYAPPLICATIONSELECT%.cmd"
pause
goto mainmenu