@echo off
chcp 65001 >nul
echo ========================================
echo   HarmonyOS 一键编译运行脚本
echo ========================================
echo.

cd /d %~dp0

:: 编译
echo [阶段 1] 编译项目...
echo ========================================
call build.bat
if %ERRORLEVEL% NEQ 0 (
    echo 编译失败，终止操作
    pause
    exit /b 1
)

echo.
echo [阶段 2] 安装并运行...
echo ========================================
call run.bat

pause
