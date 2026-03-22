@echo off
chcp 65001 >nul
echo ========================================
echo   iOS Build Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\

:: Sync code first
echo [1/2] Syncing shared code...
call %PROJECT_ROOT%sync-code.bat
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Code sync failed.
    pause
    exit /b 1
)

echo [2/2] iOS build requires macOS with Xcode.
echo.
echo Manual steps:
echo   1. Open ios/HelloApp.xcodeproj in Xcode
echo   2. Select target device or simulator
echo   3. Press Cmd+B to build
echo.
echo For command line build on macOS:
echo   cd ios && xcodebuild -project HelloApp.xcodeproj -scheme HelloApp -configuration Debug
echo.

pause
