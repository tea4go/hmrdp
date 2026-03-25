# ArkUI-X iOS 编译参考手册

本手册面向**全新 Mac 主机**，按顺序操作后可完成环境准备、编译和模拟器运行。

---

## 1. 系统要求

| 项目 | 最低要求 |
|------|----------|
| macOS | 12.0 Monterey 及以上 |
| Xcode | 14.0 及以上（含 iOS 模拟器） |
| DevEco Studio | 5.0 及以上（含 HarmonyOS SDK 和 hvigorw） |
| Homebrew | 任意版本 |

---

## 2. 安装依赖工具

### 2.1 Xcode

从 Mac App Store 安装，或前往官网下载：

```text
https://developer.apple.com/xcode/
```

安装后接受许可协议：

```bash
sudo xcodebuild -license accept
```

安装至少一个 iOS 模拟器（Xcode → Settings → Platforms → iOS → 下载）。

### 2.2 DevEco Studio（含 HarmonyOS SDK 和 hvigorw）

从华为官网下载 macOS 版：

```text
https://developer.huawei.com/consumer/cn/deveco-studio/
```

安装后打开一次，完成 SDK 下载向导（选择 HarmonyOS SDK）。SDK 默认安装到：

```text
/Users/<用户名>/Library/OpenHarmony/Sdk
```

DevEco Studio 自带 `hvigorw`（构建工具），路径为：

```text
/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw
```

`build.sh` 会自动查找该路径，**无需手动配置**。

### 2.3 xcodegen 和 CocoaPods

```bash
brew install xcodegen
brew install cocoapods
```

验证安装：

```bash
xcodebuild -version   # Xcode 14.0+
xcodegen --version    # 2.x+
pod --version         # 1.x+
```

---

## 3. 克隆仓库

```bash
git clone <仓库地址>
cd hmrdp
```

---

## 4. 配置 HarmonyOS SDK 路径

在 `ohos/` 目录创建（或确认已有）`local.properties`：

```bash
# 查看当前内容（如果已有）
cat ohos/local.properties
```

内容模板：

```properties
sdk.dir=/Users/<用户名>/Library/OpenHarmony/Sdk
```

将 `<用户名>` 替换为实际用户名（`whoami` 可查看）。

DevEco Studio 首次打开项目时会自动生成该文件，也可手动创建。

---

## 5. 放置 ArkUI-X iOS SDK（libarkui_ios.xcframework）

iOS 构建依赖 ArkUI-X 提供的 xcframework，需手动放置到项目中。

### 5.1 下载 ArkUI-X SDK

前往下载页面选择版本：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/
```

macOS (Apple Silicon / arm64)：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/5.0.1.110/darwin/arkui-x-darwin-arm64-5.0.1.110-Release.zip
```

macOS (Intel / x64)：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/5.0.1.110/darwin/arkui-x-darwin-x64-5.0.1.110-Release.zip
```

### 5.2 解压并复制 xcframework

解压后找到以下目录：

```text
<解压目录>/engine/xcframework/arkui/ios-release/libarkui_ios.xcframework
```

复制到项目 `ios/` 目录：

```bash
cp -r <解压目录>/engine/xcframework/arkui/ios-release/libarkui_ios.xcframework \
      ios/libarkui_ios.xcframework
```

复制后目录结构应为：

```text
ios/
└── libarkui_ios.xcframework/
    ├── Info.plist
    ├── ios-arm64/                      # 真机 slice
    │   └── libarkui_ios.framework/
    └── ios-arm64_x86_64-simulator/     # 模拟器 slice
        └── libarkui_ios.framework/
```

验证：

```bash
ls ios/libarkui_ios.xcframework/
# 应看到 Info.plist  ios-arm64  ios-arm64_x86_64-simulator
```

---

## 6. 一键编译

在**仓库根目录**执行：

```bash
bash script/ios/build.sh
```

脚本会自动完成以下 5 步：

| 步骤 | 内容 |
|------|------|
| 1/5 | 调用 `hvigorw assembleHap` 重新编译 ArkTS 源码，产出 `modules.abc` |
| 2/5 | 运行 `sync-code.sh`，将最新 `modules.abc` 和 ETS 源码同步到 `ios/` |
| 3/5 | 运行 `xcodegen generate`，从 `ios/project.yml` 生成 Xcode 工程 |
| 4/5 | 运行 `xcodebuild` 构建 iOS 模拟器 Debug 包 |
| 5/5 | 输出构建产物路径 |

构建产物路径：

```text
ios/build/Build/Products/Debug-iphonesimulator/HelloApp.app
```

编译成功输出示例：

```text
[1/5] Building HarmonyOS module (compiling ArkTS)...
> hvigor BUILD SUCCESSFUL in 8 s
  HarmonyOS build done.
[2/5] Syncing shared code...
  Sync Complete!
[3/5] Generating Xcode project...
  Created project at ...
[4/5] Building iOS app...
** BUILD SUCCEEDED **
[5/5] Build complete!
========================================
  Build Success!
========================================
App: ios/build/Build/Products/Debug-iphonesimulator/HelloApp.app
Run: bash script/ios/run.sh
```

---

## 7. 在模拟器上运行

```bash
bash script/ios/run.sh
```

脚本会自动：

1. 检测已启动的 iPhone 模拟器；若无则启动第一个可用模拟器
2. 打开 Simulator.app
3. 安装 `HelloApp.app`
4. 启动 App

运行成功输出示例：

```text
Using booted simulator: iPhone 16e (75378E33-...)
[1/2] Installing app: ...
[2/2] Launching app: com.example.HelloApp
com.example.HelloApp: 12345
========================================
  App launched successfully!
========================================
```

---

## 8. 日常开发工作流

修改 ArkTS 源码后（如 `ohos/entry/src/main/ets/pages/Index.ets`），重新执行：

```bash
bash script/ios/build.sh   # 重编 + 同步 + 构建
bash script/ios/run.sh     # 安装 + 启动
```

`build.sh` 会增量编译 HarmonyOS 模块（`--incremental`），只重编变动的部分，速度较快。

---

## 9. 常见问题

### 9.1 `libarkui_ios.xcframework not found`

原因：未完成第 5 步。
解决：按第 5 节将 `libarkui_ios.xcframework` 复制到 `ios/` 目录。

### 9.2 HarmonyOS build 报错 `sdk.dir not set`

原因：`ohos/local.properties` 不存在或路径错误。
解决：按第 4 节创建该文件，确保路径中的用户名正确。

### 9.3 `xcodegen not found`

解决：

```bash
brew install xcodegen
```

### 9.4 `modules.abc not found`（sync 步骤失败）

原因：DevEco Studio 未安装或 `hvigorw` 未能运行，ArkTS 编译失败。
解决：
1. 确认 DevEco Studio 已安装到 `/Applications/DevEco-Studio.app`
2. 手动测试：

```bash
/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw --version
```

3. 若路径不同，在 `build.sh` 第 68-70 行修改路径。

### 9.5 iOS App 内容未更新

原因：修改了 `.ets` 源码，但未重新编译 HarmonyOS 模块（`modules.abc` 仍是旧的）。
解决：重新执行 `bash script/ios/build.sh`（不要跳过步骤 1）。

### 9.6 模拟器列表为空

原因：Xcode 未安装 iOS 模拟器运行时。
解决：Xcode → Settings → Platforms → iOS，下载任意版本模拟器。

### 9.7 构建目标选错 slice（arm64 vs x86_64）

Xcode 构建时会根据检测到的模拟器自动选择正确 slice：
- Apple Silicon Mac 上的模拟器：`arm64`
- Intel Mac 上的模拟器：`x86_64`

`build.sh` 和 `libarkui_ios.xcframework/ios-arm64_x86_64-simulator/` 均已包含两种 slice，无需手动干预。
