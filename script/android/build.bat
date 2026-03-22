@echo off
chcp 65001 >nul
echo ========================================
echo   Android APK Build Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\

:: Sync code first
echo [1/3] Syncing shared code...
call %PROJECT_ROOT%sync-code.bat
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Code sync failed.
    pause
    exit /b 1
)

cd /d %PROJECT_ROOT%android

echo [2/3] Cleaning old build...
if exist "app\build" rd /s /q "app\build"

echo [3/3] Building APK...
call gradlew.bat assembleDebug

echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo   Build Success!
    echo ========================================
    echo.
    echo APK Location:
    echo %PROJECT_ROOT%android\app\build\outputs\apk\debug\app-debug.apk
    echo.
) else (
    echo ========================================
    echo   Build Failed! Check error messages.
    echo ========================================
    echo.
)

pause
