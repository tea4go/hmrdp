# ArkUI-X Android 编译参考手册

> 核心理念：一套代码，多端运行（HarmonyOS、Android、iOS）

## 目录

1. [环境准备](#1-环境准备)
2. [项目结构](#2-项目结构)
3. [完整配置清单](#3-完整配置清单)
4. [已知问题及解决方案](#4-已知问题及解决方案)
5. [自动化脚本](#5-自动化脚本)
6. [新项目快速启动](#6-新项目快速启动)
7. [故障排查](#7-故障排查)

---

## 1. 环境准备

### 1.1 必需软件

| 软件 | 版本要求 | 用途 |
|------|---------|------|
| DevEco Studio | 4.0+ | HarmonyOS 开发和编译 ArkTS 代码 |
| Android Studio | 最新版 | Android 开发 |
| JDK | 8 或 11 | Android 编译 |
| Node.js | 14+ | ArkUI-X 工具链 |

### 1.2 ArkUI-X SDK

- **下载地址**: https://gitee.com/arkui-x/docs
- **版本**: 2.0.0.27 Beta1 或更新
- **安装位置**: 默认 `C:\Users\<用户名>\AppData\Local\Temp\arkui-x-sdk-extracted\arkui-x\`

### 1.3 环境变量

```bash
# ArkUI-X SDK 路径
ARKUIX_SDK_HOME=C:\Users\<用户名>\AppData\Local\Temp\arkui-x-sdk-extracted\arkui-x

# Android SDK 路径（在 android/local.properties 中配置）
sdk.dir=C\:/Users/Public/Documents/Embarcadero/Studio/23.0/PlatformSDKs/android-sdk-windows
```

---

## 2. 项目结构

### 2.1 标准跨平台目录结构

```
project/
├── ohos/                          # HarmonyOS 原生项目
│   ├── entry/
│   │   ├── src/main/
│   │   │   ├── ets/               # ⭐ ArkTS 源代码（主代��库）
│   │   │   │   ├── entryability/
│   │   │   │   │   └── EntryAbility.ts
│   │   │   │   └── pages/
│   │   │   │       └── Index.ets
│   │   │   ├── resources/
│   │   │   └── module.json5
│   │   └── build/                 # ⭐ 编译输出（包含 modules.abc）
│   │       └── default/intermediates/loader_out/default/ets/
│   │           ├── modules.abc    # ArkTS 字节码
│   │           └── sourceMaps.map
│   └── build-profile.json5        # ⭐ SDK 版本配置
│
├── android/                       # Android 原生项目
│   ├── app/
│   │   ├── libs/                  # ⭐ jniLibs 目录（关键！）
│   │   │   ├── arm64-v8a/         # 64位 ARM 库
│   │   │   │   ├── libarkui_android.so
│   │   │   │   ├── libhilog.so    # 必需！
│   │   │   │   └── ... (69个插件库)
│   │   │   ├── armeabi-v7a/
│   │   │   └── x86_64/
│   │   │   └── arkui_android_adapter.jar
│   │   │
│   │   └── src/main/
│   │       ├── assets/arkui-x/    # ⭐ ArkUI 运行时资源
│   │       │   ├── entry/
│   │       │   │   ├── ets/
│   │       │   │   │   ├── modules.abc       # 从 ohos 编译输出复制
│   │       │   │   │   └── sourceMaps.map
│   │       │   │   ├── module.json
│   │       │   │   └── resources.index
│   │       │   ├── libs/          # 插件库备份（可选）
│   │       │   └── systemres/     # 系统资源
│   │       │       └── resources.index
│   │       └── java/com/hmrdp/
│   │           ├── MainApplication.java
│   │           └── EntryEntryAbilityActivity.java
│   ├── build.gradle
│   └── local.properties
│
├── ios/                           # iOS 原生项目（可选）
│
└── script/                        # 自动化脚本
    ├── android/
    │   ├── build.bat              # Android 编译脚本
    │   ├── run.bat                # Android 运行脚本
    │   ├── build-and-run.bat      # 一键编译运行
    │   └── sync-assets.bat        # 资源同步脚本
    └── sync-code.bat              # 代码同步脚本
```

### 2.2 关键文件说明

| 文件 | 作用 | 重要程度 |
|------|------|---------|
| `ohos/build-profile.json5` | 控制 HarmonyOS SDK 版本，影响 ABC 字节码版本 | ⭐⭐⭐⭐⭐ |
| `android/app/libs/arm64-v8a/*.so` | 插件原生库，必须放在此处才能被加载 | ⭐⭐⭐⭐⭐ |
| `android/app/src/main/assets/arkui-x/entry/ets/modules.abc` | ArkTS 编译后的字节码 | ⭐⭐⭐⭐⭐ |
| `android/app/build.gradle` | Android 配置，包含 jniLibs 路径 | ⭐⭐⭐⭐ |

---

## 3. 完整配置清单

### 3.1 HarmonyOS 配置

#### `ohos/build-profile.json5` ⭐ 最关键

```json5
{
  "app": {
    "signingConfigs": [],
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compileSdkVersion": 12,        // ⭐ 必须是 12！不能是 20
        "compatibleSdkVersion": 12      // ⭐ 必须是 12！
      }
    ]
  },
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",
      "targets": [
        {
          "name": "default",
          "applyToProducts": [
            "default"
          ]
        }
      ]
    }
  ]
}
```

**⚠️ 重要说明**：
- `compileSdkVersion` 必须设为 `12`
- 如果设为 `20`，会生成 ABC 文件版本 `13.0.1.0`
- Android 运行时最大支持 ABC 文件版本 `12.0.4.0`
- 版本不匹配会导致应用启动时崩溃

#### `ohos/entry/src/main/module.json5`

```json5
{
  "module": {
    "name": "entry",
    "type": "entry",
    "description": "$string:module_desc",
    "mainElement": "EntryAbility",
    "deviceTypes": [
      "default",
      "tablet"
      // ⭐ 不要包含 "2in1"，API 12 不支持
    ],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ts",
        "description": "$string:EntryAbility_desc",
        "icon": "$media:icon",
        "label": "$string:EntryAbility_label",
        "startWindowIcon": "$media:startIcon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": [
              "entity.system.home"
            ],
            "actions": [
              "action.system.home"
            ]
          }
        ]
      }
    ]
  }
}
```

### 3.2 Android 配置

#### `android/app/build.gradle`

```gradle
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.hmrdp'
    compileSdk 33

    defaultConfig {
        applicationId "com.example.hmrdp"  // ⭐ 注意包名
        minSdk 24
        targetSdk 33
        versionCode 1
        versionName "1.0"

        ndk {
            abiFilters 'arm64-v8a', 'armeabi-v7a', 'x86_64'
        }
    }

    sourceSets {
        main {
            jniLibs.srcDirs = ['libs']  // ⭐ 关键配置！
        }
    }

    packagingOptions {
        jniLibs {
            useLegacyPackaging true
        }
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation fileTree(dir: 'libs', include: ['*.jar'])
}
```

**关键点**：
- `jniLibs.srcDirs = ['libs']` 确保插件库被打包到 APK 的 `lib/arm64/` 目录
- `applicationId` 要与 Activity 类名匹配

#### `android/app/src/main/AndroidManifest.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:name=".MainApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@android:style/Theme.Light.NoTitleBar"
        android:usesCleartextTraffic="true">

        <activity
            android:name=".EntryEntryAbilityActivity"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:exported="true"
            android:hardwareAccelerated="true"
            android:launchMode="singleTop"
            android:windowSoftInputMode="adjustNothing|stateHidden"
            android:theme="@android:style/Theme.Light.NoTitleBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

**命名规则**：
- Activity 类名格式：`<ModuleName><AbilityName>Activity`
- 例如：`Entry` + `EntryAbility` = `EntryEntryAbilityActivity`

#### `android/app/src/main/java/com/hmrdp/EntryEntryAbilityActivity.java`

```java
package com.hmrdp;

import android.os.Bundle;
import android.util.Log;
import ohos.stage.ability.adapter.StageActivity;

public class EntryEntryAbilityActivity extends StageActivity {
    private static final String TAG = "Hmrdp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(TAG, "EntryEntryAbilityActivity onCreate");
        // ⭐ 格式：bundleName:moduleName:abilityName:
        setInstanceName("com.example.hmrdp:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
        Log.i(TAG, "StageActivity created with instance: com.example.hmrdp:entry:EntryAbility:");
    }
}
```

**关键点**：
- `setInstanceName` 必须以冒号结尾
- 格式：`applicationId:moduleName:abilityName:`

#### `android/app/src/main/java/com/hmrdp/MainApplication.java`

```java
package com.hmrdp;

import ohos.stage.ability.adapter.StageApplication;

public class MainApplication extends StageApplication {
}
```

---

## 4. 已知问题及解决方案

### 问题 1: ABC 文件版本不匹配 ⭐⭐⭐⭐⭐

**错误日志**:
```
E ArkCompiler: abc file version 13.0.1.0.
              Maximum supported abc file version on the current system image is 12.0.4.0
```

**原因**:
- `ohos/build-profile.json5` 中 `compileSdkVersion` 设为 `20`
- 生成的 ABC 字节码版本为 `13.0.1.0`
- Android 运行时最大支持 `12.0.4.0`

**解决方案**:
```json5
// ohos/build-profile.json5
{
  "app": {
    "products": [
      {
        "compileSdkVersion": 12,        // 改为 12
        "compatibleSdkVersion": 12      // 改为 12
      }
    ]
  }
}
```

**验证步骤**:
1. 修改后重新编译 HarmonyOS 项目
2. 检查生成的 ABC 文件版本
3. 同步到 Android assets

---

### 问题 2: modules.abc 未同步到 Android ⭐⭐⭐⭐⭐

**现象**:
- 修改了 ArkTS 代码，但 Android 运行的还是旧代码
- 日志显示找不到页面或功能不更新

**原因**:
- `sync-code.bat` 只同步源代码，不同步编译产物
- `modules.abc` 需要手动从 HarmonyOS 编译输出复制

**解决方案**:

**方法 1: 手动复制（推荐）**
```bash
# HarmonyOS 编译输出位置
SOURCE=ohos/entry/build/default/intermediates/loader_out/default/ets/

# Android assets 目标位置
TARGET=android/app/src/main/assets/arkui-x/entry/ets/

# 复制文件
copy %SOURCE%\modules.abc %TARGET%
copy %SOURCE%\sourceMaps.map %TARGET%
```

**方法 2: 自动化脚本（见第5章）**

---

### 问题 3: 缺少插件原生库 ⭐⭐⭐⭐⭐

**错误日志**:
```
E NAPI: dlopen failed: library "/data/app/.../lib/arm64/libhilog.so" not found
E NAPI: Second attempt: load module failed. dlopen failed:
       library "/data/user/0/com.example.hmrdp/files/arkui-x/libs/arm64-v8a/libhilog.so" not found
```

**原因**:
- 插件库（69个 .so 文件）未放置到正确位置
- Android NAPI 查找顺序：
  1. `/data/app/.../lib/arm64/` （APK 内置）
  2. `/data/user/0/<app>/files/arkui-x/libs/arm64-v8a/` （运行时提取）

**解决方案**:

插件库需要放在 **两个位置**：

**位置 1: `android/app/libs/arm64-v8a/` （必需）**
```
android/app/libs/
├── arm64-v8a/
│   ├── libarkui_android.so      # 核心引擎
│   ├── libhilog.so              # 日志模块
│   ├── libanimator.so
│   ├── librouter.so
│   └── ... (共 69 个 .so 文件)
├── armeabi-v7a/
└── x86_64/
```

**位置 2: `android/app/src/main/assets/arkui-x/libs/arm64-v8a/` （备份）**
```
android/app/src/main/assets/arkui-x/libs/
├── arm64-v8a/
│   └── ... (同样的 69 个 .so 文件)
├── armeabi-v7a/
└── x86_64/
```

**获取插件库**:
```bash
# 从 ArkUI-X SDK 复制
SDK_PATH=C:\Users\<用户名>\AppData\Local\Temp\arkui-x-sdk-extracted\arkui-x

# 复制到 libs/
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm64\android-arm64-release\*.so" "android\app\libs\arm64-v8a\"

# 复制到 assets/
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm64\android-arm64-release\*.so" "android\app\src\main\assets\arkui-x\libs\arm64-v8a\"
```

**验证**:
```bash
# 检查 APK 中的库文件
unzip -l android/app/build/outputs/apk/debug/app-debug.apk | grep "lib/arm64"
# 应该看到 69 个 .so 文件
```

---

### 问题 4: 缺少系统资源 ⭐⭐⭐

**错误日志**:
```
E Ace: failed to realpath the path,
     /data/user/0/com.example.hmrdp/files/arkui-x/systemres/resources.index, errno:2
```

**原因**:
- 缺少 ArkUI 系统资源文件

**解决方案**:
```bash
# 从 SDK 复制系统资源
SDK_PATH=C:\Users\<用户名>\AppData\Local\Temp\arkui-x-sdk-extracted\arkui-x

xcopy /E /I /Y "%SDK_PATH%\engine\systemres\*" "android\app\src\main\assets\arkui-x\systemres\"
```

**目录结构**:
```
android/app/src/main/assets/arkui-x/
└── systemres/
    └── resources.index
```

---

### 问题 5: run.bat 脚本配置错误 ⭐⭐⭐

**错误日志**:
```
Error: Activity class {com.hmrdp/com.hmrdp.MainActivity} does not exist
```

**原因**:
1. Activity 类名错误（`MainActivity` vs `EntryEntryAbilityActivity`）
2. 包名错误（`com.hmrdp` vs `com.example.hmrdp`）
3. 安装后立即启动，设备还未完成安装

**解决方案**:

`script/android/run.bat`:
```batch
@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

set PROJECT_ROOT=%~dp0..\..\
set APK_PATH=%PROJECT_ROOT%android\app\build\outputs\apk\debug\app-debug.apk
set PACKAGE_NAME=com.example.hmrdp                    REM ⭐ 使用 applicationId
set ACTIVITY_NAME=com.hmrdp.EntryEntryAbilityActivity REM ⭐ 完整类名

:: 检测设备
echo [1/3] Checking device connection...
"%ADB_EXE%" devices

:: 安装 APK
echo [2/3] Installing app to device...
"%ADB_EXE%" install -r "%APK_PATH%"

:: ⭐ 等待 5 秒，让设备完成安装
echo Waiting for installation to complete (5 seconds)...
ping 127.0.0.1 -n 6 >nul

:: 启动应用
echo [3/3] Launching app...
"%ADB_EXE%" shell am start -n %PACKAGE_NAME%/%ACTIVITY_NAME%
```

**关键修改**:
1. `PACKAGE_NAME` = `com.example.hmrdp` （与 `applicationId` 一致）
2. `ACTIVITY_NAME` = `com.hmrdp.EntryEntryAbilityActivity` （完整类名）
3. 添加 5 秒等待时间

---

### 问题 6: module.json5 设备类型不支持 ⭐⭐

**错误日志**:
```
The intersection of the system capability sets configured for multiple devices is empty
```

**原因**:
- `deviceTypes` 包含 `2in1`，但 API 12 不支持该设备类型

**解决方案**:

`ohos/entry/src/main/module.json5`:
```json5
{
  "module": {
    "deviceTypes": [
      "default",
      "tablet"
      // ⭐ 移除 "2in1"
    ]
  }
}
```

---

### 问题 7: UI 不渲染，显示空白屏幕 ⭐⭐⭐⭐⭐

**错误日志**:
```
E Ace: [js_ability.cpp(OnWindowStageCreated)] Failed to create jsAppWindowStage object
E ArkCompiler: TypeError: Cannot read property info of undefined
    at onCreate (EntryAbility.ts:6:9)
W Ace: Window ... uiContent_ is nullptr
```

**原因**:
- `hilog` 模块加载失败（见问题 3）
- 导致 `EntryAbility.ts` 中 `onCreate` 方法异常
- `onWindowStageCreated` 未执行
- `windowStage.loadContent('pages/Index')` 未调用
- UI 未渲染

**解决方案**:
参考问题 3，确保所有插件库（特别是 `libhilog.so`）都正确放置。

**验证日志**:
```
✅ 正确：
I NAPI: [native_module_manager.cpp(LoadModuleLibrary)] path: /data/app/.../lib/arm64/libhilog.so
D NAPI: [native_module_manager.cpp(Register)] native module name is 'hilog'

❌ 错误：
E NAPI: dlopen failed: library ".../libhilog.so" not found
```

---

## 5. 自动化脚本

### 5.1 资源同步脚本 `script/android/sync-assets.bat`

```batch
@echo off
chcp 65001 >nul
echo ========================================
echo   Sync HarmonyOS Build Artifacts to Android
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\..\
set OHOS_BUILD=%PROJECT_ROOT%ohos\entry\build\default\intermediates\loader_out\default\ets\
set ANDROID_ASSETS=%PROJECT_ROOT%android\app\src\main\assets\arkui-x\entry\ets\

:: 检查 HarmonyOS 编译输出
if not exist "%OHOS_BUILD%modules.abc" (
    echo [Error] HarmonyOS build not found!
    echo Please build HarmonyOS project in DevEco Studio first.
    pause
    exit /b 1
)

:: 同步 modules.abc
echo [1/2] Syncing modules.abc...
copy /Y "%OHOS_BUILD%modules.abc" "%ANDROID_ASSETS%modules.abc"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Failed to sync modules.abc
    pause
    exit /b 1
)

:: 同步 sourceMaps.map
echo [2/2] Syncing sourceMaps.map...
copy /Y "%OHOS_BUILD%sourceMaps.map" "%ANDROID_ASSETS%sourceMaps.map"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Failed to sync sourceMaps.map
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Assets Sync Complete!
echo ========================================
echo.
echo Synced files:
echo   - modules.abc
echo   - sourceMaps.map
echo.

pause
```

### 5.2 完整构建脚本 `script/android/build.bat` （更新版）

```batch
@echo off
chcp 65001 >nul
echo ========================================
echo   Android APK Build Script
echo ========================================
echo.

set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..\..\
set ANDROID_DIR=%PROJECT_ROOT%android

:: [1/4] 同步源代码
echo [1/4] Syncing shared code...
call "%PROJECT_ROOT%sync-code.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Code sync failed.
    pause
    exit /b 1
)

:: [2/4] 同步编译产物
echo [2/4] Syncing HarmonyOS build artifacts...
call "%SCRIPT_DIR%sync-assets.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Assets sync failed.
    echo Please build HarmonyOS project first.
    pause
    exit /b 1
)

:: [3/4] 清理旧构建
echo [3/4] Cleaning old build...
if exist "%ANDROID_DIR%\app\build" rd /s /q "%ANDROID_DIR%\app\build"

:: [4/4] 构建 APK
echo [4/4] Building APK...
cd /d "%ANDROID_DIR%"
"%ANDROID_DIR%\gradlew.bat" assembleDebug

echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo   Build Success!
    echo ========================================
    echo.
    echo APK Location:
    echo %ANDROID_DIR%\app\build\outputs\apk\debug\app-debug.apk
    echo.
) else (
    echo ========================================
    echo   Build Failed! Check error messages.
    echo ========================================
    echo.
)

pause
```

### 5.3 一键编译运行 `script/android/build-and-run.bat`

```batch
@echo off
chcp 65001 >nul
echo ========================================
echo   Build and Run on Android Device
echo ========================================
echo.

set SCRIPT_DIR=%~dp0

:: 构建
echo Step 1: Building APK...
call "%SCRIPT_DIR%build.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [Error] Build failed.
    pause
    exit /b 1
)

echo.
echo Step 2: Installing and launching app...
call "%SCRIPT_DIR%run.bat"

pause
```

---

## 6. 新项目快速启动

### 6.1 创建新项目检查清单

#### 第一步：创建项目

- [ ] 使用 DevEco Studio 创建 HarmonyOS 项目
- [ ] 使用 Android Studio 创建 Android 项目
- [ ] 配置 ArkUI-X SDK

#### 第二步：配置 HarmonyOS

- [ ] 修改 `ohos/build-profile.json5`
  ```json5
  "compileSdkVersion": 12,
  "compatibleSdkVersion": 12
  ```
- [ ] 修改 `ohos/entry/src/main/module.json5`
  ```json5
  "deviceTypes": ["default", "tablet"]
  ```
- [ ] 编写 ArkTS 代码（`ohos/entry/src/main/ets/`）
- [ ] 在 DevEco Studio 中编译项目

#### 第三步：配置 Android

- [ ] 复制 `arkui_android_adapter.jar` 到 `android/app/libs/`
- [ ] 配置 `android/app/build.gradle`
  ```gradle
  sourceSets {
      main {
          jniLibs.srcDirs = ['libs']
      }
  }
  ```
- [ ] 复制插件库到 `android/app/libs/arm64-v8a/`（69个 .so 文件）
- [ ] 复制插件库到 `android/app/src/main/assets/arkui-x/libs/arm64-v8a/`
- [ ] 复制系统资源到 `android/app/src/main/assets/arkui-x/systemres/`
- [ ] 创建 `MainApplication.java` 继承 `StageApplication`
- [ ] 创建 Activity 继承 `StageActivity`
  ```java
  setInstanceName("com.your.package:entry:EntryAbility:");
  ```
- [ ] 更新 `AndroidManifest.xml`

#### 第四步：同步资源

- [ ] 复制 `modules.abc` 和 `sourceMaps.map` 从 HarmonyOS 编译输出到 Android assets
- [ ] 复制 `module.json` 和 `resources.index`
- [ ] 复制 `resources/` 目录

#### 第五步：测试

- [ ] 连接 Android 设备
- [ ] 运行 `build-and-run.bat`
- [ ] 检查 logcat 日志
- [ ] 验证 UI 显示

### 6.2 自动化脚本模板

创建 `script/setup-android.bat`:

```batch
@echo off
chcp 65001 >nul
echo ========================================
echo   ArkUI-X Android Project Setup
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..\
set SDK_PATH=C:\Users\%USERNAME%\AppData\Local\Temp\arkui-x-sdk-extracted\arkui-x

:: 检查 SDK
if not exist "%SDK_PATH%" (
    echo [Error] ArkUI-X SDK not found!
    echo Expected location: %SDK_PATH%
    pause
    exit /b 1
)

:: [1/4] 复制 Android Adapter
echo [1/4] Copying Android Adapter...
copy /Y "%SDK_PATH%\engine\arkui_android_adapter.jar" "%PROJECT_ROOT%android\app\libs\"

:: [2/4] 复制插件库到 libs/
echo [2/4] Copying plugin libraries to libs/...
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm64\android-arm64-release\*.so" "%PROJECT_ROOT%android\app\libs\arm64-v8a\"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm\android-arm-release\*.so" "%PROJECT_ROOT%android\app\libs\armeabi-v7a\"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\x86_64\android-x86_64-release\*.so" "%PROJECT_ROOT%android\app\libs\x86_64\"

:: [3/4] 复制插件库到 assets/
echo [3/4] Copying plugin libraries to assets/...
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm64\android-arm64-release\*.so" "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\libs\arm64-v8a\"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\arm\android-arm-release\*.so" "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\libs\armeabi-v7a\"
xcopy /E /I /Y "%SDK_PATH%\plugins\api\lib\x86_64\android-x86_64-release\*.so" "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\libs\x86_64\"

:: [4/4] 复制系统资源
echo [4/4] Copying system resources...
xcopy /E /I /Y "%SDK_PATH%\engine\systemres\*" "%PROJECT_ROOT%android\app\src\main\assets\arkui-x\systemres\"

echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Build HarmonyOS project in DevEco Studio
echo 2. Run script\android\sync-assets.bat
echo 3. Run script\android\build-and-run.bat
echo.

pause
```

---

## 7. 故障排查

### 7.1 常用调试命令

#### 查看 logcat 日志
```bash
# 清空日志
adb logcat -c

# 查看特定标签
adb logcat -s "Ace:*" "NAPI:*" "ArkCompiler:*" "Hmrdp:*"

# 查看应用进程
adb shell pidof com.example.hmrdp

# 实时日志
adb logcat | grep -E "(hmrdp|Ace|NAPI)"
```

#### 检查 APK 内容
```bash
# 列出 APK 中的库文件
unzip -l app-debug.apk | grep "lib/arm64"

# 列出 APK 中的 assets
unzip -l app-debug.apk | grep "arkui-x"
```

#### 检查设备上的文件
```bash
# 列出应用数据目录
adb shell "run-as com.example.hmrdp ls -R /data/user/0/com.example.hmrdp/files/arkui-x/"

# 检查库文件是否存在
adb shell "run-as com.example.hmrdp ls /data/app/*/lib/arm64/"
```

### 7.2 常见错误速查表

| 错误信息 | 原因 | 解决方案 |
|---------|------|---------|
| `abc file version 13.0.1.0` | SDK 版本过高 | 降低 `compileSdkVersion` 到 12 |
| `library ".../libhilog.so" not found` | 插件库缺失 | 复制 69 个 .so 文件到 `libs/arm64-v8a/` |
| `Activity class does not exist` | Activity 名称错误 | 检查包名和类名 |
| `uiContent_ is nullptr` | UI 未渲染 | 检查 `modules.abc` 和插件库 |
| `deviceTypes` 不支持 | 设备类型错误 | 移除 `2in1` |
| `failed to realpath ... systemres` | 系统资源缺失 | 复制 `systemres/` 目录 |

### 7.3 成功运行的日志特征

```
✅ 正常启动日志：
I StageApplication: StageApplication onCreate called
I Ace: [app_main.cpp(HandleDispatchOnCreate)] HandleDispatchOnCreate called
D NAPI: [native_module_manager.cpp(Register)] native module name is 'hilog'
I Ace: [js_ability.cpp(OnWindowStageCreated)] OnWindowStageCreated begin
I Ace: [ui_content_impl.cpp(InitializeInner)] InitializeInner startUrl = pages/Index
D ArkCompiler: [default] start to execute ark file: entry/ets/pages/Index.abc
I Ace: [page_router_manager.cpp(LoadPage)] Page router manager is loading page[1]: pages/Index
```

### 7.4 联系与支持

- **ArkUI-X 官方文档**: https://gitee.com/arkui-x/docs
- **HarmonyOS 开发者文档**: https://developer.harmonyos.com
- **问题反馈**: 项目 Issue Tracker

---

## 附录 A: 完整文件清单

### A.1 必需文件

#### Android libs/ 目录（69个插件库）
```
android/app/libs/arm64-v8a/
├── libabilityaccessctrl.so
├── libanimator.so
├── libarkui_android.so
├── libarkui_componentsnapshot.so
├── libarkui_componentutils.so
├── libarkui_drawabledescriptor.so
├── libarkui_performancemonitor.so
├── libbridge.so
├── libbuffer.so
├── libcommoneventmanager.so
├── libconfiguration.so
├── libconvertxml.so
├── libcrypto_openssl.so
├── libcurl_shared.so
├── libdata_preferences.so
├── libdata_relationalstore.so
├── libdeviceinfo.so
├── libdisplay.so
├── libevents_emitter.so
├── libfile_fs.so
├── libfile_photoaccesshelper.so
├── libfont.so
├── libhilog.so ⭐
├── libhitracemeter.so
├── libi18n.so
├── libintl.so
├── libmeasure.so
├── libmediaquery.so
├── libmultimedia_audio.so
├── libmultimedia_media.so
├── libnet_connection.so
├── libnet_http.so
├── libnet_socket.so
├── libnet_utils.so
├── libnet_websocket.so
├── libnghttp2_shared.so
├── libnotificationmanager.so
├── libprocess.so
├── libpromptaction.so
├── librequest.so
├── librouter.so
├── libsecurity_cert.so
├── libsecurity_cryptoframework.so
├── libshared_libz.so
├── libssl_openssl.so
├── libtaskpool.so
├── libuitest.so
├── liburi.so
├── liburl.so
├── libutil.so
├── libutil_arraylist.so
├── libutil_deque.so
├── libutil_hashmap.so
├── libutil_hashset.so
├── libutil_lightweightmap.so
├── libutil_lightweightset.so
├── libutil_linkedlist.so
├── libutil_list.so
├── libutil_plainarray.so
├── libutil_queue.so
├── libutil_stack.so
├── libutil_treemap.so
├── libutil_treeset.so
├── libweb_webview.so
├── libwifimanager.so
├── libworker.so
├── libxml.so
├── libxml2.so
├── libzlib.so
└── arkui_android_adapter.jar
```

### A.2 Android assets/ 目录
```
android/app/src/main/assets/arkui-x/
├── entry/
│   ├── ets/
│   │   ├── modules.abc ⭐
│   │   └── sourceMaps.map
│   ├── module.json
│   ├── resources/
│   │   ├── base/
│   │   │   ├── media/
│   │   │   │   ├── app_icon.png
│   │   │   │   ├── icon.png
│   │   │   │   └── startIcon.png
│   │   │   └── profile/
│   │   │       └── main_pages.json
│   └── resources.index
├── libs/（可选，与 libs/ 目录相同）
│   ├── arm64-v8a/*.so
│   ├── armeabi-v7a/*.so
│   └── x86_64/*.so
└── systemres/
    └── resources.index
```

---

## 附录 B: 版本兼容性

| ArkUI-X SDK 版本 | compileSdkVersion | ABC 文件版本 | Android 支持 |
|-----------------|-------------------|-------------|-------------|
| 2.0.0.27 Beta1 | 12 | 12.0.4.0 | ✅ |
| 2.0.0.27 Beta1 | 20 | 13.0.1.0 | ❌ |

---

## 附录 C: 快速命令参考

```bash
# 1. 编译 HarmonyOS 项目
# 在 DevEco Studio 中点击 Build > Build Hap(s)/APP(s) > Build Hap(s)

# 2. 同步资源到 Android
script\android\sync-assets.bat

# 3. 编译 Android APK
script\android\build.bat

# 4. 安装并运行
script\android\run.bat

# 5. 一键编译运行
script\android\build-and-run.bat

# 6. 查看 logcat
adb logcat -s "Ace:*" "NAPI:*" "Hmrdp:*"

# 7. 检查 APK 内容
unzip -l android\app\build\outputs\apk\debug\app-debug.apk | grep "lib/arm64"
```

---

**文档版本**: 1.0
**最后更新**: 2026-03-23
**适用版本**: ArkUI-X 2.0.0.27 Beta1
