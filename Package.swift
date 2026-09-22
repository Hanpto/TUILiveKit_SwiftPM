// swift-tools-version:6.0
import PackageDescription

// TUILiveKit（源码型 pod → SwiftPM）
//
// podspec 有两个 subspec（Professional / TRTC），SPM 没有 subspec 概念。
// 源码里用 `#if canImport(TXLiteAVSDK_TRTC)` 做条件编译，所以这里只提供
// Professional 变体（podspec 的 default_subspec 也是 Professional），
// TRTC 分支会被 canImport 自动跳过。
//
// 依赖取各仓库当前最新 tag。product 名和包名不一致，别按包名猜。
// 验证阶段统一用我们自己的 IM/RTCRoomEngine/AtomicXCore 一条链（方案 A）；
// TUICore 只有 Tencent 官方的，它会带出 Chat_SDK_SwiftPM 8.x——如果和我们的
// IM 9.x 冲突，正式改造（方案 B）时统一切到 Tencent 那条链。
let package = Package(
    name: "TUILiveKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "TUILiveKit", targets: ["TUILiveKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Hanpto/AtomicX_SwiftPM.git",
                 from: "1.0.9"),
        .package(url: "https://github.com/Hanpto/AtomicXCore_SwiftPM.git",
                 from: "4.3.8"),
        .package(url: "https://github.com/Hanpto/RTCRoomEngine_SwiftPM.git",
                 from: "4.3.5"),
        .package(url: "https://github.com/Hanpto/TXIMSDK_Plus_SwiftPM.git",
                 from: "9.0.7667"),
        .package(url: "https://github.com/Tencent-RTC/Professional_SwiftPM.git",
                 from: "13.3.20845"),
        .package(url: "https://github.com/Tencent-RTC/TUICore_SwiftPM.git",
                 from: "8.6.7020"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.12.0"),
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", from: "3.7.9"),
    ],
    targets: [
        .target(
            name: "TUILiveKit",
            dependencies: [
                .product(name: "AtomicX", package: "AtomicX_SwiftPM"),
                .product(name: "AtomicXCore", package: "AtomicXCore_SwiftPM"),
                .product(name: "RTCRoomEngine", package: "RTCRoomEngine_SwiftPM"),
                .product(name: "TXIMSDK_Plus", package: "TXIMSDK_Plus_SwiftPM"),
                .product(name: "TXLiteAVSDK_Professional",
                         package: "Professional_SwiftPM"),
                .product(name: "TUICore", package: "TUICore_SwiftPM"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "MJRefresh", package: "MJRefresh"),
            ],
            path: "Sources",
            // 与 podspec 的 exclude_files 保持一致
            exclude: ["KTV"],
            resources: [.process("Resources")]
        ),
    ],
    // 源码与 CocoaPods 共用，未适配 Swift6 严格并发。保持 tools-version 6.0
    // 以便依赖 6.x 的包，但用 Swift5 语言模式编译。6.0 起参数名为
    // swiftLanguageModes，且必须在 targets 之后。
    swiftLanguageModes: [.v5]
)
