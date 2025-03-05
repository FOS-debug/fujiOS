@echo off
setlocal EnableDelayedExpansion
set "USERPROFILEB=%USERPROFILE%"
set "USERPROFILE=Users\%USERNAME%"
set "mainfilepath=%userprofile%\FUJIOS"
if exist "%USERPROFILEB%\FUJIOS\" (
    xcopy "%USERPROFILEB%\FUJIOS\*" "%mainfilepath%\" /E /H /C /I /Y
    cls
    timeout /t 5 /nobreak >nul
    cls
    rmdir /s /q %USERPROFILEB%\FUJIOS
    cls
)
if not exist %mainfilepath% mkdir %mainfilepath%
if not exist %USERPROFILE%\AppData\Roaming mkdir %USERPROFILE%\AppData\Roaming
if not exist %USERPROFILE%\AppData\Local mkdir mkdir %USERPROFILE%\AppData\Local
if not exist %USERPROFILE%\AppData\LocalLow mkdir %USERPROFILE%\AppData\LocalLow

:Coreloaading
set "CRASHLOADED=1"
set /p VERSION2=<version.txt
set "OS2=FujiOS"
if "%crash%" == "1" (
    goto Crash
) else (
    set "crash=0"
)
set "crash=1"
call POST.bat
if "%POST%"=="PASS" call BOOTLOADER.bat
if "%POST%"=="SKIP" call BOOTLOADER.bat
goto Coreloaading

:Crash
set "crash=0"
if "%POST%"=="FAIL" set "bsodcode= POST TEST FAIL"
if "%bsodcode%" == "" goto bcodeud
:RESCUE
cls
echo error: %bsodcode%
echo ==============================
timeout /t 3 /nobreak >nul
echo Entering rescue mode...
timeout /t 3 /nobreak >nul
:COMMAND
echo.
set /p "command=%OS2% rescue> "
if /i "%command%"=="Reboot" goto Coreloaading
if "%command%" == "Get.Data" (
    for /f "tokens=2 delims==" %%I in ('wmic os get TotalVisibleMemorySize /value') do set "TotalMemory=%%I"
    for /f "tokens=2 delims==" %%I in ('wmic cpu get MaxClockSpeed /value') do set "CPUSpeed=%%I"
    for /f "tokens=2 delims==" %%I in ('wmic bios get SerialNumber /value') do set "SerialNumber=%%I"
    set "DMP3=1"
    set "PERMS=KernelAdmin"
    echo %OS2% BOOTAGENT %VERSION2% INITIALIZED
    echo %TotalMemory% KB
    echo %CPUSpeed% MHz
    echo %SerialNumber%
    echo.
)

if "%command%" == "help" (
    echo.
    echo Available commands:
    echo ----------------------
    echo Reboot           - Reboots the system
    echo ReAgent          - Initiates Recovery agent.
    echo Get.Data         - Retrieves system information including memory, CPU speed, and serial number
    echo Dump.Data        - Initiates the memory dump process
    echo.
    echo dir              - Lists the files and directories in the current directory
    echo cd               - Changes the current directory
    echo cls              - Clears the screen
    echo echo             - Displays a message or sets the echo state
    echo copy             - Copies files from one location to another
    echo move             - Moves files from one location to another
    echo del              - Deletes a file
    echo ren              - Renames a file or directory
    echo mkdir            - Creates a new directory
    echo rmdir            - Removes a directory
    echo tasklist         - Displays a list of currently running processes
    echo taskkill         - Terminates a process by its name or PID
    echo shutdown         - Shuts down or restarts the computer
    echo systeminfo       - Displays detailed configuration information about the computer
    echo ipconfig         - Displays IP configuration information for all network adapters
    echo ping             - Tests the network connection to a remote host
    echo netstat          - Displays network connections, routing tables, and interface statistics
    echo chkdsk           - Checks the file system and status of a disk
    echo sfc /scannow     - Scans and repairs system files
    echo msconfig         - Opens the System Configuration utility
    echo regedit          - Opens the Registry Editor
    echo gpupdate         - Updates group policy settings
    echo diskpart         - Opens the disk partitioning tool
    echo wmic             - Windows Management Instrumentation Command-line tool
    echo.
)



if "%command%" == "Dump.Data" (
    goto Memdump
)

echo.
call %command%
if errorlevel 1 echo [ERROR] Invalid command or execution failed.
goto COMMAND

:Memdump
set "DMP5=1"
echo.
echo Current Permissions [%PERMS%]
pause
if %PERMS% neq KernelAdmin goto COMMAND 
echo Dumping Current User Service . . . 
set "Dumpfile=$%Random%KernelMiniDump.dmp"
timeout /t 5 /nobreak >nul
echo. > %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%Enterprise%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%UAK%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%FPS_BROWSER_USER_PROFILE_STRING%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%hibernate%%RANDOM%%RANDOM%%privatekey2%%RANDOM%%RANDOM%%VERSION2%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%valid_username%%UPDATE%%SESSIONSTARTTIME%%valid_password%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%MaxxxErr%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%regnumber%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %OS2%%RANDOM%%MaxxErr%AdMni%RANDOM%%RANDOM%%ErrorL%%RANDOM%%RANDOM%%HOMEPATH%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%MaxErr%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%PRIVATEKEY%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%OS%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%FPS_BROWSER_APP_PROFILE_STRING%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%RANDOM%%RANDOM%%RANDOM%%attempts%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
echo %RANDOM%%documentsPath%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%ComSpec%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM% >> %Dumpfile%
goto COMMAND


:bcodeud
set bsodcode=KERR_008X_UNDEFINED
goto crash