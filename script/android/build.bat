@echo off
chcp 65001 >nul
echo ========================================
echo   Android APK Build Script
echo ========================================
echo.

set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..\..\
set ANDROID_DIR=%PROJECT_ROOT%android

:: Set proxy
set HTTP_PROXY=http://192.168.100.1:32124
set HTTPS_PROXY=http://192.168.100.1:32124
set http_proxy=http://192.168.100.1:32124
set https_proxy=http://192.168.100.1:32124

echo Using proxy: %HTTP_PROXY%
echo.

:: [1/4] 同步源代码
echo [1/4] Syncing shared code...
call "%PROJECT_ROOT%sync-code.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Code sync failed.
    pause
    exit /b 1
)

:: [2/4] 同步编译产物
echo [2/4] Syncing HarmonyOS build artifacts...
call "%SCRIPT_DIR%sync-assets.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Assets sync failed.
    echo Please build HarmonyOS project first.
    pause
    exit /b 1
)

:: [3/4] 清理旧构建
echo [3/4] Cleaning old build...
if exist "%ANDROID_DIR%\app\build" rd /s /q "%ANDROID_DIR%\app\build"

:: [4/4] 构建 APK
echo [4/4] Building APK...
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
