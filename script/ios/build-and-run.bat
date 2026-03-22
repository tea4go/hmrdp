@echo off
chcp 65001 >nul
echo ========================================
echo   iOS Build and Run Script
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\

echo iOS build and run requires macOS with Xcode.
echo.
echo Manual steps:
echo   1. Open ios/HelloApp.xcodeproj in Xcode
echo   2. Select target simulator
echo   3. Press Cmd+R to build and run
echo.
echo For command line on macOS:
echo   cd script/ios && ./build.sh
echo.

pause
