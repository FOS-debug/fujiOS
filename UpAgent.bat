@echo off
setlocal enabledelayedexpansion
set SERVER_URL=https://fos-debug.github.io/fujiOS
set REMOTE_VERSION_FILE=%SERVER_URL%/Version.txt
set UPDATE_FILE=OperatingSystem.bat
set UPDATER_FILE=UpAgent.bat
set BACKUP_FILE=OperatingSystem.Backup
set OLD_FILE=OperatingSystem.OLD
set OLD_VERSION=Version.OLD
set VERSION_FILE=Version.txt
set /p CURRENT_VERSION=<Version.txt




if exist %BACKUP_FILE% goto UpdatingFailed
echo. >> Update.log
echo ========================================================== >> Update.log
echo    UPDATE SESSION STARTED  DATE: %DATE% TIME: %TIME% >> Update.log
echo ========================================================== >> Update.log
echo. >> Update.log


set "TPE=1"
set "MSG=Testing connection to Google.com"
call :UpdateLog

ping -n 4 google.com >nul

if %errorlevel%==0 (
    set "TPE=1"
    set "MSG=Connection up"
    call :UpdateLog
) else (
    set "TPE=2"
    set "MSG=Connection down. Retrying Later"
    call :UpdateLog
    goto TryAgainLater
)


:StartUpdates
timeout /t 5 /nobreak >nul
:FETCHVERSIONINFO
set /a ATTEMPT+=1

set "TPE=1"
set "MSG=Updating asset information on FOS - Attempt %ATTEMPT%"
call :UpdateLog


if "%ATTEMPT%" geq "6" (
    set "TPE=2"
    set "MSG=Failed to contact Update API, The remote name could not be resolved: '%SERVER_URL%'"
    call :UpdateLog
    goto ERROR
)

:: Fetch remote version info
for /f "delims=" %%A in ('curl -s "%REMOTE_VERSION_FILE%"') do set "REMOTE_VERSION=%%A"

:: Check if we got a valid response
if "%REMOTE_VERSION%"=="" (
    goto FETCHVERSIONINFO
)

set "TPE=1"
set "MSG=Update API returned message - success"
call :UpdateLog

timeout /t 3 /nobreak >nul


set "TPE=1"
set "MSG=Checking for updates"
call :UpdateLog

timeout /t 5 /nobreak >nul

set "TPE=1"
set "MSG=Operating System Running version %CURRENT_VERSION%"
call :UpdateLog

timeout /t 3 /nobreak >nul

set "TPE=1"
set "MSG=Operating System Latest  version %REMOTE_VERSION%"
call :UpdateLog

timeout /t 3 /nobreak >nul

if "%CURRENT_VERSION%" geq "%REMOTE_VERSION%" (
    set "TPE=1"
    set "MSG=No updates found"
    call :UpdateLog
    set "TPE=1"
    set "MSG=Nothing to do, Service running latest version"
    call :UpdateLog
    goto TryAgainLater
) else (
    set "TPE=1"
    set "MSG=Updates found. Starting Updates"
    call :UpdateLog
)


timeout /t 3 /nobreak >nul


echo.
echo New update found! Downloading...
echo [33mDO NOT CLOSE THIS WINDOW[0m
timeout /t 15 /nobreak >nul

if exist %UPDATE_FILE% (
    rename %UPDATE_FILE% %BACKUP_FILE%
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
echo.

setlocal enabledelayedexpansion
set "progress=0"
set "total=100"
set "barwidth=50"

:loop
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
echo [33mUpdating your software...[0m
echo [33mDo not close this window.[0m
echo.
echo.

    set /a increment=%random% %% 3 + 1
    set /a progress=progress + increment
    
    if %progress% gtr %total% set progress=%total%
    
    set /a filled=(progress * barwidth) / total
    set "bar="
    for /L %%i in (1,1,%filled%) do set "bar=!bar!#"
    for /L %%i in (%filled%,1,%barwidth%) do set "bar=!bar! "
    
    echo Flash Progress: !bar! %progress%%%
    set /a pauseTime=%random% %% 4 + 2
    timeout /t %pauseTime% >nul

    if %progress% geq %total% goto end
    goto loop

:end
timeout /t 3 /nobreak >nul
echo.
echo.
:: Download new version
set "TPE=1"
set "MSG=Downloading New Version Files"
call :UpdateLog

curl -s -o UpAgent.cmd %SERVER_URL%/%UPDATER_FILE%
curl -s -o ReAgent.bat %SERVER_URL%/ReAgent.bat
curl -s -o KERNEL32.bat %SERVER_URL%/KERNEL32.bat
curl -s -o %UPDATE_FILE% %SERVER_URL%/%UPDATE_FILE%




:: Verify download success
if not exist %UPDATE_FILE% (
    echo Download failed! Restoring backup...
    set "TPE=2"
    set "MSG=Download Failed, Attempting To Restore Backup"
    call :UpdateLog
    if exist %BACKUP_FILE% (
        rename %BACKUP_FILE% %UPDATE_FILE%
        set "TPE=1"
        set "MSG=Backup Restored"
        call :UpdateLog
    ) else (
        set "TPE=2"
        set "MSG=Unable To Restore Backup"
        call :UpdateLog
        echo Unable To Find Backup File
        pause
        goto ERROR5
    )
    echo Update failed. Please try again later.
    pause
    exit
)
set "TPE=1"
set "MSG=Update Successful"
call :UpdateLog

ren %VERSION_FILE% %OLD_VERSION%
curl -s -o Version.txt %SERVER_URL%/Version.txt


cls
echo.
echo Software Update Complete.
set "TPE=1"
set "MSG=Update Complete"
call :UpdateLog

if exist %OLD_FILE% del %OLD_FILE%
if exist %BACKUP_FILE% ren %BACKUP_FILE% %OLD_FILE%

pause
start cmd /k call OperatingSystem.bat
exit /b

:ERROR5
echo Unable to find Operating System
echo Press Any Key To Start SysRestore
pause >nul
set "TPE=1"
set "MSG=Starting SysRestore"
call :UpdateLog
echo >systemrstore.log
call ReAgent.bat
if not exist %UPDATE_FILE% goto ERROR2
set "TPE=1"
set "MSG=SysRestore Completed Successfully"
call :UpdateLog

echo SYS RESTORE COMPLETED SUCCESSFULLY
echo.
echo PRESS ANY KEY TO RESTART UPDATE
pause >nul
set "TPE=1"
set "MSG=Restarting Update"
call :UpdateLog
start UpAgent.bat
exit

:ERROR2
set "TPE=2"
set "MSG=Critical Update Failure, OS File Missing"
call :UpdateLog

cls
echo ==========================================================
echo ERROR: Operating System Update Failed  
echo ==========================================================
echo An error occurred while updating the Operating System.  
echo During the process, the backup of the OperatingSystem.bat file was deleted.  
echo We attempted to restore the OS to the previous version using a backup,  
echo but the restoration failed.  
echo As a result, the OS update could not be completed, and the  
echo OperatingSystem.bat file is now missing.  
echo.  
echo To resolve this issue, you must manually reinstall the OperatingSystem.bat file.  
echo Please note that other core system files should remain unaffected.  
echo.  
echo Follow these steps to reinstall the OperatingSystem.bat file:  
echo 1. Visit https://fos-debug.github.io/fujiOS/OperatingSystem.bat to  
echo    download the latest version of OperatingSystem.bat.  
echo 2. Place the downloaded file in the current directory.  
echo 3. Restart the OS to complete the installation.  
echo.  
echo ==========================================================
timeout /t 9999 /nobreak >nul
goto ERROR2

:UpdatingFailed
set "TPE=2"
set "MSG=OS Update Not Completed Properly"
call :UpdateLog
set "TPE=1"
set "MSG=Attempting Update Restart"
call :UpdateLog
cls
echo.
echo ==========================================================
echo Your operating system did not finish updating properly.  
echo ==========================================================
echo The system is attempting to restart the update process.
echo Please wait while the update continues.
echo.
echo This may take a moment. Do not close this window.
echo ==========================================================
echo.
pause
timeout /t 2 /nobreak >nul

echo [33mUpdate in Progress... Please Wait...[0m
ren %BACKUP_FILE% %UPDATE_FILE%
timeout /t 5 /nobreak >nul
goto StartUpdates

:ERROR
cls
echo ERROR Retreiving Version Info
echo Please Download Update Manually
pause
exit

:UpdateLog
if %TPE%==1 set TPE=INFO
if %TPE%==2 set TPE=ERROR
echo %DATE% %TIME% PID:4268  %TPE% %MSG% >> Update.log
echo %DATE% %TIME% PID:4268  %TPE% %MSG%
set "TPE="
set "MSG="
exit /b 


:TryAgainLater
cls
echo Your internet connection may be down, or there are no updates available at this time.
pause
exit /b