@echo off
chcp 65001 >nul
echo ========================================
echo   HarmonyOS 应用安装运行脚本
echo ========================================
echo.

cd /d %~dp0

:: 设置变量
set HAP_PATH=%~dp0entry\build\default\outputs\default\entry-default-unsigned.hap
set BUNDLE_NAME=com.example.helloapp
set ABILITY_NAME=EntryAbility

:: 查找 hdc 工具
set HDC=
if exist "F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe" (
    set HDC=F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe
) else if exist "C:\Users\%USERNAME%\AppData\Local\OpenHarmony\Sdk\20\toolchains\hdc.exe" (
    set HDC=C:\Users\%USERNAME%\AppData\Local\OpenHarmony\Sdk\20\toolchains\hdc.exe
) else (
    echo [错误] 找不到 hdc.exe 工具
    echo 请检查 HarmonyOS SDK 是否正确安装
    pause
    exit /b 1
)

echo 使用 hdc: %HDC%
echo.

:: 检查 HAP 文件是否存在
if not exist "%HAP_PATH%" (
    echo [错误] HAP 文件不存在，请先运行 build.bat 编译项目
    pause
    exit /b 1
)

:: 检查设备连接
echo [1/3] 检查设备连接...
%HDC% list targets
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 没有检测到设备，请连接设备或启动模拟器
    pause
    exit /b 1
)
echo.

:: 安装 HAP
echo [2/3] 安装应用到设备...
%HDC% install -r "%HAP_PATH%"
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 安装失败
    pause
    exit /b 1
)
echo.

:: 启动应用
echo [3/3] 启动应用...
%HDC% shell aa start -a %ABILITY_NAME% -b %BUNDLE_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 启动失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo   应用已成功启动!
echo ========================================
echo.

pause
