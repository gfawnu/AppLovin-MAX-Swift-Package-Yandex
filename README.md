# AppLovin MAX - Yandex Mediation Adapter (临时 SPM 代理)

> **Disclaimer / 声明**
>
> Unofficial temporary SPM proxy. **Not affiliated with AppLovin or Yandex.**
> Binaries are downloaded from official URLs at build time; this repository does not redistribute SDK binaries.
> Repository naming is for dependency identification only. Remove this repo when the official tag is published.
>
> 非官方临时代理包，与 AppLovin、Yandex 无任何关联。二进制仅在构建时从官方 URL 拉取，本仓库不上传 SDK 文件。官方补发 tag 后请停用并改用官方包。

## 为什么需要这个包

AppLovin 官方仓库 [`AppLovin-MAX-Swift-Package-Yandex`](https://github.com/AppLovin/AppLovin-MAX-Swift-Package-Yandex) 的 `master` 早已是 adapter `8.6.0.0`（`Package.swift` 指向 `AppLovinMediationYandexAdapter-8.6.0.0.zip` + `yandex-ads-sdk-ios 8.6.0`），但**对应 tag 一直没补发**：

```
refs/tags/8050001.0.0   ← 最新，实际内容是 adapter 8.5.0.1
```

SPM 只能锁 tag，`exact: "8060000.0.0"` 会直接解析失败，所以只能退回 `8050001.0.0`，比 Pod 侧（`AppLovinMediationYandexAdapter ~> 8.6.0.0`）落后一个版本。

本代理包内容与官方 `master` 的 `Package.swift` **逐字一致**（仅补了注释），让 SPM 侧能锁到 8.6.0.0，与 Pod 对齐。

## 用法

```swift
// ✅ 本代理包（adapter 8.6.0.0）
.package(url: "https://github.com/gfawnu/AppLovin-MAX-Swift-Package-Yandex.git", exact: "8060000.0.0")
```

Target 里 product 名不变，业务代码无需改动：

```swift
.product(name: "AppLovinMediationYandexAdapter", package: "AppLovin-MAX-Swift-Package-Yandex")
```

> Target 的 Other Linker Flags 仍需保留 `-ObjC`（与官方包一致）。

## tag 编码（与官方一致）

本代理包**沿用 AppLovin 官方编码规则**，所以 tag 字符串与官方将来补发的完全一样 —— 迁移时只需要换 URL，版本号不用改。

编码规则：`major` + `minor(2位)` + `patch(2位)` + `build(2位)`

| adapter 版本 | tag | 说明 |
|--------------|-----|------|
| 8.6.0.0 | `8060000.0.0` | ✅ 本代理包提供 |
| 8.5.0.1 | `8050001.0.0` | 官方最新（SPM 之前只能锁这个） |
| 8.5.0.0 | `8050000.0.0` | 官方 |

> 参考：`AppLovin-MAX-Swift-Package-BigoAds` 那个已废弃的代理包当时编码搞错了（用了 `6100001.0.0`），别套到本包上。

查官方 tag：

```bash
git ls-remote --tags https://github.com/AppLovin/AppLovin-MAX-Swift-Package-Yandex.git
```

## 迁移到官方包（AppLovin 补发 tag 之后）

```swift
// ❌ 本代理包
.package(url: "https://github.com/gfawnu/AppLovin-MAX-Swift-Package-Yandex.git", exact: "8060000.0.0")

// ✅ 官方包（只换 URL，版本号不变）
.package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package-Yandex.git", exact: "8060000.0.0")
```

换完后把 `SPM/README.md` 里本包的状态改为「已废弃」。

## 产物与要求

| | 本代理包 | 官方包 |
|---|----------|--------|
| `AppLovinMediationYandexAdapter` | binaryTarget 直连 AppLovin artifacts zip（手工维护 checksum） | 同左（AppLovin 内置） |
| `YandexMobileAds` | 引用 Yandex 官方 SPM `yandexmobile/yandex-ads-sdk-ios`，`exact: 8.6.0` | 同左 |
| 最低系统 | iOS 15.0 | iOS 15.0 |
| MAX SDK | 13.0.0+ | 13.0.0+ |

## 维护

升级 adapter 版本时，按官方 `master` 的 `Package.swift` 同步三处：binaryTarget 的 zip 版本、checksum、以及 `yandex-ads-sdk-ios` 的 `exact` 版本。

```bash
curl -fsSL -o /tmp/AppLovinMediationYandexAdapter.zip \
  "https://artifacts.applovin.com/ios/com/applovin/mediation/yandex-adapter/AppLovinMediationYandexAdapter-8.6.0.0.zip"
shasum -a 256 /tmp/AppLovinMediationYandexAdapter.zip
swift package resolve
```

改完按官方编码打 tag（adapter `8.6.0.0` → `8060000.0.0`），并同步 `SPM/README.md` 的包列表。
