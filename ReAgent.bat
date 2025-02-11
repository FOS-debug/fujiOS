@echo off
cls
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"
if exist systemrpair.log goto systemrepair
if exist systemrstore.log goto SYSTEMRESTORE
if exist factoryrset.log (
    goto FACTORYRESET
) ELSE (
    echo INVALID OPERATION
    pause
    exit /b
)

:FACTORYRESET
cls
if not exist factoryrset.log (
    echo INVALID OPERATION
    pause
    exit /b
)
del factoryrset.log
echo WARNING: This action will permanently delete the current OS and install a new one.  
echo All data on the existing system may be lost.  
echo.
echo To cancel, close this window now.  
echo.
timeout /t 5 /nobreak >nul
pause
timeout /t 5 /nobreak >nul
cls
echo =========================================
echo      FACTORY RESET IN PROGRESS...
echo      DO NOT CLOSE THIS WINDOW
echo =========================================
ping localhost -n 3 >nul
timeout /t 5 /nobreak >nul
del %mainfilepath%\pass.pkg
del %mainfilepath%\user.pkg
del settings.ini
del settings2.ini
set "lastpage=FactoryReset1334"
del %mainfilepath%\FACTORYRESETNXT.log
del %mainfilepath%\pass.pkg
del %mainfilepath%\user.pkg
del settings.ini
del %mainfilepath%\BOOTSEC.sys
del %mainfilepath%\BOOTSEC2
del settings2.ini
del %mainfilepath%\kencr
ping localhost -n 3 >nul
del %mainfilepath%\antivirus_log.txt
del %mainfilepath%\BOOTSEC.sys
del %mainfilepath%\login_attempts.log
del %mainfilepath%\BOOTSEC2
del %mainfilepath%\BURGER.dll
del %mainfilepath%\stolen_report.txt
del %mainfilepath%\reportedstolen.log
del %mainfilepath%\Bootlog.log
del %%mainfilepath%\kencr
del %mainfilepath%\Bootlog.log
del %mainfilepath%\WindowsBootLog.dll
del %mainfilepath%\pass.pkg
del %mainfilepath%\user.pkg
del %mainfilepath%\time.pkg
del %mainfilepath%\BootTime1
del %mainfilepath%\BootTime2
del memory.tmp
if exist %mainfilepath%\org.pkg del %mainfilepath%\org.pkg
if exist %mainfilepath%\domain.pkg del %mainfilepath%\domain.pkg
rmdir %mainfilepath%\CrashLogs
rmdir %userprofile%\BatchGameIDE
rmdir %userprofile%\USERdocuments
rmdir %mainfilepath%
timeout /t 5 /nobreak >nul
exit /b
exit


:SYSTEMRESTORE
set OLD_VERSION=Version.OLD
set VERSION_FILE=Version.txt

set OLD_FILE=OperatingSystem.OLD
set UPDATE_FILE=OperatingSystem.bat
del systemrstore.log
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
del systemrpair.log
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

