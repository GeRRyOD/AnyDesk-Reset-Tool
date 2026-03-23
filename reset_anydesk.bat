@ECHO OFF
TITLE Reset AnyDesk ID (Final Clean)

:: --- Admin rights check ---
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Run this script as Administrator.
    PAUSE
    EXIT
)

ECHO [1/5] Stopping AnyDesk...
SC stop AnyDesk >NUL 2>&1
TASKKILL /F /IM AnyDesk.exe >NUL 2>&1

:: --- Allow system to release file handles ---
TIMEOUT /T 2 /NOBREAK >NUL

SC query AnyDesk | FIND "STOPPED" >NUL
IF NOT %ERRORLEVEL%==0 (
    TIMEOUT /T 2 /NOBREAK >NUL
)

:: --- ProgramData ---
ECHO [2/5] Cleaning ProgramData...
IF EXIST "%ProgramData%\AnyDesk" (
    TAKEOWN /F "%ProgramData%\AnyDesk" /R /D Y >NUL 2>&1
    ICACLS "%ProgramData%\AnyDesk" /grant Administrators:F /T /C >NUL 2>&1
    RMDIR /S /Q "%ProgramData%\AnyDesk" >NUL 2>&1
)

:: --- User Configs ---
ECHO [3/5] Cleaning user configs...
FOR /D %%U IN ("%SystemDrive%\Users\*") DO (
    IF EXIST "%%U\AppData\Roaming\AnyDesk" (

        RMDIR /S /Q "%%U\AppData\Roaming\AnyDesk" >NUL 2>&1

        IF EXIST "%%U\AppData\Roaming\AnyDesk" (
            TAKEOWN /F "%%U\AppData\Roaming\AnyDesk" /R /D Y >NUL 2>&1
            ICACLS "%%U\AppData\Roaming\AnyDesk" /grant Administrators:F /T /C >NUL 2>&1
            RMDIR /S /Q "%%U\AppData\Roaming\AnyDesk" >NUL 2>&1
        )
    )
)

:: --- Reestry ---
ECHO [4/5] Cleaning registry...
REG DELETE "HKCU\Software\AnyDesk" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\AnyDesk" /f >NUL 2>&1
REG DELETE "HKLM\SOFTWARE\WOW6432Node\AnyDesk" /f >NUL 2>&1

:: --- Service Starting ---
ECHO [5/5] Starting AnyDesk...
SC config AnyDesk start= auto >NUL 2>&1
SC start AnyDesk >NUL 2>&1

:: --- Program Starting ---
IF EXIST "%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe" (
    START "" "%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe"
) ELSE IF EXIST "%ProgramFiles%\AnyDesk\AnyDesk.exe" (
    START "" "%ProgramFiles%\AnyDesk\AnyDesk.exe"
) ELSE (
    ECHO AnyDesk not found. Start manually.
)

ECHO.
ECHO Done. System cleaned. AnyDesk identity crisis initiated.
PAUSE