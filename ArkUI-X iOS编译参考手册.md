# ArkUI-X iOS 编译参考手册

## 1. 准备环境

- DevEco Studio + HarmonyOS SDK
- ArkUI-X SDK
- iOS: Xcode + CocoaPods + xcodegen

ArkUI-X SDK 下载地址：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/
```

可直接下载示例（5.0.1.110，darwin-x64）：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/5.0.1.110/darwin/arkui-x-darwin-x64-5.0.1.110-Release.zip
```

可直接下载示例（5.0.1.110，darwin-arm64）：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/5.0.1.110/darwin/arkui-x-darwin-arm64-5.0.1.110-Release.zip
```

可直接下载示例（5.0.1.110，windows-x64）：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/5.0.1.110/windows/arkui-x-windows-x64-5.0.1.110-Release.zip
```

可选检查命令：

```bash
xcodebuild -version
pod --version
xcodegen --version
```

## 2. 配置本地 SDK 路径（HarmonyOS）

在 `ohos/` 目录创建 `local.properties`：

```properties
sdk.dir=/your/path/to/OpenHarmony/Sdk
```

示例（macOS）：

```properties
sdk.dir=/Users/<用户名>/Library/OpenHarmony/Sdk
```

## 3. 先编译一次 HarmonyOS（产出 modules.abc）

使用 DevEco Studio 打开 `ohos/` 工程，完成一次构建，确保生成：

```text
ohos/entry/build/default/intermediates/loader_out/default/ets/modules.abc
```

如果这个文件不存在，后续 iOS 同步会失败。

## 4. 同步跨端代码和产物

在仓库根目录执行：

- macOS:

```bash
./sync-code.sh
```

- Windows:

```bat
sync-code.bat
```

该步骤会把共享 ArkTS 源码和编译产物同步到 iOS 目录（`ios/HelloApp/ets`、`ios/HelloApp/arkui-x/*`）。

## 5. iOS 额外拷贝 ArkUI-X SDK

将以下目录从 ArkUI-X SDK 复制到项目：

```text
<ARKUIX_SDK_HOME>/engine/xcframework/arkui/ios-release/libarkui_ios.xcframework
```

目标路径：

```text
ios/libarkui_ios.xcframework
```

如果本地还没有 ArkUI-X SDK，可从以下地址下载后解压：

```text
https://repo.huaweicloud.com/arkui-crossplatform/sdk/
```

## 6. 生成 iOS 工程并构建

进入 `ios/` 后执行：

```bash
xcodegen generate
pod install
```

然后构建：

```bash
xcodebuild -project HelloApp.xcodeproj \
  -scheme HelloApp \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

也可以直接在仓库根目录执行一键脚本：

```bash
./script/ios/build.sh
```

## 7. 我对流程的评估与建议

- 你的 6 步流程是正确且完整的，顺序也合理。
- `pod install` 是否必需：当前 `Podfile` 没有实际 pod 依赖时可跳过。
- 推荐把 `ios/project.yml` 作为 iOS 工程的单一来源；`HelloApp.xcodeproj`/`HelloApp.xcworkspace`可由 `xcodegen generate` 再生。
- `ios/HelloApp/arkui-x/*`、`ios/libarkui_ios.xcframework` 建议不提交到 Git（由同步脚本和本地 SDK 生成/拷贝）。

## 8. 常见问题（iOS）

### 8.1 `libarkui_ios.xcframework not found`

原因：第 5 步未完成。  
解决：从 ArkUI-X SDK 复制 `libarkui_ios.xcframework` 到 `ios/`。

### 8.2 `modules.abc not found`

原因：第 3 步没有先编译 HarmonyOS。  
解决：先在 `ohos/` 完成一次构建，再执行 `./sync-code.sh`。

### 8.3 Xcode 运行后页面未更新

原因：只重启了 iOS，但未重新同步 ArkTS 产物。  
解决：重新执行第 3、4 步，再回到 Xcode `Command + R`。
