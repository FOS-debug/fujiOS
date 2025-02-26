@echo off

:restart
cls
set "error=0"
set "errors=0"

set "validOSFiles=OperatingSystem.bat OperatingSystem1.bat OperatingSystem3.bat OperatingSystem4.bat OperatingSystemINDEV.bat Kernel.bat"
set validCount=0
set /p foscd=<icd.ini
< settings.ini (
  set /p Pin1=
  set /p Pin2=
  set /p Pin3=
  set /p Pin4=
  set /p Pin5=
  set /p Pin6=
  set /p Pin7=
  set /p Pin8=
  set /p PinVerif=
)

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

if "%PinVerif%" neq "01000110.01001111.01010011" (
    set "foscd=PIN.ERROR"
    set "error=1"
)


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


:SetupBIOS
(
  echo 0
  echo 0
  echo 0
  echo 0
  echo 1
  echo 1
  echo 1
  echo 1
  echo 01000110.01001111.01010011
) > settings.ini
echo 1121>icd.ini
goto restart
