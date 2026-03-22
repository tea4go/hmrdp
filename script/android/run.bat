@echo off
chcp 65001 >nul
echo ========================================
echo   Android App Install and Run Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\
set APK_PATH=%PROJECT_ROOT%android\app\build\outputs\apk\debug\app-debug.apk
set PACKAGE_NAME=com.example.helloapp

:: Detect Android SDK path from local.properties
set LOCAL_PROPS=%PROJECT_ROOT%android\local.properties
set SDK_PATH=

if exist "%LOCAL_PROPS%" (
    for /f "usebackq tokens=2 delims==" %%a in (`findstr "sdk.dir" "%LOCAL_PROPS%"`) do (
        call :convert_path "%%a" SDK_PATH
    )
)

:: Fallback to common SDK locations
if not defined SDK_PATH (
    if exist "%LOCALAPPDATA%\Android\Sdk" (
        set SDK_PATH=%LOCALAPPDATA%\Android\Sdk
    ) else if exist "C:\Android\Sdk" (
        set SDK_PATH=C:\Android\Sdk
    )
)

:: Add platform-tools to PATH
if defined SDK_PATH (
    set PATH=%SDK_PATH%\platform-tools;%SDK_PATH%\tools;%PATH%
)

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
exit /b 0

:: Subroutine to convert forward slashes to backslashes
:convert_path
setlocal
set "input=%~1"
set "output=%input:/=\%"
endlocal & set "%~2=%output%"
goto :eof
