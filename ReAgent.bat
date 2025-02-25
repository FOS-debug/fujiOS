@echo off
chcp 65001 >nul
set "repair=0"
set "restore=0"
set "restore2=0"
set "reset=0"
set "VOID=0" 
set "mainfilepath=%userprofile%\FUJIOS"
cls
echo Starting Recovery Environment . . .
timeout /t 5 /nobreak >nul
if exist systemrpair.log (
    if exist systemrstore.log set "VOID=1"
    if exist factoryrset.log set "VOID=1"
    if exist systemrstore2.log set "VOID=1"
    set "repair=1"
    echo Booting System Repair Environment
    timeout /t 2 /nobreak >nul
)
timeout /t 2 /nobreak >nul

if exist systemrstore.log (
    if exist systemrpair.log set "VOID=1"
    if exist factoryrset.log set "VOID=1"
    if exist systemrstore2.log set "VOID=1"
    set "restore=1"
    echo Booting System Update Restore Environment
    timeout /t 2 /nobreak >nul
)

if exist systemrstore2.log (
    if exist systemrpair.log set "VOID=1"
    if exist factoryrset.log set "VOID=1"
    if exist systemrstore.log set "VOID=1"
    set "restore2=1"
    echo Booting System Restore Snapshot Environment
    timeout /t 2 /nobreak >nul
)

if exist factoryrset.log (
    if exist systemrpair.log set "VOID=1"
    if exist systemrstore.log set "VOID=1"
    if exist systemrstore2.log set "VOID=1"
    set "reset=1"
    echo Booting System Reset Environment
    timeout /t 2 /nobreak >nul
)

if "%VOID%" == "1" (
    goto CONFLICT
)

timeout /t 2 /nobreak >nul


if %repair% == 1 (
    del systemrpair.log
    goto systemrepair
)

if %restore% == 1 (
    del systemrstore.log
    goto SYSTEMRESTORE
)

if %restore2% == 1 (
    del systemrstore2.log
    goto RESTOREFROMSNAP
)

if %reset% == 1 (
    del factoryrset.log
    goto FACTORYRESET
)
goto ERROR1
goto ERROR1
goto ERROR1
goto ERROR1
goto ERROR1


:FACTORYRESET
color 1F
set CLEANDRIVE=0
cls
REM *****************************************************
REM Batch Script: Remove/Keep Files and Reinstall Options
REM Description:
REM   1. Moves registration.log from %userprofile%\FUJIOS to a temporary folder.
REM   2. Prompts you whether to remove files or keep them.
REM      - If you choose “remove”, it deletes the specified files/folders.
REM      - If you choose “keep”, it skips deletions (only the reinstall is done).
REM   3. Prompts for reinstall method:
REM         • Local reinstall: Moves OperatingSystem.bat to temp then later restores it.
REM         • Cloud download: Deletes OperatingSystem.bat then downloads a fresh copy.
REM   4. At the end, if %userprofile%\FUJIOS was removed, it is re-created and registration.log is moved back.
REM *****************************************************
cls
echo -------------------------------------------------
echo                 Reset FujiOS
echo -------------------------------------------------
echo.
echo   Choose one of the following options:
echo.
echo         [K]  Keep my files
echo              (Your personal files will be kept,
echo               but apps and settings will be removed.)
echo.
echo         [R]  Remove everything
echo              (All files, apps, and settings will be
echo               removed for a fresh start.)
echo.
choice /C KR /M "Select an option: "
if %errorlevel%==1 (
    set RESET_TYPE=KEEP
    set APPRMVTYPE=KEEP
)
if %errorlevel%==2 (
    set RESET_TYPE=REMOVE
    set APPRMVTYPE=REMOVE
)


cls
echo -------------------------------------------------
echo                 Reset FujiOS
echo -------------------------------------------------
echo.
echo   Select the installation method:
echo.
echo         [L]  Local reinstall
echo              (Reinstall FujiOS using existing files
echo               on this PC. Faster if the system image is healthy.)
echo.
echo         [C]  Cloud download
echo              (Download a fresh copy of FujiOS from the cloud.
echo               Recommended if local files are corrupted.)
echo.
choice /C LC /M "Select an option: "
if %errorlevel%==1 (
    set REINSTALL_TYPE=LOCAL
) else (
    set REINSTALL_TYPE=CLOUD
)
if %RESET_TYPE%==REMOVE (
    if %APPRMVTYPE%==REMOVE goto Clearcacheconfirm
)
:isthisinfocorrect
cls
echo -------------------------------------------------
echo               Confirm Your Settings
echo -------------------------------------------------
echo.
echo   Please review your reset options:
echo.
echo         %RESET_TYPE% Files
echo         %APPRMVTYPE% Applications
echo         %REINSTALL_TYPE% Installation
echo.
echo   Resetting will:
echo     • Change settings back to defaults.
if "%RESET_TYPE%"=="REMOVE" echo     • Remove personal files and user accounts.
if "%RESET_TYPE%"=="KEEP" echo     • Keep personal files.
if "%REINSTALL_TYPE%"=="LOCAL" echo     • Reinstall FujiOS from this device.
if "%REINSTALL_TYPE%"=="CLOUD" echo     • Download and reinstall FujiOS.
if "%APPRMVTYPE%"=="REMOVE" echo     • Remove all apps and programs.
if "%APPRMVTYPE%"=="KEEP" echo     • Keep all apps and programs.
if "%CLEANDRIVE%"=="1" echo     • Clear FujiOS cache.
echo.
echo   Note:
if "%REINSTALL_TYPE%"=="CLOUD" echo     Cloud download may use more than 2.25 GB of data.
if "%CLEANDRIVE%"=="1" echo     Clearing cache can take a while.
echo.
echo         [C]  CANCEL   - Abort the reset process.
echo         [R]  RESET    - Proceed with the reset.
echo.
choice /C CR /M "Select an option: "
if %errorlevel%==1 goto :EOF
timeout /t 5 /nobreak >nul
cls
echo =========================================
echo         RESET IN PROGRESS...
echo      DO NOT CLOSE THIS WINDOW
echo =========================================
ping localhost -n 3 >nul
title DO NOT CLOSE THIS WINDOW
timeout /t 5 /nobreak >nul

if not exist "%userprofile%\AppData\Roaming\factoryresettemp" (
    mkdir "%userprofile%\AppData\Roaming\factoryresettemp"
)


if exist "%userprofile%\FUJIOS\registration.log" (
    move /Y "%userprofile%\FUJIOS\registration.log" "%userprofile%\AppData\Roaming\factoryresettemp\" >nul
)

if exist "Store_Settings.ini" del /F /Q "Store_Settings.ini" >nul
if exist "colr.pkg" del /F /Q "colr.pkg" >nul
if exist "settings.ini" del /F /Q "settings.ini" >nul
if exist "memory.tmp" del /F /Q "memory.tmp" >nul
if exist "manifest.txt" del /F /Q "manifest.txt" >nul

if exist "%userprofile%\Documents\bsodtype.pkg" del /F /Q "%userprofile%\Documents\bsodtype.pkg" >nul

if %RESET_TYPE%==REMOVE (
    goto DO_DELETIONS
)
if %RESET_TYPE%==KEEP (
    goto SKIP_DELETIONS
)


:DO_DELETIONS
if exist "%userprofile%\FUJIOS" (
    attrib -R "%userprofile%\FUJIOS" /S /D
    rmdir /S /Q "%userprofile%\FUJIOS" >nul
)
timeout /t 5 /nobreak >nul

if exist "Installation.log" del /F /Q "Installation.log" >nul
if exist "Bootlog.log" del /F /Q "Bootlog.log" >nul
timeout /t 5 /nobreak >nul

if exist "%userprofile%\AppData\Bootlog.log" del /F /Q "%userprofile%\AppData\Bootlog.log" >nul
if exist "%userprofile%\AppData\kencr" del /F /Q "%userprofile%\AppData\kencr" >nul

timeout /t 5 /nobreak >nul
if exist "%userprofile%\Documents\BOOTSEC.sys" del /F /Q "%userprofile%\Documents\BOOTSEC.sys" >nul
if exist "%userprofile%\Documents\BootTime1" del /F /Q "%userprofile%\Documents\BootTime1" >nul
if exist "%userprofile%\Documents\BootTime2" del /F /Q "%userprofile%\Documents\BootTime2" >nul
timeout /t 5 /nobreak >nul

if %APPRMVTYPE%==1 (
    if exist "%userprofile%\Applications" (
        rmdir /S /Q "%userprofile%\Applications" >nul
    ) else (
        echo Applications folder not found.
    )
) 

if %CLEANDRIVE%==1 (
    if exist "%userprofile%\AppData\Local\lcnse.log" del /F /Q "%userprofile%\AppData\Local\lcnse.log" >nul
    if exist "%userprofile%\Appdata\Local\cachedinfo.ini" del /F /Q "%userprofile%\Appdata\Local\cachedinfo.ini" >nul
    if exist "%userprofile%\Appdata\Local\BIOSconfig.ini" del /F /Q "%userprofile%\Appdata\Local\BIOSconfig.ini" >nul
    if exist "%userprofile%\Appdata\Local\MEMORYconfig.ini" del /F /Q "%userprofile%\Appdata\Local\MEMORYconfig.ini" >nul
    if exist "%userprofile%\Appdata\Local\GPUconfig.ini" del /F /Q "%userprofile%\Appdata\Local\GPUconfig.ini" >nul
)

goto AFTER_DELETIONS

:SKIP_DELETIONS
:AFTER_DELETIONS

echo.

timeout /t 5 /nobreak >nul
if "%REINSTALL_TYPE%"=="LOCAL" (
    REM For local reinstall, move OperatingSystem.bat to the temp folder
    if not exist "%userprofile%\AppData\Roaming\factoryresettemp" (
        mkdir "%userprofile%\AppData\Roaming\factoryresettemp" >nul
    )
    if exist "OperatingSystem.bat" (
        move /Y "OperatingSystem.bat" "%userprofile%\AppData\Roaming\factoryresettemp\" >nul
    ) else (
        echo OperatingSystem.bat not found in current directory.
        pause
    )
) else (
    REM For cloud download, delete OperatingSystem.bat if it exists
    if exist "OperatingSystem.bat" (
        del /F /Q "OperatingSystem.bat" >nul
    )
)

echo.
REM If %userprofile%\FUJIOS does not exist (i.e. it was deleted), re-create it.
if not exist "%userprofile%\FUJIOS" (
    mkdir "%userprofile%\FUJIOS" >nul
)

REM Move registration.log back to %userprofile%\FUJIOS if it exists in the temp folder.
if exist "%userprofile%\AppData\Roaming\factoryresettemp\registration.log" (
    move /Y "%userprofile%\AppData\Roaming\factoryresettemp\registration.log" "%userprofile%\FUJIOS\" >nul
)
timeout /t 5 /nobreak >nul

REM --- Reinstall actions based on method ---
if "%REINSTALL_TYPE%"=="LOCAL" (
    if exist "%userprofile%\AppData\Roaming\factoryresettemp\OperatingSystem.bat" (
        move /Y "%userprofile%\AppData\Roaming\factoryresettemp\OperatingSystem.bat" "." >nul
    )
    rmdir /S /Q "%userprofile%\AppData\Roaming\factoryresettemp" >nul
) else (
    set SERVER_URL=https://fos-debug.github.io/fujiOS
    set REMOTE_VERSION_FILE=%SERVER_URL%/Version.txt
    set UPDATE_FILE=OperatingSystem.bat
    set UPDATER_FILE=UpAgent.bat
    set BACKUP_FILE=OperatingSystem.Backup
    set OLD_FILE=OperatingSystem.OLD
    set OLD_VERSION=Version.OLD
    set VERSION_FILE=Version.txt
    set /p CURRENT_VERSION=<Version.txt
    curl -s -o %UPDATE_FILE% %SERVER_URL%/%UPDATE_FILE%
    curl -s -o Version.txt %SERVER_URL%/%VERSION_FILE%
    echo Cloud download completed.
)
timeout /t 5 /nobreak >nul

echo.
echo Factory Reset Complete
echo.
pause

timeout /t 5 /nobreak >nul
exit /b
exit

:Clearcacheconfirm
cls
echo -------------------------------------------------
echo                 Reset FujiOS
echo -------------------------------------------------
echo.
echo   Do you want to clear the FujiOS Cache?
echo.
echo         [C]  Clear Cache
echo              (Removes system cache.
echo               Use if you are recycling your PC.)
echo.
echo         [D]  Don't Clear Cache
echo              (Keeps the cache intact.
echo               Use if you plan to continue using your PC.)
echo.
choice /C CD /M "Select an option: "
if %errorlevel%==1 (
    set CLEANDRIVE=1
) else (
    set CLEANDRIVE=0
)
goto isthisinfocorrect

:SYSTEMRESTORE
set OLD_VERSION=Version.OLD
set VERSION_FILE=Version.txt

set OLD_FILE=OperatingSystem.OLD
set UPDATE_FILE=OperatingSystem.bat
cls
echo WARNING: This operation will downgrade the OS to a previous version.  
echo Proceeding will replace the current version, potentially affecting system stability and data.  
echo.
echo To cancel, close this window now.  
echo.
timeout /t 5 /nobreak >nul
pause
timeout /t 5 /nobreak >nul
cls
echo =========================================
echo       SYSTEM RESTORE IN PROGRESS...
echo      DO NOT CLOSE THIS WINDOW
echo =========================================
ping localhost -n 3 >nul
timeout /t 5 /nobreak >nul
if not exist %OLD_FILE% goto ERROR
timeout /t 5 /nobreak >nul
del %UPDATE_FILE%
ren %OLD_FILE% %UPDATE_FILE%
del %VERSION_FILE%
ren %OLD_VERSION% %VERSION_FILE%
echo System Successfully Restored
timeout /t 5 /nobreak >nul
exit /b
exit

:ERROR
cls
echo ERROR  No Prev File Version Found
pause
exit /b
exit

:systemrepair
cls
echo WARNING: You are about to reinstall Core OS files.  
echo Proceeding with this operation may overwrite critical system files.  
echo If the reinstallation fails, it could lead to system corruption.  
echo.
echo To cancel, close this window now.  
echo.
timeout /t 5 /nobreak >nul
pause
timeout /t 5 /nobreak >nul
set SERVER_URL=https://fos-debug.github.io/fujiOS-Download
cls
echo =========================================
echo       SYSTEM REPAIR IN PROGRESS...
echo      DO NOT CLOSE THIS WINDOW
echo =========================================
ping localhost -n 3 >nul
timeout /t 5 /nobreak >nul
curl -o cdbit.bat %SERVER_URL%/cdbit.bat
if %errorlevel% neq 0 echo An Error May Have Occurred
curl -o FujiTroubleshooter.cmd %SERVER_URL%/FujiTroubleshooter.cmd
if %errorlevel% neq 0 echo An Error May Have Occurred
curl -o Varset.bat %SERVER_URL%/Varset.bat
if %errorlevel% neq 0 echo An Error May Have Occurred
curl -o Antivirus.bat %SERVER_URL%/Antivirus.bat
if %errorlevel% neq 0 echo An Error May Have Occurred
if %errorlevel% equ 0 echo System Successfully Repaired
timeout /t 5 /nobreak >nul
exit /b
exit

:CONFLICT
cls
echo.
echo.
echo [31mERROR: CONFLICTING RECOVERY OPTIONS DETECTED[0m
echo The following recovery options are selected:
echo.
if "%repair%" == "1" echo - System Repair
if "%restore%" == "1" echo - System Restore
if "%restore2%" == "1" echo - System Restore2
if "%reset%" == "1" echo - Factory Reset
echo.
echo Multiple recovery settings cannot be used at the same time.
echo Please ensure only one of the following is selected:
echo.
echo (System Repair)
echo (System Restore)
echo (System Restore2)
echo (Factory Reset)
echo.
echo Resolve the conflict and try again.
if exist factoryrset.log del factoryrset.log
if exist systemrstore.log del systemrstore.log
if exist systemrstore2.log del systemrstore2.log
if exist systemrpair.log del systemrpair.log
echo.
pause
exit 
exit /b

:ERROR1
cls
echo.
echo.
echo [31mERROR: NO RECOVERY ENVIRONMENT SELECTED[0m
echo No valid recovery option has been detected.
echo.
echo Please ensure one of the following options is selected:
echo.
echo (System Repair)
echo (System Restore)
echo (System Restore2)
echo (Factory Reset)
echo.
echo Then restart the process.
echo.
pause
exit 
exit /b
SYSTEMRESTORE2

:RESTOREFROMSNAP
cls
echo Available Snapshots:
dir /b "%BackupDir%" /o-d

:: Prompt user for snapshot selection
set /p choice="Enter date of snapshot to restore (YYYYMMDD): "

:: Validate selection
if not exist "%BackupDir%\%choice%" (
    echo Error: The selected backup does not exist.
    pause
    exit /b
)

echo Restoring snapshot...
xcopy /E /Y "%BackupDir%\%choice%\*" "%CD%"
echo Restore complete!
pause
exit /b

