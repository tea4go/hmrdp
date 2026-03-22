# ArkUI-X Android 编译脚本使用指南

本目录包含用于简化 ArkUI-X Android 项目编译和运行的自动化脚本。

## 快速开始

### 新项目初始化

```bash
# 1. 初始化项目（复制所有必需的库和资源）
script\setup-android.bat

# 2. 检查配置是否正确
script\check-config.bat

# 3. 在 DevEco Studio 中编译 HarmonyOS 项目
# Build > Build Hap(s)/APP(s) > Build Hap(s)

# 4. 同步编译产物到 Android
script\android\sync-assets.bat

# 5. 一键编译运行
script\android\build-and-run.bat
```

### 日常开发流程

修改 ArkTS 代码后：

```bash
# 1. 在 DevEco Studio 中重新编译 HarmonyOS 项目

# 2. 运行 build-and-run.bat（会自动同步资源）
script\android\build-and-run.bat
```

## 脚本说明

### 根目录脚本

#### `setup-android.bat` - 项目初始化 ⭐

**用途**: 从 ArkUI-X SDK 复制所有必需的库和资源到 Android 项目

**运行时机**:
- 创建新项目时
- 更新 ArkUI-X SDK 后
- 遇到 "library not found" 错误时

**复制内容**:
- `arkui_android_adapter.jar` → `android/app/libs/`
- 69 个插件 .so 文件 → `android/app/libs/arm64-v8a/`, `armeabi-v7a/`, `x86_64/`
- 系统资源 → `android/app/src/main/assets/arkui-x/systemres/`

---

#### `check-config.bat` - 配置���查 ⭐

**用途**: 检查项目配置是否正确

**检查项**:
1. HarmonyOS SDK 版本是否为 12
2. Android Adapter JAR 是否存在
3. 插件库数量是否正确（约 69 个）
4. 关键库 `libhilog.so` 是否存在
5. 系统资源是否存在
6. `modules.abc` 是否已同步
7. `build.gradle` jniLibs 配置是否正确
8. `module.json5` 设备类型是否正确

**输出**:
- ✅ 通过项数量
- ❌ 失败项数量及修复建议

---

### `script/android/` 目录脚本

#### `sync-assets.bat` - 同步编译产物 ⭐⭐⭐

**用途**: 从 HarmonyOS 编译输出复制 `modules.abc` 和 `sourceMaps.map` 到 Android assets

**源路径**:
```
ohos/entry/build/default/intermediates/loader_out/default/ets/
├── modules.abc
└── sourceMaps.map
```

**目标路径**:
```
android/app/src/main/assets/arkui-x/entry/ets/
├── modules.abc
└── sourceMaps.map
```

**运行时机**:
- 修改 ArkTS 代码并重新编译后
- `build.bat` 会自动调用此脚本

---

#### `build.bat` - 编译 APK ⭐⭐⭐

**用途**: 完整的 Android APK 编译流程

**执行步骤**:
1. 同步源代码（调用 `sync-code.bat`）
2. 同步编译产物（调用 `sync-assets.bat`）
3. 清理旧构建
4. 编译 APK（`gradlew assembleDebug`）

**输出**:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

---

#### `run.bat` - 安装运行 ⭐⭐

**用途**: 安装 APK 到设备并启动应用

**执行步骤**:
1. 检查设备连接
2. 安装 APK
3. 等待 5 秒（让设备完成安装）
4. 启动应用

**关键配置**:
```batch
PACKAGE_NAME=com.example.hmrdp
ACTIVITY_NAME=com.hmrdp.EntryEntryAbilityActivity
```

**注意**: 修改包名或 Activity 名称时需要更新此脚本

---

#### `build-and-run.bat` - 一键编译运行 ⭐⭐⭐

**用途**: 编译并运行，最常用的脚本

**执行步骤**:
1. 调用 `build.bat` 编译 APK
2. 调用 `run.bat` 安装运行

---

## 常见问题

### 1. "HarmonyOS build not found"

**原因**: 未在 DevEco Studio 中编译 HarmonyOS 项目

**解决**:
1. 打开 DevEco Studio
2. 点击 Build > Build Hap(s)/APP(s) > Build Hap(s)
3. 等待编译完成
4. 重新运行脚本

---

### 2. "library not found" 错误

**原因**: 插件库未复制到正确位置

**解决**:
```bash
# 运行初始化脚本
script\setup-android.bat

# 检查配置
script\check-config.bat
```

---

### 3. ABC 文件版本不匹配

**错误**: `abc file version 13.0.1.0`

**原因**: HarmonyOS SDK 版本配置错误

**解决**:
修改 `ohos/build-profile.json5`:
```json5
{
  "app": {
    "products": [
      {
        "compileSdkVersion": 12,
        "compatibleSdkVersion": 12
      }
    ]
  }
}
```

---

### 4. Activity 类不存在

**错误**: `Activity class does not exist`

**原因**: `run.bat` 中的包名或 Activity 名称配置错误

**解决**:
1. 检查 `android/app/build.gradle` 中的 `applicationId`
2. 检查 Activity 类名格式：`<ModuleName><AbilityName>Activity`
3. 更新 `run.bat` 中的配置

---

### 5. UI 显示空白

**原因**: `modules.abc` 未同步或插件库缺失

**解决**:
```bash
# 1. 在 DevEco Studio 中重新编译
# 2. 同步资源
script\android\sync-assets.bat

# 3. 检查插件库
script\check-config.bat

# 4. 重新编译运行
script\android\build-and-run.bat
```

---

## 调试技巧

### 查看 logcat 日志

```bash
# 清空日志
adb logcat -c

# 查看应用日志
adb logcat -s "Ace:*" "NAPI:*" "ArkCompiler:*" "Hmrdp:*"

# 实时日志
adb logcat | grep -E "(hmrdp|Ace|NAPI)"
```

### 检查 APK 内容

```bash
# 列出 APK 中的库文件
unzip -l app-debug.apk | grep "lib/arm64"

# 列出 APK 中的 assets
unzip -l app-debug.apk | grep "arkui-x"
```

### 检查应用进程

```bash
# 获取应用 PID
adb shell pidof com.example.hmrdp

# 查看应用详细信息
adb shell dumpsys package com.example.hmrdp
```

---

## 脚本执行流程图

```
新项目初始化
│
├─> setup-android.bat
│   └─> 复制库和资源
│
├─> check-config.bat
│   └─> 验证配置
│
└─> 在 DevEco Studio 中编译
    │
    ├─> sync-assets.bat
    │   └─> 同步 modules.abc
    │
    └─> build-and-run.bat
        ├─> build.bat
        │   ├─> sync-code.bat
        │   ├─> sync-assets.bat
        │   └─> gradlew assembleDebug
        │
        └─> run.bat
            └─> adb install && am start
```

---

## 推荐工作流

### 首次设置

```bash
setup-android.bat → check-config.bat → [DevEco 编译] → sync-assets.bat → build-and-run.bat
```

### 日常开发

```bash
[修改 ArkTS 代码] → [DevEco 编译] → build-and-run.bat
```

### 故障排查

```bash
check-config.bat → [修复问题] → build-and-run.bat
```

---

## 相关文档

- [ArkUI-X安卓编译参考手册.md](../ArkUI-X安卓编译参考手册.md) - 完整的问题和解决方案
- [MEMORY.md](../MEMORY.md) - 项目记忆文件

---

**文档版本**: 1.0
**最后更新**: 2026-03-23
