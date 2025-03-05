@echo off
setlocal
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

start https://docs.google.com/forms/d/e/1FAIpQLSdGiNb8u3iiSU6cVAjA9vygOxLAVbwEmaooNMHyM_DZMSxSLQ/viewform

REM --- Set up a temporary folder for packaging the files ---
set "TMPDIR=%TEMP%\FeedbackReportTemp"

REM Delete the temporary folder if it already exists
if exist "%TMPDIR%" rd /s /q "%TMPDIR%"

REM Create the temporary folder
mkdir "%TMPDIR%"

REM --- Copy the CrashLogs folder (with all its subfolders/files) ---
xcopy "%userprofile%\FUJIOS\CrashLogs" "%TMPDIR%\CrashLogs" /E /I /H /Y

REM --- Copy the registration.log file ---
copy "%userprofile%\FUJIOS\registration.log" "%TMPDIR%\" /Y

REM --- Remove any previous FEEDBACKRPT.zip in the current directory ---
if exist "FEEDBACKRPT.zip" del /f /q "FEEDBACKRPT.zip"

REM --- Zip the temporary folder’s contents into FEEDBACKRPT.zip ---
powershell -noprofile -command "Compress-Archive -Path '%TMPDIR%\*' -DestinationPath '%CD%\FEEDBACKRPT.zip'"

REM --- Clean up: Remove the temporary folder ---
rd /s /q "%TMPDIR%"

endlocal
cls
echo FEEDBACKRPT.zip Has Been Created In Current Directory. Please Upload This To The Feedback Form.
echo You Can Delete FEEDBACKRPT.zip After It Is Uploaded To The Feedback Form.

timeout /t 9999 /nobreak >nul
pause
timeout /t 15 /nobreak >nul