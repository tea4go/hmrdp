# HelloApp - ArkUI-X 跨平台应用

这是一个基于 ArkUI-X 技术的跨平台应用，支持 HarmonyOS、Android 和 iOS 三端运行。

## 项目结构

```
hmrdp/
├── ohos/                          # HarmonyOS 平台项目 (主要编译目录)
│   ├── AppScope/                  # 应用全局配置
│   │   ├── app.json5              # 应用配置 (bundleName, version等)
│   │   └── resources/             # 应用级资源
│   │       └── base/
│   │           ├── element/       # 字符串资源
│   │           │   └── string.json
│   │           └── media/         # 媒体资源
│   │               └── app_icon.png
│   ├── entry/                     # 入口模块
│   │   ├── src/main/
│   │   │   ├── ets/
│   │   │   │   ├── entryability/
│   │   │   │   │   └── EntryAbility.ts    # 应用入口
│   │   │   │   └── pages/
│   │   │   │       └── Index.ets          # 主页面
│   │   │   ├── resources/
│   │   │   │   └── base/
│   │   │   │       ├── element/           # 字符串、颜色资源
│   │   │   │       │   ├── string.json
│   │   │   │       │   └── color.json
│   │   │   │       ├── media/             # 图片资源
│   │   │   │       │   ├── app_icon.png
│   │   │   │       │   ├── icon.png
│   │   │   │       │   └── startIcon.png
│   │   │   │       └── profile/
│   │   │   │           └── main_pages.json
│   │   │   └── module.json5               # 模块配置
│   │   ├── build-profile.json5
│   │   └── hvigorfile.ts
│   ├── build-profile.json5        # 项目构建配置
│   ├── hvigor/
│   │   └── hvigor-config.json5    # Hvigor 配置
│   ├── oh-package.json5           # 依赖配置
│   ├── local.properties           # SDK 路径配置
│   ├── hvigorfile.ts
│   └── app.json5
├── android/                       # Android 平台
│   └── ...
├── ios/                           # iOS 平台
│   └── ...
├── entry/                         # 跨平台共享入口模块
│   └── ...
├── crossplatform/                 # 跨平台共享代码
│   └── ...
└── README.md
```

## 开发环境要求

### HarmonyOS (主要开发平台)
- **DevEco Studio** 4.0 或更高版本
- **HarmonyOS SDK** API 20 (本文档使用版本)
- **Node.js** 18.x 或更高版本
- **Hvigor** 构建工具 (DevEco Studio 自带)

### Android
- Android Studio Flamingo 或更高版本
- Android SDK 24 (Android 7.0) 或更高版本
- Gradle 7.4.2

### iOS
- Xcode 14.0 或更高版本
- iOS 12.0 或更高版本
- CocoaPods

---

## HarmonyOS 编译和运行指南

### 方法一：使用 DevEco Studio (推荐)

1. 打开 DevEco Studio
2. 选择 `File -> Open`，打开项目的 `ohos` 目录
3. 等待项目同步完成
4. 连接设备或启动模拟器
5. 点击运行按钮 (绿色三角形)

### 方法二：命令行编译和运行

#### 步骤 1: 配置 SDK 路径

确保 `ohos/local.properties` 文件存在并包含正确的 SDK 路径：

```properties
# ohos/local.properties
sdk.dir=C:/Users/tony/AppData/Local/OpenHarmony/Sdk
```

> **注意**: 根据你的实际安装路径修改 `sdk.dir`

#### 步骤 2: 编译 HAP 包

在 `ohos` 目录下执行编译命令：

```bash
# 进入 ohos 目录
cd D:/MyWork/GitCode/hmrdp/ohos

# 执行编译
"/c/Program Files/Huawei/DevEco Studio/tools/hvigor/bin/hvigorw" --no-daemon -p product=default -p module=entry@default assembleHap --analyze=normal --parallel --incremental
```

**编译成功标志**:
```
> hvigor BUILD SUCCESSFUL in X s XXX ms
```

**生成的 HAP 文件位置**:
```
ohos/entry/build/default/outputs/default/entry-default-unsigned.hap
```

#### 步骤 3: 检查连接设备

```bash
# 列出已连接的设备
<F:/DevEcoTools/SdkOh/20/toolchains/hdc.exe> list targets

# 输出示例:
# 127.0.0.1:5555    (模拟器或远程设备)
# 或设备序列号
```

#### 步骤 4: 安装 HAP 到设备

```bash
# 进入 HAP 所在目录
cd D:/MyWork/GitCode/hmrdp/ohos/entry/build/default/outputs/default

# 安装 HAP ( -r 表示覆盖安装)
<F:/DevEcoTools/SdkOh/20/toolchains/hdc.exe> install -r entry-default-unsigned.hap
```

**安装成功标志**:
```
[Info]App install path:... msg:install bundle successfully.
AppMod finish
```

#### 步骤 5: 启动应用

```bash
<F:/DevEcoTools/SdkOh/20/toolchains/hdc.exe> shell aa start -a EntryAbility -b com.example.helloapp
```

**启动成功标志**:
```
start ability successfully.
```

---

## 快速命令参考

将以下命令保存为脚本方便使用：

### build.bat - 编译脚本
```batch
@echo off
cd /d D:\MyWork\GitCode\hmrdp\ohos
"C:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.bat" --no-daemon -p product=default -p module=entry@default assembleHap --analyze=normal --parallel --incremental
pause
```

### run.bat - 运行脚本
```batch
@echo off
set HDC=F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe
set HAP=D:\MyWork\GitCode\hmrdp\ohos\entry\build\default\outputs\default\entry-default-unsigned.hap

echo Installing HAP...
%HDC% install -r %HAP%

echo Starting App...
%HDC% shell aa start -a EntryAbility -b com.example.helloapp

pause
```

---

## 常见问题及解决方案

### 1. 编译错误: Path not found

**错误信息**:
```
Error Message: Path not found. At file: ...\entry
```

**原因**: `build-profile.json5` 中 modules 配置的路径不正确

**解决方案**: 确保 `ohos/build-profile.json5` 中的模块路径正确：
```json5
{
  "modules": [
    {
      "name": "entry",
      "srcPath": "./entry",  // 确保此目录存在
      ...
    }
  ]
}
```

### 2. 编译错误: Schema validate failed

**错误信息**:
```
Schema validate failed, at file: build-profile.json5
must have required property 'compatibleSdkVersion'
```

**原因**: SDK 版本配置位置不正确

**解决方案**: `compileSdkVersion` 和 `compatibleSdkVersion` 必须在 `products` 中配置：
```json5
{
  "app": {
    "signingConfigs": [],
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compileSdkVersion": 20,      // SDK 版本
        "compatibleSdkVersion": 20    // 兼容版本
      }
    ]
  }
}
```

### 3. 编译错误: sdk.dir not found

**错误信息**:
```
Unable to find 'sdk.dir' in 'local.properties'
```

**解决方案**: 创建或检查 `ohos/local.properties` 文件：
```properties
sdk.dir=C:/Users/tony/AppData/Local/OpenHarmony/Sdk
```

### 4. 编译错误: app.json5 file not found

**错误信息**:
```
app.json5 file not found. At file: ...\AppScope\app.json5
```

**解决方案**: 确保存在 `ohos/AppScope/app.json5` 文件：
```json5
{
  "app": {
    "bundleName": "com.example.helloapp",
    "vendor": "example",
    "versionCode": 1000000,
    "versionName": "1.0.0",
    "icon": "$media:app_icon",
    "label": "$string:app_name"
  }
}
```

### 5. 编译错误: Resource reference not defined

**错误信息**:
```
The resource reference '$media:app_icon' is not defined
```

**解决方案**: 确保以下资源文件存在：
- `ohos/AppScope/resources/base/media/app_icon.png`
- `ohos/entry/src/main/resources/base/media/icon.png`
- `ohos/entry/src/main/resources/base/media/startIcon.png`

### 6. 编译错误: deviceTypes not supported

**错误信息**:
```
device type 'phone' is not supported
```

**解决方案**: 修改 `module.json5` 中的 `deviceTypes`：
```json5
"deviceTypes": [
  "default",   // 使用 default 替代 phone
  "tablet",
  "2in1"
]
```

### 7. 安装失败: 签名问题

**错误信息**:
```
Will skip sign 'hap'. No signingConfigs profile is configured
```

**解决方案**: 这是警告信息，不影响调试。如需正式签名，在 `build-profile.json5` 中配置签名：
```json5
{
  "app": {
    "signingConfigs": [
      {
        "name": "default",
        "type": "HarmonyOS",
        "material": {
          "certpath": "path/to/cert.cer",
          "storePassword": "password",
          "keyAlias": "alias",
          "keyPassword": "password",
          "profile": "path/to/profile.p7b",
          "signAlg": "SHA256withECDSA",
          "storeFile": "path/to/keystore.p12"
        }
      }
    ]
  }
}
```

---

## 配置文件说明

### build-profile.json5 (项目级)

位置: `ohos/build-profile.json5`

```json5
{
  "app": {
    "signingConfigs": [],           // 签名配置
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compileSdkVersion": 20,    // 编译 SDK 版本
        "compatibleSdkVersion": 20  // 最低兼容 SDK 版本
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
          "applyToProducts": ["default"]
        }
      ]
    }
  ]
}
```

### module.json5 (模块级)

位置: `ohos/entry/src/main/module.json5`

关键字段:
- `name`: 模块名称
- `type`: 模块类型 (entry/feature/har/shared)
- `deviceTypes`: 支持的设备类型
- `pages`: 页面路由配置
- `abilities`: Ability 配置

### hvigor-config.json5

位置: `ohos/hvigor/hvigor-config.json5`

```json5
{
  "modelVersion": "6.0.2",  // Hvigor 模型版本
  "dependencies": {}
}
```

---

## 主要功能

- 显示一个标题为 "Hello" 的按钮
- 支持点击交互
- 三端统一 UI 体验

## 技术栈

- **ArkUI-X**: 华为跨平台 UI 框架
- **ArkTS**: TypeScript 的声明式 UI 扩展
- **Stage 模型**: HarmonyOS 应用开发模型
- **Hvigor**: HarmonyOS 构建工具

## 许可证

ISC License
