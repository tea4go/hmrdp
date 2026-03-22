@echo off
chcp 65001 >nul
echo ========================================
echo   HarmonyOS HAP 编译脚本
echo ========================================
echo.

cd /d %~dp0

echo [1/2] 清理旧的构建缓存...
if exist "entry\build" rd /s /q "entry\build"

echo [2/2] 开始编译 HAP...
"C:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.bat" --no-daemon -p product=default -p module=entry@default assembleHap --analyze=normal --parallel --incremental

echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo   编译成功!
    echo ========================================
    echo.
    echo HAP 文件位置:
    echo %~dp0entry\build\default\outputs\default\entry-default-unsigned.hap
    echo.
) else (
    echo ========================================
    echo   编译失败! 请检查错误信息
    echo ========================================
    echo.
)

pause
