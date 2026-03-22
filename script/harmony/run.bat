@echo off
chcp 65001 >nul
echo ========================================
echo   HarmonyOS App Install and Run Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\
set HAP_PATH=%PROJECT_ROOT%ohos\entry\build\default\outputs\default\entry-default-unsigned.hap
set BUNDLE_NAME=com.example.helloapp
set ABILITY_NAME=EntryAbility

:: Find hdc tool
set HDC=
if exist "C:\Users\%USERNAME%\AppData\Local\OpenHarmony\Sdk\20\toolchains\hdc.exe" (
    set HDC=C:\Users\%USERNAME%\AppData\Local\OpenHarmony\Sdk\20\toolchains\hdc.exe
) else if exist "F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe" (
    set HDC=F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe
) else (
    echo [Error] Cannot find hdc.exe
    echo Please check if HarmonyOS SDK is installed correctly.
    pause
    exit /b 1
)

echo Using hdc: %HDC%
echo.

:: Check if HAP exists
if not exist "%HAP_PATH%" (
    echo [Error] HAP file not found. Please run build.bat first.
    pause
    exit /b 1
)

:: Check device connection
echo [1/3] Checking device connection...
%HDC% list targets
if %ERRORLEVEL% NEQ 0 (
    echo [Error] No device detected. Please connect device or start emulator.
    pause
    exit /b 1
)
echo.

:: Install HAP
echo [2/3] Installing app to device...
%HDC% install -r "%HAP_PATH%"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Installation failed.
    pause
    exit /b 1
)
echo.

:: Launch app
echo [3/3] Launching app...
%HDC% shell aa start -a %ABILITY_NAME% -b %BUNDLE_NAME%
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
