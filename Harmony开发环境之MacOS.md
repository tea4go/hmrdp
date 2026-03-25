# 本地开发环境 SDK 配置文档

> 最后更新: 2026-03-25
>
> 本文档记录了当前 Mac 主机本地开发环境中各类 SDK 的安装路径和配置信息，供开发时参考。

---

## 机器基本信息

| 项目 | 信息 |
|------|------|
| **CPU** | Intel Core i5-8500 @ 3.00GHz |
| **架构** | x86_64 |
| **操作系统** | macOS 15.7.4 Sequoia (Build 24G517) |
| **用户名** | admin |
| **用户主目录** | `/Users/admin` |

---

## 目录

- [1. HarmonyOS SDK（DevEco Studio）](#1-harmonyos-sdkdeveco-studio)
- [2. OpenHarmony SDK](#2-openharmony-sdk)
- [3. Android SDK](#3-android-sdk)
- [4. iOS SDK 配置](#4-ios-sdk-配置)
- [5. 开发工具版本汇总](#5-开发工具版本汇总)
- [6. 环境变量配置](#6-环境变量配置)

---

## 1. HarmonyOS SDK（DevEco Studio）

### 1.1 DevEco Studio 基本信息

| 项目 | 信息 |
|------|------|
| **版本** | 6.0.2.642 |
| **Build 号** | DS-243.24978.46.36.602642 |
| **安装路径** | `/Applications/DevEco-Studio.app` |
| **最低 macOS 要求** | 10.13 High Sierra |

### 1.2 DevEco Studio 内置工具

| 工具 | 路径 |
|------|------|
| **hvigorw（构建工具）** | `/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw` |
| **hvigorw 版本** | 6.22.3 |

### 1.3 HarmonyOS SDK 路径

> **注意**: 当前机器 DevEco Studio 的 HarmonyOS SDK（闭源部分）尚未下载，路径存在但为空：

| 项目 | 路径 |
|------|------|
| **HarmonyOS SDK 根路径** | `/Users/admin/Library/Huawei/Sdk/` |
| **状态** | 仅含 `productConfig.json`，未下载组件 |

ArkUI-X 跨平台项目（本仓库）使用 **OpenHarmony SDK**，不依赖 HarmonyOS 闭源 SDK，见第 2 节。

### 1.4 项目 SDK 路径配置

`ohos/local.properties`（DevEco Studio 自动生成，不提交 Git）：

```properties
sdk.dir=/Users/admin/Library/OpenHarmony/Sdk
```

---

## 2. OpenHarmony SDK

### 2.1 基本信息

| 项目 | 信息 |
|------|------|
| **SDK 根路径** | `/Users/admin/Library/OpenHarmony/Sdk` |
| **已安装 API 版本** | API 12、API 20 |

### 2.2 各 API 版本信息

| API 版本 | SDK 版本 | 备注 |
|----------|----------|------|
| **API 12** | 5.0.0.71 | 旧版 |
| **API 20** | 6.0.0.47 | 当前项目使用 |

### 2.3 API 20 SDK 组件结构

```
/Users/admin/Library/OpenHarmony/Sdk/20/
├── ets/                 # ArkTS/ETS SDK（API 20，v6.0.0.47）
│   ├── api/             # API 定义
│   ├── arkts/           # ArkTS 编译器
│   ├── build-tools/     # 构建工具
│   ├── component/       # 组件库
│   └── kits/            # 开发套件
├── js/                  # JS SDK（轻量级设备）
│   ├── api/
│   ├── build-tools/
│   ├── common/
│   └── liteWearable/
├── previewer/           # 预览器
│   └── common/
└── toolchains/          # 命令行工具（v6.0.0.47）
    ├── hdc              # HarmonyOS 设备连接工具
    ├── idl              # IDL 编译器
    ├── restool          # 资源编译工具
    ├── ark_disasm       # ArkTS 反汇编工具
    ├── syscap_tool      # SysCap 工具
    ├── hnpcli           # HNP 包管理
    └── libusb_shared.dylib
```

### 2.4 组件版本详情

| 组件 | API 版本 | 版本号 |
|------|----------|--------|
| **ETS SDK** | 20 | 6.0.0.47 |
| **JS SDK** | 20 | 6.0.0.47 |
| **Toolchains** | 20 | 6.0.0.47 |

### 2.5 重要工具路径

| 工具 | 路径 |
|------|------|
| **HDC（设备调试）** | `/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/hdc` |
| **IDL 编译器** | `/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/idl` |
| **资源工具** | `/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/restool` |
| **ArkTS 反汇编** | `/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/ark_disasm` |

---

## 3. Android SDK

> **当前机器未安装 Android SDK。**
>
> 本仓库的 Android 编译（Gradle + ArkUI-X 适配层）目前在 Windows 主机上完成，本 Mac 主机仅负责 iOS 端编译。
>
> 如需在本机配置 Android SDK，参考 Android 官方文档或 `ArkUI-X安卓编译参考手册.md`。

---

## 4. iOS SDK 配置

### 4.1 Xcode 基本信息

| 项目 | 信息 |
|------|------|
| **Xcode 版本** | 26.3 (Build 17C529) |
| **安装路径** | `/Applications/Xcode.app` |
| **Developer 路径** | `/Applications/Xcode.app/Contents/Developer` |
| **iOS SDK 版本** | 26.2 (iphonesimulator26.2 / iphoneos26.2) |

### 4.2 iOS 模拟器运行时

| 运行时 | 版本 |
|--------|------|
| **iOS Simulator Runtime** | iOS 26.3 (26.3.1 - 23D8133) |

### 4.3 已安装模拟器设备

| 设备 | UUID | 状态 |
|------|------|------|
| iPhone 16e | 75378E33-422B-49A1-92DC-B4FC93D4EEC2 | Booted |
| iPhone 17 | 7BC44DA6-0E56-4C89-9E91-03834DC332F6 | Shutdown |
| iPhone 17 Pro | 70112F00-7758-4F85-9D4F-D9AA17306C03 | Shutdown |
| iPhone 17 Pro Max | 07B97854-EF6B-4387-8116-05A32ED6B21C | Shutdown |
| iPhone Air | FBF85B6F-FC68-4CF3-A511-B89A662E7CF4 | Shutdown |

### 4.4 ArkUI-X iOS SDK（xcframework）

| 项目 | 信息 |
|------|------|
| **存放路径** | `ios/libarkui_ios.xcframework/`（项目内，不提交 Git） |
| **架构切片** | `ios-arm64`（真机）、`ios-arm64_x86_64-simulator`（模拟器） |
| **来源** | ArkUI-X SDK 5.0.1.110 |

### 4.5 iOS 构建工具

| 工具 | 版本 | 安装方式 |
|------|------|----------|
| **xcodegen** | 2.45.3 | `brew install xcodegen` |
| **CocoaPods** | 1.16.2 | `brew install cocoapods` |
| **xcodebuild** | 随 Xcode | 内置 |

---

## 5. 开发工具版本汇总

### 5.1 IDE 与构建工具

| 工具 | 版本 | 安装路径 |
|------|------|----------|
| **DevEco Studio** | 6.0.2.642 | `/Applications/DevEco-Studio.app` |
| **hvigorw** | 6.22.3 | DevEco Studio 内置 |
| **Xcode** | 26.3 (17C529) | `/Applications/Xcode.app` |

### 5.2 SDK 版本对照表

| SDK 类型 | 版本 | API Level |
|----------|------|-----------|
| OpenHarmony（当前项目） | 6.0.0.47 | API 20 |
| OpenHarmony（旧版） | 5.0.0.71 | API 12 |
| iOS | 26.2 | — |

### 5.3 命令行工具

| 工具 | 版本 | 路径/安装方式 |
|------|------|---------------|
| **Homebrew** | 5.1.0 | `/usr/local/bin/brew` |
| **Git** | 2.50.1 (Apple Git-155) | 系统内置 |
| **Node.js** | v24.11.0 | Homebrew |
| **npm** | 11.6.1 | 随 Node.js |
| **Java (OpenJDK)** | 20.0.1 | `/usr/bin/java` |
| **xcodegen** | 2.45.3 | `/usr/local/bin/xcodegen` |
| **CocoaPods** | 1.16.2 | `/usr/local/bin/pod` |

---

## 6. 环境变量配置

### 6.1 当前配置（`~/.zshrc` 或 `~/.bash_profile`）

本机无特殊环境变量配置，工具均通过 Homebrew 安装到 `/usr/local/bin`，已在默认 `PATH` 中。

hvigorw 由 `build.sh` 脚本通过绝对路径调用，无需加入 PATH：

```bash
/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw
```

### 6.2 可选追加（如需在终端直接使用 HDC）

```bash
# 追加到 ~/.zshrc
export OPENHARMONY_SDK=/Users/admin/Library/OpenHarmony/Sdk
export PATH=$PATH:$OPENHARMONY_SDK/20/toolchains
```

使 `hdc` 可直接在终端调用：

```bash
hdc list targets
```

---

## 附录 A: 配置文件快速参考

### DevEco Studio

| 配置项 | 路径 |
|--------|------|
| **用户配置目录** | `/Users/admin/Library/Application Support/DevEco Studio/` |
| **项目 SDK 配置** | `ohos/local.properties`（每个项目单独，不提交 Git） |

### iOS 项目（本仓库）

| 配置项 | 路径 |
|--------|------|
| **Xcode 工程模板** | `ios/project.yml`（xcodegen 配置，提交 Git） |
| **Xcode 工程文件** | `ios/HelloApp.xcodeproj`（由 xcodegen 生成，可重新生成） |
| **ArkUI-X xcframework** | `ios/libarkui_ios.xcframework/`（不提交 Git，手动放置） |
| **CocoaPods 配置** | `ios/Podfile` |
| **构建脚本** | `script/ios/build.sh`、`script/ios/run.sh` |

---

## 附录 B: 常用命令

### HarmonyOS 设备调试

```bash
# 查看连接设备
/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/hdc list targets

# 安装应用
/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/hdc install <hap文件>

# 查看日志
/Users/admin/Library/OpenHarmony/Sdk/20/toolchains/hdc hilog
```

### iOS 模拟器

```bash
# 查看所有可用模拟器
xcrun simctl list devices available

# 查看已启动模拟器
xcrun simctl list devices | grep Booted

# 在模拟器安装 App
xcrun simctl install <设备UUID> <path/to/App.app>

# 启动 App
xcrun simctl launch <设备UUID> <bundle-id>
```

### 本仓库 iOS 一键构建与运行

```bash
# 编译（hvigorw → sync → xcodebuild）
bash script/ios/build.sh

# 运行（安装 + 启动模拟器）
bash script/ios/run.sh
```

---

*文档生成时间: 2026-03-25*
