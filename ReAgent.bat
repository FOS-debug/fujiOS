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

echo WARNING: This will delete the current OS and replace it.
echo Press any key for deletion, or close this window to cancel.
echo.
timeout /t 5 /nobreak >nul
pause
timeout /t 5 /nobreak >nul
cls
echo =========================================
echo FACTORY RESET IN PROGRESS. . .
echo DO NOT CLOSE THIS SCREEN
echo.
echo =========================================
ping localhost -n 3 >nul
timeout /t 5 /nobreak >nul
del factoryrset.log
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
set OLD_FILE=OperatingSystem.OLD
set UPDATE_FILE=OperatingSystem.bat
cls
echo WARNING: This will replace the current version of the OS
echo with the previous version.
echo Close this window to cancel.
echo.
timeout /t 5 /nobreak >nul
pause
timeout /t 5 /nobreak >nul
cls
echo =========================================
echo SYSTEM RESTORE IN PROGRESS. . .
echo DO NOT CLOSE THIS SCREEN
echo.
echo =========================================
ping localhost -n 3 >nul
del systemrstore.log

if not exist %OLD_FILE% goto ERROR
timeout /t 5 /nobreak >nul
del %UPDATE_FILE%
ren %OLD_FILE% %UPDATE_FILE%
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
curl -o cdbit.bat %SERVER_URL%/cdbit.bat
curl -o FujiTroubleshooter.cmd %SERVER_URL%/FujiTroubleshooter.cmd
curl -o 6Bit.bat %SERVER_URL%/6Bit.bat
curl -o 8bit.bat %SERVER_URL%/8bit.bat
curl -o Antivirus.bat %SERVER_URL%/Antivirus.bat
echo Done!
pause
exit /b

