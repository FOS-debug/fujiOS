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


if not exist colr.pkg (
    set colr=color 07
    set rstscolr=0 
)

set "err2l=1"
echo SuccessBoot %DATE% %TIME% >> Bootlog.log
set "varchck=VariablesPassed"
echo QCD PASS


