@echo off
chcp 65001 >nul
echo ========================================
echo   Sync Shared Code to All Platforms
echo ========================================
echo.

set PROJECT_ROOT=%~dp0
set SOURCE_DIR=%PROJECT_ROOT%ohos\entry\src\main\ets

echo Source: %SOURCE_DIR%
echo.

echo [1/2] Syncing to Android...
if exist "%PROJECT_ROOT%android\app\src\main\ets" rd /s /q "%PROJECT_ROOT%android\app\src\main\ets"
xcopy /E /I /Q "%SOURCE_DIR%" "%PROJECT_ROOT%android\app\src\main\ets" >nul
echo   Done.

echo [2/2] Syncing to iOS...
if exist "%PROJECT_ROOT%ios\HelloApp\ets" rd /s /q "%PROJECT_ROOT%ios\HelloApp\ets"
xcopy /E /I /Q "%SOURCE_DIR%" "%PROJECT_ROOT%ios\HelloApp\ets" >nul
echo   Done.

echo.
echo ========================================
echo   Sync Complete!
echo ========================================
