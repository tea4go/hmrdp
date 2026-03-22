# 本地开发环境 SDK 配置文档

> 最后更新: 2026-03-22
>
> 本文档记录了本地开发环境中各类 SDK 的安装路径和配置信息，供 Claude 开发时参考。

---

## 目录

- [1. HarmonyOS SDK](#1-harmonyos-sdk)
- [2. OpenHarmony SDK](#2-openharmony-sdk)
- [3. Android SDK (Delphi XE)](#3-android-sdk-delphi-xe)
- [4. iOS SDK 配置](#4-ios-sdk-配置)
- [5. 开发��具版本汇总](#5-开发工具版本汇总)
- [6. 环境变量配置](#6-环境变量配置)

---

## 1. HarmonyOS SDK

### 1.1 基本信息


| 项目           | 信息                                                              |
| -------------- | ----------------------------------------------------------------- |
| **SDK 路径**   | `F:\DevEcoTools\Sdk\`                                             |
| **系统镜像**   | `F:\DevEcoTools\Sdk\system-image\HarmonyOS-6.0.2\`                |
| **模拟器路径** | `F:\DevEcoTools\Emulator\`                                        |
| **符号链接**   | `C:\Users\tony\AppData\Local\Huawei\Sdk` → `F:\DevEcoTools\Sdk\` |

### 1.2 版本信息


| 组件              | 版本       |
| ----------------- | ---------- |
| **HarmonyOS API** | 6.0.2      |
| **系统镜像架构**  | pc_all_x86 |

### 1.3 系统镜像文件

```
F:\DevEcoTools\Sdk\system-image\HarmonyOS-6.0.2\pc_all_x86\
├── bzImage              # Linux 内核 (10MB)
├── ramdisk.img          # RAM 磁盘 (2.5MB)
├── system.img           # 系统分区 (3.2GB)
├── sys_prod.img         # 产品分区 (1GB)
├── userdata.img         # 用户数据 (100MB)
├── vendor.img           # 厂商分区 (100MB)
├── features.ini         # 特性配置
├── info.json            # 镜像信息
└── sdk-pkg.json         # SDK 包信息
```

### 1.4 模拟器配置


| 项目             | 路径                                                |
| ---------------- | --------------------------------------------------- |
| **已部署模拟器** | `F:\DevEcoTools\Emulator\deployed\MatePad Edge\`    |
| **模拟器配置**   | `F:\DevEcoTools\Emulator\deployed\MatePad Edge.ini` |

---

## 2. OpenHarmony SDK

### 2.1 基本信息


| 项目           | 信息                    |
| -------------- | ----------------------- |
| **SDK 根路径** | `F:\DevEcoTools\SdkOh\` |
| **API 版本**   | 20                      |
| **SDK 版本**   | 6.0.0.47                |

### 2.2 SDK 组件结构

```
F:\DevEcoTools\SdkOh\20\
├── ets/                 # ArkTS/ETS SDK
│   ├── api/             # API 定义
│   ├── arkts/           # ArkTS 编译器
│   ├── build-tools/     # 构建工具
│   ├── component/       # 组件库
│   └── kits/            # 开发套件
├── js/                  # JS SDK (轻量级设备)
│   ├── api/
│   ├── build-tools/
│   ├── common/
│   ├── liteWearable/    # 轻量穿戴设备
│   └── resources/
├── native/              # Native C++ SDK
│   ├── build/           # 构建配置
│   ├── platforms/       # 平台支持
│   ├── sysroot/         # 系统根目录
│   └── toolchains/      # 工具链
├── previewer/           # 预览器
│   └── common/
└── toolchains/          # 命令行工具
    ├── hdc.exe          # HarmonyOS 设备连接工具
    ├── idl.exe          # IDL 编译器
    ├── restool.exe      # 资源编译工具
    ├── glslang_validator.exe  # Shader 验证
    └── ...
```

### 2.3 组件版本详情


| 组件           | API 版本 | 版本号   |
| -------------- | -------- | -------- |
| **ETS SDK**    | 20       | 6.0.0.47 |
| **JS SDK**     | 20       | 6.0.0.47 |
| **Native SDK** | 20       | 6.0.0.47 |
| **Previewer**  | 20       | 6.0.0.47 |

### 2.4 重要工具路径


| 工具               | 路径                                                       |
| ------------------ | ---------------------------------------------------------- |
| **HDC (设备调试)** | `F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe`               |
| **IDL 编译器**     | `F:\DevEcoTools\SdkOh\20\toolchains\idl.exe`               |
| **资源工具**       | `F:\DevEcoTools\SdkOh\20\toolchains\restool.exe`           |
| **Shader 验证**    | `F:\DevEcoTools\SdkOh\20\toolchains\glslang_validator.exe` |

---

## 3. Android SDK

### 3.1 Delphi XE 12.1 基本信息


| 项目         | 信息                                                  |
| ------------ | ----------------------------------------------------- |
| **安装路径** | `C:\Users\Public\Documents\Embarcadero\Studio\23.0\`  |
| **配置路径** | `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\` |
| **版本号**   | 23.0 (Delphi 12 Athens)                               |

### 3.2 Android SDK 配置


| 项目         | 路径                                                                                    |
| ------------ | --------------------------------------------------------------------------------------- |
| **SDK 路径** | `C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\android-sdk-windows\`   |
| **NDK 路径** | `C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\android-ndk-r21\`       |
| **JDK 路径** | `C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\jdk-17.0.10.7-hotspot\` |

### 3.3 版本信息


| 组件              | 版本                                 |
| ----------------- | ------------------------------------ |
| **Android SDK**   | 25.2.5                               |
| **API Level**     | 33 (android-33)                      |
| **Build Tools**   | 33.0.2                               |
| **Android NDK**   | r21 (21.0.6113669)                   |
| **NDK API Level** | android-23                           |
| **JDK**           | Temurin-17.0.10+7 (Eclipse Adoptium) |

### 3.4 SDK 目录结构

```
android-sdk-windows\
├── build-tools\
│   └── 33.0.2\          # 构建工具
├── cmdline-tools\
│   └── 11.0\bin\        # 命令行工具 (avdmanager, sdkmanager)
├── platform-tools\
│   └── Adb.exe          # Android 调试桥
├── platforms\
│   └── android-33\
│       └── android.jar  # Android API JAR
└── licenses\            # 许可证文件

android-ndk-r21\
├── build\               # NDK 构建系统
├── platforms\
│   └── android-23\      # NDK API 平台
├── prebuilt\            # 预构建工具
├── sysroot\             # 系统头文件和库
├── toolchains\
│   ├── aarch64-linux-android-4.9\  # 64位 ARM 工具链
│   └── arm-linux-androideabi-4.9\  # 32位 ARM 工具链
└── sources\
    └── cxx-stl\
        └── llvm-libc++\ # LLVM C++ 标准库
```

### 3.5 SDK 配置文件


| 平台               | 配置文件                                                                        |
| ------------------ | ------------------------------------------------------------------------------- |
| **Android 32-bit** | `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\AndroidSDK25.2.5_32bit.sdk` |
| **Android 64-bit** | `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\AndroidSDK25.2.5_64bit.sdk` |

### 3.6 关键工具路径


| 工具            | 路径                                                            |
| --------------- | --------------------------------------------------------------- |
| **ADB**         | `...\android-sdk-windows\platform-tools\Adb.exe`                |
| **AVD Manager** | `...\android-sdk-windows\cmdline-tools\11.0\bin\avdmanager.bat` |
| **android.jar** | `...\android-sdk-windows\platforms\android-33\android.jar`      |
| **JarSigner**   | `...\jdk-17.0.10.7-hotspot\bin\JarSigner.exe`                   |
| **KeyTool**     | `...\jdk-17.0.10.7-hotspot\bin\KeyTool.exe`                     |

### 3.7 NDK 工具链


| 平台   | 架构        | 链接器                             | Strip 工具                            |
| ------ | ----------- | ---------------------------------- | ------------------------------------- |
| 32-bit | armeabi-v7a | `arm-linux-androideabi-ld.exe`     | `arm-linux-androideabi-strip.exe`     |
| 64-bit | arm64-v8a   | `aarch64-linux-android\bin\ld.exe` | `aarch64-linux-android\bin\strip.exe` |

---

## 4. iOS SDK 配置

### 4.1 配置文件

Delphi XE 的 iOS 开发需要 macOS 上的 Xcode，本地仅保存配置模板：


| 文件                     | 路径                                                                             |
| ------------------------ | -------------------------------------------------------------------------------- |
| **iOS Entitlement 模板** | `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\Entitlement.TemplateiOS.xml` |
| **iOS Info.plist 模板**  | `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\info.plist.TemplateiOS.xml`  |

### 4.2 支持的 iOS 平台


| 平台            | 说明                       |
| --------------- | -------------------------- |
| **iOSDevice64** | 64位 iOS 设备 (ARM64)      |
| **iOSSimARM64** | iOS 模拟器 (Apple Silicon) |

> **注意**: iOS 开发需要配置 macOS 开发环境和 Xcode，通过 PA Server 进行远程编译。

---

## 5. 开发工具版本汇总

### 5.1 IDE 版本


| 工具              | 版本        | 安装路径                                             |
| ----------------- | ----------- | ---------------------------------------------------- |
| **DevEco Studio** | 6.0.2.642   | `C:\Program Files\Huawei\DevEco Studio\`             |
| **Delphi XE**     | 12.1 (23.0) | `C:\Users\Public\Documents\Embarcadero\Studio\23.0\` |

### 5.2 SDK 版本对照表


| SDK 类型         | 版本     | API Level |
| ---------------- | -------- | --------- |
| HarmonyOS        | 6.0.2    | API 14    |
| OpenHarmony      | 6.0.0.47 | API 20    |
| Android (Delphi) | 25.2.5   | API 33    |
| Android NDK      | r21      | API 23    |

### 5.3 JDK 版本


| 用途           | JDK 版本                | 路径                                         |
| -------------- | ----------------------- | -------------------------------------------- |
| Delphi Android | Temurin 17.0.10+7       | `...\jdk-17.0.10.7-hotspot\`                 |
| DevEco Studio  | JBR (JetBrains Runtime) | `C:\Program Files\Huawei\DevEco Studio\jbr\` |

---

## 6. 环境变量配置

### 6.1 推荐配置

```bash
# HarmonyOS / OpenHarmony
HARMONYOS_SDK=F:\DevEcoTools\Sdk
OPENHARMONY_SDK=F:\DevEcoTools\SdkOh
HDC_PATH=F:\DevEcoTools\SdkOh\20\toolchains

# Android (Delphi)
ANDROID_SDK=C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\android-sdk-windows
ANDROID_NDK=C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\android-ndk-r21
JAVA_HOME=C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\jdk-17.0.10.7-hotspot

# PATH 追加
PATH=%PATH%;%HDC_PATH%;%ANDROID_SDK%\platform-tools;%ANDROID_SDK%\cmdline-tools\11.0\bin
```

### 6.2 符号链接映射


| 符号链接                                      | 目标                      |
| --------------------------------------------- | ------------------------- |
| `C:\Users\tony\AppData\Local\Huawei\Sdk`      | `F:\DevEcoTools\Sdk`      |
| `C:\Users\tony\AppData\Local\Huawei\Emulator` | `F:\DevEcoTools\Emulator` |

---

## 附录 A: 配置文件快速参考

### DevEco Studio

- **配置目录**: `C:\Users\tony\AppData\Local\Huawei\DevEcoStudio6.0\`
- **项目目录**: `C:\Users\tony\AppData\Local\Huawei\DevEcoStudio6.0\projects\`
- **插件目录**: `C:\Users\tony\AppData\Local\Huawei\DevEcoStudio6.0\plugins\`

### Delphi XE

- **环境配置**: `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\EnvOptions.proj`
- **SDK 配置**: `C:\Users\tony\AppData\Roaming\Embarcadero\BDS\23.0\*.sdk`

---

## 附录 B: 常用命令

### HarmonyOS 设备调试

```bash
# 查看连接设备
F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe list targets

# 安装应用
F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe install <hap文件>

# 查看日志
F:\DevEcoTools\SdkOh\20\toolchains\hdc.exe hilog
```

### Android 设备调试

```bash
# 查看连接设备
C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\android-sdk-windows\platform-tools\adb.exe devices

# 安装 APK
C:\Users\Public\Documents\Embarcadero\Studio\23.0\PlatformSDKs\android-sdk-windows\platform-tools\adb.exe install <apk文件>
```

---

*文档生成时间: 2026-03-22*
