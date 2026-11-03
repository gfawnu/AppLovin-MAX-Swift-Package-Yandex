// swift-tools-version: 5.6
// 非官方临时代理包（Unofficial temporary SPM proxy）。
// 与 AppLovin / Yandex 无任何关联；二进制仅在构建时从官方 URL 拉取，本仓库不重新分发 SDK。
//
// 存在原因：AppLovin 上游 master 的 Package.swift 已指向 adapter 8.6.0.0，
// 但一直没有补发对应 tag（最新 tag 仍是 8050001.0.0 = adapter 8.5.0.1），
// 导致 SPM 无法锁定 8.6.0.0。本包按官方 master 的内容原样复刻，供 SPM 锁定使用。
//
// tag 编码沿用 AppLovin 官方规则：adapter 8.6.0.0 → `8060000.0.0`
// （与官方将来补发的 tag 字符串一致，届时只需把 URL 换回官方，版本号不用动）。

import PackageDescription

let package = Package(
    name: "AppLovinMediationYandexAdapter",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppLovinMediationYandexAdapter",
            targets: ["AppLovinMediationYandexAdapterTarget"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", from: "13.0.0"),
        .package(url: "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", exact: "8.6.0"),
    ],
    targets: [
        .target(
            name: "AppLovinMediationYandexAdapterTarget",
            dependencies: [
                .target(name: "AppLovinMediationYandexAdapter"),
                .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package"),
                .product(name: "YandexMobileAds", package: "yandex-ads-sdk-ios"),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "AppLovinMediationYandexAdapter",
            url: "https://artifacts.applovin.com/ios/com/applovin/mediation/yandex-adapter/AppLovinMediationYandexAdapter-8.6.0.0.zip",
            checksum: "c72c7d7625a299588cc99b106726c60cff8d55e7e09a827830319485ad2a1dd9"
        ),
    ]
)
