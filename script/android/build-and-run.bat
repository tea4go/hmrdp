@echo off
chcp 65001 >nul
echo ========================================
echo   Android Build and Run Script
echo ========================================
echo.

cd /d %~dp0

:: Build
echo [Stage 1] Building project...
echo ========================================
call build.bat
if %ERRORLEVEL% NEQ 0 (
    echo Build failed, aborting.
    pause
    exit /b 1
)

echo.
echo [Stage 2] Installing and running...
echo ========================================
call run.bat

pause
