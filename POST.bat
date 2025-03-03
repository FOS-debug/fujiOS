@echo off
for /f "usebackq tokens=1,* delims==" %%A in ("settings.ini") do (
    if /i "%%A"=="bios.date"       set "bios.date=%%B"
    if /i "%%A"=="bios.time"       set "bios.time=%%B"
    if /i "%%A"=="bootdev.HDD"     set "bootdev.HDD=%%B"
    if /i "%%A"=="bootdev.USB"     set "bootdev.USB=%%B"
    if /i "%%A"=="bootdev.CD/DVD"  set "bootdev.CD/DVD=%%B"
    if /i "%%A"=="boot.priority1"  set "boot.priority1=%%B"
    if /i "%%A"=="boot.priority2"  set "boot.priority2=%%B"
    if /i "%%A"=="boot.priority3"  set "boot.priority3=%%B"
    if /i "%%A"=="bios.mboot"      set "bios.mboot=%%B"
    if /i "%%A"=="bios.safety"     set "bios.safety=%%B"
    if /i "%%A"=="bios.POST"       set "bios.POST=%%B"

)
if "%bios.POST%"=="DISABLED" goto SKIP


:restart
cls
set "error=0"
set "errors=0"
if not exist validOSFiles.txt (
    echo OperatingSystem.bat OperatingSystem1.bat OperatingSystem3.bat OperatingSystem4.bat OperatingSystemINDEV.bat Kernel.bat> validOSFiles.txt
)
set /p validOSFiles=<validOSFiles.txt
set validCount=0
set /p foscd=<icd.ini


for %%F in (%validOSFiles%) do (
    if exist "%%F" (
        set /a validCount+=1
        set "osfile[!validCount!]=%%F"
    )
)

wmic OS get FreePhysicalMemory | findstr /r "[1-9]" > nul
if %errorlevel% neq 0 (
    echo [ERROR] Insufficient RAM detected.
    set /a errors+=1
) else (
    echo [OK] RAM check passed.
)

if exist error (
    set /a errors+=1
    del error
)



wmic LogicalDisk where "DeviceID='C:'" get FreeSpace | findstr /r "[1-9]" > nul

if %errorlevel% neq 0 (
    echo [ERROR] Insufficient Disk Space.
    set /a errors+=1
) else (
    echo [OK] Disk Space check passed.
)



if not exist BOOTLOADER.bat (
    echo [ERROR] Bootloader file missing.
    set /a errors+=1
) else (
    echo [OK] Bootloader found.
)


set "error=0"

if "%foscd%" neq "1121" (
    echo [ERROR] Pins not set. Please run setup program.
    set "error=1"
)


if %validCount%==0 (
    echo [ERROR] No valid OS file found.
    set /a errors+=1
) else (
    echo [OK] OS file found.
)

echo.
if "%error%" neq "0" (
    echo Press Any Key To Run Setup Program
    pause >nul
    set /a errors+=1
    goto SetupBIOS
)

if "%errors%" equ "0" (
    set "POST=PASS"
    echo POST PASSED
) else (
    set "POST=FAIL"
    echo POST FAILED
)

timeout /t 3 /nobreak >nul
exit /b

:SKIP
if not exist validOSFiles.txt (
    echo OperatingSystem.bat OperatingSystem1.bat OperatingSystem3.bat OperatingSystem4.bat OperatingSystemINDEV.bat Kernel.bat> validOSFiles.txt
)
set /p validOSFiles=<validOSFiles.txt
set "POST=SKIP"
exit /b


:SetupBIOS
echo 1121>icd.ini
goto restart
