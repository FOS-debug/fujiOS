::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
title FujiOS Troubleshooter

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