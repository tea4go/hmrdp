@echo off
setlocal
set PROJECT_ROOT=%~dp0..\..\
set LOCAL_PROPS=%PROJECT_ROOT%android\local.properties
set SDK_PATH=

echo LOCAL_PROPS: %LOCAL_PROPS%
if exist "%LOCAL_PROPS%" (
    echo File exists
    for /f "usebackq tokens=2 delims==" %%a in (`findstr "sdk.dir" "%LOCAL_PROPS%"`) do (
        set "raw_path=%%a"
        echo raw_path: [%%a]
    )
    set "SDK_PATH=%raw_path:/=\%"
    echo After slash convert: [%SDK_PATH%]
    set "SDK_PATH=%SDK_PATH:\:=%"
    echo After colon fix: [%SDK_PATH%]
    set "SDK_PATH=%SDK_PATH:\=\%"
    echo After backslash fix: [%SDK_PATH%]
)
echo Final SDK_PATH: [%SDK_PATH%]
if defined SDK_PATH (
    set "ADB_EXE=%SDK_PATH%\platform-tools\adb.exe"
    echo ADB_EXE: [%ADB_EXE%]
    if exist "%ADB_EXE%" echo ADB exists!
)
endlocal
