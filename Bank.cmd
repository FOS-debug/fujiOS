::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FUJIOS VERIFIED SCRIPT                                                         ::
:: ------------------------------------------------------------------------------ ::
:: Written by Emery Lightfoot with some debugging help and technique pointers from::
:: Chatgpt                                                                        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
setlocal enabledelayedexpansion
set "mainfilepath=%userprofile%\appdata\roaming\FUJIOS"
if not exist %mainfilepath% mkdir %mainfilepath%

set "userFolder=%mainfilepath%"

:refreshdfgh

rem File paths for saving credit card info and financial data
set "cardNumberFile=%userFolder%\card_number.txt"
set "cardCVVFile=%userFolder%\cvv.txt"
set "cardExpDateFile=%userFolder%\exp_date.txt"
set "creditFile=%userFolder%\credit.txt"
set "debtFile=%userFolder%\debt.txt"
set "balanceFile=%userFolder%\balance.txt"
rem Load credit card details
if not exist "%cardNumberFile%" echo 1234567890123456 > "%cardNumberFile%"
if not exist "%cardCVVFile%" echo 123 > "%cardCVVFile%"
if not exist "%cardExpDateFile%" echo 12/26 > "%cardExpDateFile%"

set /p cardNumber=<"%cardNumberFile%"
set /p cardCVV=<"%cardCVVFile%"
set /p cardExpDate=<"%cardExpDateFile%"

rem Load financial data or initialize if files don't exist
if not exist "%creditFile%" echo 500000 > "%creditFile%"
if not exist "%debtFile%" echo 0 > "%debtFile%"
if not exist "%balanceFile%" echo 0 > "%balanceFile%"
set /p credit=<"%creditFile%"
set /p debt=<"%debtFile%"
set /p balance=<"%balanceFile%"


:main_menu
call :refreshR
call :credtscore
if %balance% geq %debt% set "statusQ=Able To Pay Off Debt"
if %balance% lss %debt% set "statusQ=Unable To Pay Off Debt"
if %debt% leq "0" set "statusQ=No Debt"
if %debt%==0 del %userFolder%\credit.txt
cls
echo ============================
echo      Credit Card System     
echo ============================
echo.
echo 1. View Available Balance
echo 2. Borrow Money
echo 3. Pay Back Debt
echo 4. View Credit Card Info
echo 5. Exit
echo 6. Refresh
echo.
set /p choice="Choose an option (1-5): "

if %choice%==1 goto view_available_balance
if %choice%==2 goto borrow_money
if %choice%==3 goto pay_back_debt
if %choice%==4 goto view_card_info
if %choice%==5 goto exit
if %choice%==6 goto refreshdfgh

goto main_menu



:credtscore
rem Initialize factors
set utilization_factor=0
set leverage_factor=0

rem Calculate the utilization factor if credit_limit is greater than 0
if %credit% gtr 0 (
    set /a utilization_factor=debt * 100 / credit
)

rem Calculate the leverage factor if bank_balance is greater than 0
if %balance% gtr 0 (
    set /a leverage_factor=debt * 100 / balance
)

rem Calculate the base score
set /a base_score=500

rem Adjust score based on utilization
set /a score_adjustment1=(100 - utilization_factor) * 2

rem Adjust score based on leverage
set /a score_adjustment2=(100 - leverage_factor)

rem Calculate the final credit score
set /a credit_score=base_score + score_adjustment1 + score_adjustment2

rem Ensure credit score is within the valid range (0-850)
if %credit_score% lss 0 set credit_score=0
if %credit_score% gtr 850 set credit_score=850
exit /b

:view_available_balance
cls
echo Your available balance: $%balance%
echo Your available credit: $%credit%
echo Your current debt: $%debt%
pause
goto main_menu

:refreshR
echo %credit% > "%creditFile%"
echo %debt% > "%debtFile%"
echo %balance% > "%balanceFile%"
set /p credit=<"%creditFile%"
set /p debt=<"%debtFile%"
set /p balance=<"%balanceFile%"
exit /b

:borrow_money
cls
set /p amount="Enter the amount to borrow: $"
if %amount% GTR %credit% (
    echo You cannot borrow more than your available credit!
) else (
    rem Update credit and balance
    set /a credit-=amount
    set /a balance+=amount
    set /a debt+=amount
    echo %credit% > "%creditFile%"
    echo %debt% > "%debtFile%"
    echo %balance% > "%balanceFile%"
    echo Borrowing successful! New credit: $%credit%, New balance: $%balance%, New debt: $%debt%
)
pause
goto main_menu

:pay_back_debt
cls
echo TOTAL BALANCE: %balance%
echo TOTAL DEBT: %debt%
set /p amount="Enter the amount to pay back: $"
if %amount% GTR %balance% (
    echo You cannot pay more than your available balance!
) else (
    if %amount% GTR %debt% set amount=%debt%
    set /a credit+=amount
    set /a balance-=amount
    set /a debt-=amount
    echo %balance% > "%balanceFile%"
    echo %debt% > "%debtFile%"
    echo Payment successful! New balance: $%balance%, New debt: $%debt%
)
pause
goto main_menu

:view_card_info
cls
echo ============================
echo     Your Credit Card Info     
echo ============================
echo.
echo Credit Score: %credit_score%
echo Your available balance: $%balance%
echo Your available credit: $%credit%
echo Your current debt: $%debt%
echo.
echo Status: %StatusQ%
echo.
echo Card Number: %cardNumber%
echo CVV: %cardCVV%
echo Expiration Date: %cardExpDate%
pause
goto main_menu

:exit
cls
echo Thank you for using the Credit Card System!
pause
exit /b
