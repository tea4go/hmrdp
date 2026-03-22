@echo off
chcp 65001 >nul
echo ========================================
echo   Android APK Build Script
echo ========================================
echo.

set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..\..\
set ANDROID_DIR=%PROJECT_ROOT%android

:: Sync code first
echo [1/3] Syncing shared code...
call "%PROJECT_ROOT%sync-code.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Code sync failed.
    pause
    exit /b 1
)

echo [2/3] Cleaning old build...
if exist "%ANDROID_DIR%\app\build" rd /s /q "%ANDROID_DIR%\app\build"

echo [3/3] Building APK...
cd /d "%ANDROID_DIR%"
"%ANDROID_DIR%\gradlew.bat" assembleDebug

echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo   Build Success!
    echo ========================================
    echo.
    echo APK Location:
    echo %ANDROID_DIR%\app\build\outputs\apk\debug\app-debug.apk
    echo.
) else (
    echo ========================================
    echo   Build Failed! Check error messages.
    echo ========================================
    echo.
)

pause
