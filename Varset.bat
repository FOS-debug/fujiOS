@echo off
if not exist PRIVATEKEY.ini (
    exit /b 1000
)

if exist PRIVATEKEY.ini (
   set /p privatekey2=<PRIVATEKEY.ini
)
if %privatekey2% neq %PRIVATEKEY% (
    exit /b 1000
)
if not defined USERPROFILEB set "USERPROFILEB=%USERPROFILE%"
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

echo Softcode Check
set "mainfilepath=%userprofile%\FUJIOS"
set "ErrorL=0"
set "MaxErr=2"
set "MaxxErr=3"
set "MaxxxErr=10"
echo QCD PASS
set "userFolder=%mainfilepath%"
set "docFolder=%userFolder%\USERdocuments"
rem Create USERdocuments folder if not exists
if not exist "%docFolder%" mkdir "%docFolder%"
set "playerScore=0"
echo QCD PASS
set "computerScore=0"
set /p timezone=<%userFolder%\time.pkg
set /p valid_username=<%userFolder%\user.pkg
set /p valid_password=<%userFolder%\pass.pkg
echo QCD PASS
set /p bsodtype=<%userFolder%\bsodtype.pkg
set /p colr=< colr.pkg
set "integk1=%OS2%"
set "integk2=%OS2%"
set "integk3=%OS2%"
set "integk4=%OS2%"
set "integk5=%OS2%"
set "integk6=%OS2%"
set "integk7=%OS2%"
set "integk8=%OS2%"
set "integk9=%OS2%"
set "integk10=%OS2%"
if not exist colr.pkg (
    set colr=color 07
    set rstscolr=0 
)
set "err2l=1"
echo SuccessBoot %DATE% %TIME% >> Bootlog.log
set "varchck=VariablesPassed"
echo QCD PASS


