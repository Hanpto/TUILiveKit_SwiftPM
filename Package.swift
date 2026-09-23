// swift-tools-version:6.0
import PackageDescription

// TUILiveKit（源码型 pod → SwiftPM）
//
// podspec 有两个 subspec（Professional / TRTC），SPM 没有 subspec 概念。
// 源码用 `#if canImport(TXLiteAVSDK_TRTC)` 做条件编译，所以这里只提供
// Professional 变体（podspec 的 default_subspec 也是 Professional），
// TRTC 分支会被 canImport 自动跳过。
//
// 依赖一律走我们自己的壳仓库（方案 A）：
//   RTCRoomEngine_SwiftPM 已经依赖 TXIMSDK_Plus_SwiftPM 和
//   TRTC_Professional_SwiftPM，这里再声明 Tencent-RTC 的
//   Professional_SwiftPM / Chat_SDK_SwiftPM 会链进第二份 TRTC 和 IM。
//
// ⚠️ TUICore 只有 Tencent 官方版本，它会带出 Chat_SDK_SwiftPM 8.x。
// 目前和我们的 IM 9.x 并存，链接是否冲突要实测。
//
// 注意 product 名和包名/ binaryTarget 名不一致：
//   Professional_SwiftPM 的 product 叫 Professional_SwiftPM，
//   TXLiteAVSDK_Professional 是它内部的 binaryTarget 名，不能当 product 用。
let package = Package(
    name: "TUILiveKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "TUILiveKit", targets: ["TUILiveKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Hanpto/AtomicX_SwiftPM.git",
                 from: "1.0.10"),
        .package(url: "https://github.com/Hanpto/AtomicXCore_SwiftPM.git",
                 from: "4.3.8"),
        .package(url: "https://github.com/Hanpto/RTCRoomEngine_SwiftPM.git",
                 from: "4.3.5"),
        .package(url: "https://github.com/Hanpto/TXIMSDK_Plus_SwiftPM.git",
                 from: "9.0.7667"),
        .package(url: "https://github.com/Hanpto/TRTC_Professional_SwiftPM.git",
                 from: "13.5.21355"),
        .package(url: "https://github.com/Tencent-RTC/TUICore_SwiftPM.git",
                 from: "8.6.7020"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.12.0"),
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
                .product(name: "TRTC_Professional",
                         package: "TRTC_Professional_SwiftPM"),
                .product(name: "TUICore_SwiftPM", package: "TUICore_SwiftPM"),
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
    // swiftLanguageModes，且必须放在 targets 之后。
    swiftLanguageModes: [.v5]
)
