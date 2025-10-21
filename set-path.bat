@echo off
:: ==========================================================
:: SAFE PATH APPENDER
:: Adds the current directory to the user's PATH safely
::
:: Note: I do not take full credit as author for this script,
::   it is adapted from various online sources and has
::   passed through Copilot for safety improvements.
::   (see credits.md)
:: ==========================================================

setlocal enabledelayedexpansion

:: Get absolute path of this script's directory
set "SCRIPT_DIR=%~dp0"
:: Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

echo [INFO] Adding "%SCRIPT_DIR%" to user PATH...

:: Get the current user PATH from registry
for /f "usebackq tokens=2*" %%A in (`reg query "HKCU\Environment" /v PATH 2^>nul`) do set "OLD_PATH=%%B"

:: Check if already in PATH
echo %OLD_PATH% | find /i "%SCRIPT_DIR%" >nul
if %errorlevel%==0 (
    echo [OK] Directory already in PATH.
    goto :EOF
)

:: Combine safely (keep original, append new)
set "NEW_PATH=%OLD_PATH%;%SCRIPT_DIR%"

:: Update registry safely
reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%NEW_PATH%" /f >nul

echo [SUCCESS] Added to PATH. You must restart your terminal for changes to apply.
endlocal
pause
