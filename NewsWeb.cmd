goto NewsWeb

:linkd
cls
curl getnews.tech
echo.
echo Type In Link
set /p link=Enter link: 
curl %link%
goto pause1










:NewsWeb
cls
echo Replace every space with a + sign
echo example: world+cup
echo or type LINKD to type in getnews link
set /p Term=Enter Search Term: 
if "%Term%"=="LINKD" goto linkd
curl getnews.tech/%Term%
goto pause1
:pause1
pause
