@echo off
chcp 65001 >nul
echo ========================================
echo   ArkUI-X Android Project Setup
echo ========================================
echo.
echo This script will copy all required libraries and resources
echo from ArkUI-X SDK to your Android project.
echo.

set PROJECT_ROOT=%~dp0..\
set SDK_PATH=C:\Users\%USERNAME%\AppData\Local\Temp\arkui-x-sdk-extracted\arkui-x

:: 检查 SDK
if not exist "%SDK_PATH%" (
    echo [Error] ArkUI-X SDK not found!
    echo.
    echo Expected location:
    echo %SDK_PATH%
    echo.
    echo Please download and extract ArkUI-X SDK first.
    echo Visit: https://gitee.com/arkui-x/docs
    echo.
    pause
    exit /b 1
)

echo SDK found: %SDK_PATH%
echo Project root: %PROJECT_ROOT%
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

:: [1/5] 复制 Android Adapter
echo.
echo [1/5] Copying Android Adapter JAR...
if not exist "%PROJECT_ROOT%android\app\libs" mkdir "%PROJECT_ROOT%android\app\libs"
copy /Y "%SDK_PATH%\engine\arkui_android_adapter.jar" "%PROJECT_ROOT%android\app\libs\" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Failed to copy arkui_android_adapter.jar
    pause
    exit /b 1
)
echo   ✓ arkui_android_adapter.jar

:: [2/5] 复制插件库到 libs/arm64-v8a/
echo [2/5] Copying plugin libraries to libs/arm64-v8a/...
if not exist "%PROJECT_ROOT%android\app\libs\arm64-v8a" mkdir "%PROJECT_ROOT%android\app\libs\arm64-v8a"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm64\android-arm64-release\*.so" "%PROJECT_ROOT%android\app\libs\arm64-v8a\" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [Warning] arm64-v8a libraries not found in SDK
) else (
    echo   ✓ arm64-v8a libraries copied
)

:: 复制插件库到 libs/armeabi-v7a/
echo [3/5] Copying plugin libraries to libs/armeabi-v7a/...
if not exist "%PROJECT_ROOT%android\app\libs\armeabi-v7a" mkdir "%PROJECT_ROOT%android\app\libs\armeabi-v7a"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm\android-arm-release\*.so" "%PROJECT_ROOT%android\app\libs\armeabi-v7a\" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [Warning] armeabi-v7a libraries not found in SDK
) else (
    echo   ✓ armeabi-v7a libraries copied
)

:: 复制插件库到 libs/x86_64/
echo [4/5] Copying plugin libraries to libs/x86_64/...
if not exist "%PROJECT_ROOT%android\app\libs\x86_64" mkdir "%PROJECT_ROOT%android\app\libs\x86_64"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\x86_64\android-x86_64-release\*.so" "%PROJECT_ROOT%android\app\libs\x86_64\" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [Warning] x86_64 libraries not found in SDK
) else (
    echo   ✓ x86_64 libraries copied
)

:: [5/5] 复制系统资源
echo [5/5] Copying system resources...
if not exist "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\systemres" mkdir "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\systemres"
xcopy /E /I /Y "%SDK_PATH%\engine\systemres\*" "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\systemres\" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [Warning] System resources not found in SDK
) else (
    echo   ✓ System resources copied
)

:: 统计文件数量
echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Copied files:
for /f %%A in ('dir /b "%PROJECT_ROOT%android\app\libs\arm64-v8a\*.so" 2^>nul ^| find /c /v ""') do echo   %%A .so files in libs/arm64-v8a/
for /f %%A in ('dir /b "%PROJECT_ROOT%android\app\libs\armeabi-v7a\*.so" 2^>nul ^| find /c /v ""') do echo   %%A .so files in libs/armeabi-v7a/
for /f %%A in ('dir /b "%PROJECT_ROOT%android\app\libs\x86_64\*.so" 2^>nul ^| find /c /v ""') do echo   %%A .so files in libs/x86_64/
echo   1 JAR file in libs/
echo.
echo Next steps:
echo   1. Configure ohos/build-profile.json5:
echo      - Set compileSdkVersion to 12
echo      - Set compatibleSdkVersion to 12
echo.
echo   2. Build HarmonyOS project in DevEco Studio
echo      - Click Build ^> Build Hap(s)/APP(s) ^> Build Hap(s)
echo.
echo   3. Sync build artifacts to Android:
echo      - Run script\android\sync-assets.bat
echo.
echo   4. Build and run on Android device:
echo      - Run script\android\build-and-run.bat
echo.
echo Optional: Copy libraries to assets/ (backup location)
echo   - Some projects may need .so files in both libs/ and assets/
echo   - If you encounter "library not found" errors, run:
echo     xcopy /E /I /Y "android\app\libs\*.so" "android\app\src\main\assets\arkui-x\libs\"
echo.

pause
