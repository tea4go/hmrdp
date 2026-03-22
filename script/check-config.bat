@echo off
chcp 65001 >nul
echo ========================================
echo   ArkUI-X Android Configuration Checker
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\
set PASS=0
set FAIL=0

echo Checking project configuration...
echo.

:: [1] 检查 HarmonyOS SDK 版本配置
echo [1/8] Checking HarmonyOS SDK version...
findstr /C:"compileSdkVersion.*12" "%PROJECT_ROOT%ohos\build-profile.json5" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   ✓ compileSdkVersion is 12
    set /a PASS+=1
) else (
    echo   ✗ compileSdkVersion is NOT 12
    echo     Fix: Set compileSdkVersion to 12 in ohos/build-profile.json5
    set /a FAIL+=1
)

:: [2] 检查 Android Adapter JAR
echo [2/8] Checking Android Adapter JAR...
if exist "%PROJECT_ROOT%android\app\libs\arkui_android_adapter.jar" (
    echo   ✓ arkui_android_adapter.jar found
    set /a PASS+=1
) else (
    echo   ✗ arkui_android_adapter.jar NOT found
    echo     Fix: Run script\setup-android.bat
    set /a FAIL+=1
)

:: [3] 检查插件库数量
echo [3/8] Checking plugin libraries in libs/arm64-v8a/...
set SO_COUNT=0
if exist "%PROJECT_ROOT%android\app\libs\arm64-v8a\*.so" (
    for /f %%A in ('dir /b "%PROJECT_ROOT%android\app\libs\arm64-v8a\*.so" 2^>nul ^| find /c /v ""') do set SO_COUNT=%%A
)
if %SO_COUNT% GEQ 60 (
    echo   ✓ Found %SO_COUNT% .so files (expected ~69)
    set /a PASS+=1
) else (
    echo   ✗ Only found %SO_COUNT% .so files (expected ~69)
    echo     Fix: Run script\setup-android.bat
    set /a FAIL+=1
)

:: [4] 检查关键库 libhilog.so
echo [4/8] Checking libhilog.so...
if exist "%PROJECT_ROOT%android\app\libs\arm64-v8a\libhilog.so" (
    echo   ✓ libhilog.so found
    set /a PASS+=1
) else (
    echo   ✗ libhilog.so NOT found
    echo     Fix: Run script\setup-android.bat
    set /a FAIL+=1
)

:: [5] 检查系统资源
echo [5/8] Checking system resources...
if exist "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\systemres\resources.index" (
    echo   ✓ System resources found
    set /a PASS+=1
) else (
    echo   ✗ System resources NOT found
    echo     Fix: Run script\setup-android.bat
    set /a FAIL+=1
)

:: [6] 检查 modules.abc
echo [6/8] Checking modules.abc...
if exist "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\entry\ets\modules.abc" (
    echo   ✓ modules.abc found
    set /a PASS+=1
) else (
    echo   ✗ modules.abc NOT found
    echo     Fix: Build HarmonyOS project, then run script\android\sync-assets.bat
    set /a FAIL+=1
)

:: [7] 检查 build.gradle jniLibs 配置
echo [7/8] Checking build.gradle jniLibs configuration...
findstr /C:"jniLibs.srcDirs" "%PROJECT_ROOT%android\app\build.gradle" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   ✓ jniLibs.srcDirs configured
    set /a PASS+=1
) else (
    echo   ✗ jniLibs.srcDirs NOT configured
    echo     Fix: Add 'jniLibs.srcDirs = ['libs']' in build.gradle
    set /a FAIL+=1
)

:: [8] 检查 deviceTypes
echo [8/8] Checking deviceTypes...
findstr /C:"2in1" "%PROJECT_ROOT%ohos\entry\src\main\module.json5" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ✓ No unsupported device types
    set /a PASS+=1
) else (
    echo   ✗ Found unsupported device type '2in1'
    echo     Fix: Remove '2in1' from deviceTypes in module.json5
    set /a FAIL+=1
)

:: 输出结果
echo.
echo ========================================
echo   Check Results
echo ========================================
echo.
echo   Passed: %PASS% / 8
echo   Failed: %FAIL% / 8
echo.

if %FAIL% EQU 0 (
    echo ✅ All checks passed! Project is ready to build.
    echo.
    echo Next steps:
    echo   1. Build HarmonyOS project in DevEco Studio
    echo   2. Run script\android\sync-assets.bat
    echo   3. Run script\android\build-and-run.bat
) else (
    echo ❌ Some checks failed. Please fix the issues above.
    echo.
    echo Quick fix: Run script\setup-android.bat
)

echo.

pause
