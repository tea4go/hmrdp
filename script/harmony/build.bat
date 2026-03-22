@echo off
chcp 65001 >nul
echo ========================================
echo   HarmonyOS HAP Build Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\
cd /d %PROJECT_ROOT%ohos

echo [1/2] Cleaning old build cache...
if exist "entry\build" rd /s /q "entry\build"

echo [2/2] Building HAP...
"C:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.bat" --no-daemon -p product=default -p module=entry@default assembleHap --analyze=normal --parallel --incremental

echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo   Build Success!
    echo ========================================
    echo.
    echo HAP Location:
    echo %PROJECT_ROOT%ohos\entry\build\default\outputs\default\entry-default-unsigned.hap
    echo.
) else (
    echo ========================================
    echo   Build Failed! Check error messages.
    echo ========================================
    echo.
)

pause
