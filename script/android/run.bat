@echo off
chcp 65001 >nul
echo ========================================
echo   Android App Install and Run Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\
set APK_PATH=%PROJECT_ROOT%android\app\build\outputs\apk\debug\app-debug.apk
set PACKAGE_NAME=com.example.helloapp

:: Check if APK exists
if not exist "%APK_PATH%" (
    echo [Error] APK file not found. Please run build.bat first.
    pause
    exit /b 1
)

:: Check device connection
echo [1/3] Checking device connection...
adb devices
if %ERRORLEVEL% NEQ 0 (
    echo [Error] adb not found. Please install Android SDK platform-tools.
    pause
    exit /b 1
)
echo.

:: Install APK
echo [2/3] Installing app to device...
adb install -r "%APK_PATH%"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Installation failed.
    pause
    exit /b 1
)
echo.

:: Launch app
echo [3/3] Launching app...
adb shell am start -n %PACKAGE_NAME%/.MainActivity
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Launch failed.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   App launched successfully!
echo ========================================
echo.

pause
