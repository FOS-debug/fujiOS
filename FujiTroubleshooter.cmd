
@echo off
title FujiOS Troubleshooter
echo ==========================================================
echo WARNING: This feature is deprecated.
echo This app is no longer necessary, but it has not been removed yet.
echo We are unable to remove it completely at this time in case it is still linked to other components of the OS.
echo Please be aware that this feature may be fully removed in a future update.
echo ==========================================================
pause

:Trouble
cls

set "documentsPath=%userprofile%\Documents"

if exist "%documentsPath%\BOOTSEC.sys" (
    echo No Problems Found With BootMGR

) else (
    echo. > "%documentsPath%\BOOTSEC.sys"
    echo Error BootMGR is Missing
)
Pause
goto Trouble1

:Trouble1
cls
set "documentsPath=%userprofile%\Documents"

if exist "%documentsPath%\BOOTSEC2" (
    echo Error BootSec Bug 
    del "%documentsPath%\BOOTSEC2"
) else (
    echo No BootSec Bugs
)
Pause
goto Trouble2

:Trouble2
cls
set "documentsPath=%userprofile%\Documents"

if exist "%documentsPath%\BURGER.dll" (
    echo Corrupted Fuji Installation
    timeout /nobreak /t 4 >nul
    goto BROKE

) else (
    echo DONE!
)
Pause
cls
echo No further problems have been found
pause
exit /b





:BROKE
cls
echo We were unable to fix your
echo FujiOS installation
echo.
echo.
echo.
pause
