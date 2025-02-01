@echo off
setlocal enabledelayedexpansion
set SERVER_URL=https://fos-debug.github.io/fujiOS
set REMOTE_VERSION_FILE=%SERVER_URL%/Version.txt
set UPDATE_FILE=OperatingSystem.bat
set UPDATER_FILE=UpAgent.bat
set BACKUP_FILE=OperatingSystem.Backup
set OLD_FILE=OperatingSystem.OLD


:: Fetch remote version info
for /f "delims=" %%A in ('curl -s "%REMOTE_VERSION_FILE%"') do set "REMOTE_VERSION=%%A"

:: Check if we got a valid response
if "%REMOTE_VERSION%"=="" (
    echo Unable to retrieve Version Info.
    pause
    goto ERROR
)

echo.
echo New update found! Downloading...
echo [33mDO NOT CLOSE THIS SCREEN[0m
timeout /t 15 /nobreak >nul
:: Backup existing file if it exists
if exist %UPDATE_FILE% (
    rename %UPDATE_FILE% %BACKUP_FILE%
)
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #
echo ===============================
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ##
echo ===============================
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ###
echo ===============================
timeout /t 5 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ####
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #####
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ######
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #######
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ########
echo ===============================
timeout /t 7 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #########
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ##########
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ###########
echo ===============================
timeout /t 4 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ############
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #############
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ##############
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ###############
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ################
echo ===============================
timeout /t 3 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ##################
echo ===============================
timeout /t 4 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ###################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ####################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #####################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ######################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #######################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ########################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #########################
echo ===============================
timeout /t 5 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ##########################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ###########################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ############################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo #############################
echo ===============================
timeout /t 1 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ##############################
echo ===============================
timeout /t 5 /nobreak >nul
cls
echo.
echo.
echo ==============================
echo ********   *******    ******** 
echo /**/////   **/////**  **////// 
echo /**       **     //**/**       
echo /******* /**      /**/*********
echo /**////  /**      /**////////**
echo /**      //**     **        /**
echo /**       //*******   ******** 
echo //         ///////   ////////  
echo ==============================
echo.
echo   PineApple Technologies Inc
echo    Fuji Operating System
echo     Copyright 2022-2025
echo.
echo [33mUPDATING SOFTWARE[0m
echo [33mDO NOT CLOSE THIS SCREEN[0m
echo.
echo ===============================
echo ###############################
echo ===============================
timeout /t 3 /nobreak >nul
echo.
echo.
:: Download new version
curl -s -o %UPDATE_FILE% %SERVER_URL%/%UPDATE_FILE%
curl -s -o UpAgent.cmd %SERVER_URL%/%UPDATER_FILE%

:: Verify download success
if not exist %UPDATE_FILE% (
    echo Download failed! Restoring backup...
    if exist %BACKUP_FILE% (
        rename %BACKUP_FILE% %UPDATE_FILE%
    ) else (
        echo Unable To Find Backup File
        pause
        goto ERROR5
    )
    echo Update failed. Please try again later.
    pause
    exit
)
echo %REMOTE_VERSION%>Version.txt

echo Update successful!
if exist %OLD_FILE% del %OLD_FILE%
if exist %BACKUP_FILE% ren %BACKUP_FILE% %OLD_FILE%
pause
start cmd /k call 6bit.bat && call OperatingSystem.bat
exit /b
:ERROR5
echo Unable to find Operating System
echo Press Any Key To Start SysRestore
pause >nul
echo >systemrstore.log
call ReAgent.bat
if not exist %UPDATE_FILE% goto ERROR2
echo SYS RESTORE COMPLETED SUCCESSFULLY
echo.
echo PRESS ANY KEY TO RESTART UPDATE
pause >nul
start UpAgent.bat
exit

:ERROR2
cls
echo There was an error while updating the Operating System.
echo The backup of the OperatingSystem.bat file was deleted during the process.
echo As a result, the OS update has failed, and now the OperatingSystem.bat file is missing.
echo 
echo To resolve this issue, you need to manually reinstall the OperatingSystem.bat file.
echo Please do not worry about other core system files; they are unaffected.
echo 
echo Follow these steps to reinstall the OperatingSystem.bat file:
echo 1. Visit https://fos-debug.github.io/fujiOS/OperatingSystem.bat to
echo Download the latest version of OperatingSystem.bat.
echo 2. Place the downloaded file in the current directory.
echo 3. Restart the OS to complete the installation.
timeout /t 9999 /nobreak >nul
goto ERROR2



:ERROR
cls
echo ERROR Retreiving Version Info
echo Please Download Update Manually
pause
exit
