@echo off
echo ========================================
echo   Sync ArkUI-X Shared Code
echo ========================================
echo.

set SCRIPT_DIR=%~dp0
set SOURCE_DIR=%SCRIPT_DIR%ohos\entry\src\main\ets

echo Source: %SOURCE_DIR%
echo.

echo [1/2] Syncing to Android...
if exist "%SCRIPT_DIR%android\app\src\main\ets" rd /s /q "%SCRIPT_DIR%android\app\src\main\ets"
xcopy /E /I /Q "%SOURCE_DIR%" "%SCRIPT_DIR%android\app\src\main\ets" >nul
echo   Done.

echo [2/2] Syncing to iOS...
if exist "%SCRIPT_DIR%ios\HelloApp\ets" rd /s /q "%SCRIPT_DIR%ios\HelloApp\ets"
xcopy /E /I /Q "%SOURCE_DIR%" "%SCRIPT_DIR%ios\HelloApp\ets" >nul
echo   Done.

echo.
echo ========================================
echo   Sync Complete!
echo ========================================
echo.
echo Synced directories:
echo   - android/app/src/main/ets/
echo   - ios/HelloApp/ets/
echo.
