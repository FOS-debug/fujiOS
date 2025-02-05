:Webtools1
cls
echo =======================
echo        WEB Tools
echo =======================
echo.
echo.
echo 01. Kanye Quotes
echo 02. Zen Quotes
echo 03. BBC News
echo 04. 
echo 05. 
echo 06. Exit


set /p choice=Enter the result number or type a link to open it: 

if "%choice%"=="EXIT" goto File_Manager

echo Opening Result %choice%...
timeout /t 1 /nobreak >nul
rem Your logic for handling the selected result goes here.
cls
if "%choice%"=="1" curl -s https://api.kanye.rest/
if "%choice%"=="2" curl -s https://zenquotes.io/api/random
if "%choice%"=="3" curl -s https://feeds.bbci.co.uk/news/rss.xml
if "%choice%"=="4" Echo INVALID!
if "%choice%"=="5" Echo INVALID!
if "%choice%"=="6" goto exit
pause
goto Webtools1

:exit