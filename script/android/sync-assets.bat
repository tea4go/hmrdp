@echo off
chcp 65001 >nul
echo ========================================
echo   Sync HarmonyOS Build Artifacts to Android
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\
set OHOS_BUILD=%PROJECT_ROOT%ohos\entry\build\default\intermediates\loader_out\default\ets\
set ANDROID_ASSETS=%PROJECT_ROOT%android\app\src\main\assets\arkui-x\entry\ets\

:: 检查 HarmonyOS 编译输出
if not exist "%OHOS_BUILD%modules.abc" (
    echo [Error] HarmonyOS build not found!
    echo.
    echo Expected location:
    echo %OHOS_BUILD%modules.abc
    echo.
    echo Please build HarmonyOS project in DevEco Studio first:
    echo   1. Open DevEco Studio
    echo   2. Click Build ^> Build Hap(s)/APP(s) ^> Build Hap(s)
    echo   3. Wait for build to complete
    echo   4. Run this script again
    echo.
    pause
    exit /b 1
)

:: 同步 modules.abc
echo [1/2] Syncing modules.abc...
echo   From: %OHOS_BUILD%modules.abc
echo   To:   %ANDROID_ASSETS%modules.abc
copy /Y "%OHOS_BUILD%modules.abc" "%ANDROID_ASSETS%modules.abc" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Failed to sync modules.abc
    pause
    exit /b 1
)
echo   Done.

:: 同步 sourceMaps.map
echo [2/2] Syncing sourceMaps.map...
echo   From: %OHOS_BUILD%sourceMaps.map
echo   To:   %ANDROID_ASSETS%sourceMaps.map
copy /Y "%OHOS_BUILD%sourceMaps.map" "%ANDROID_ASSETS%sourceMaps.map" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Failed to sync sourceMaps.map
    pause
    exit /b 1
)
echo   Done.

echo.
echo ========================================
echo   Assets Sync Complete!
echo ========================================
echo.
echo Synced files:
echo   ✓ modules.abc      - ArkTS bytecode
echo   ✓ sourceMaps.map   - Source map for debugging
echo.
echo File sizes:
for %%F in ("%ANDROID_ASSETS%modules.abc") do echo   modules.abc: %%~zF bytes
for %%F in ("%ANDROID_ASSETS%sourceMaps.map") do echo   sourceMaps.map: %%~zF bytes
echo.

pause
