# alipay_kit

[![Build Status](https://cloud.drone.io/api/badges/rxreader/alipay_kit/status.svg)](https://cloud.drone.io/rxreader/alipay_kit)
[![Codecov](https://codecov.io/gh/rxreader/alipay_kit/branch/master/graph/badge.svg)](https://codecov.io/gh/rxreader/alipay_kit)
[![GitHub Tag](https://img.shields.io/github/tag/rxreader/alipay_kit.svg)](https://github.com/rxreader/alipay_kit/releases)
[![Pub Package](https://img.shields.io/pub/v/alipay_kit.svg)](https://pub.dartlang.org/packages/alipay_kit)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/rxreader/alipay_kit/blob/master/LICENSE)

flutter版支付宝SDK

## fake 系列 libraries

* [flutter版微信SDK](https://github.com/rxreader/wechat_kit)
* [flutter版腾讯(QQ)SDK](https://github.com/rxreader/tencent_kit)
* [flutter版新浪微博SDK](https://github.com/rxreader/weibo_kit)
* [flutter版支付宝SDK](https://github.com/rxreader/alipay_kit)
* [flutter版walle渠道打包工具](https://github.com/rxreader/walle_kit)

## dart/flutter 私服

* [simple_pub_server](https://github.com/rxreader/simple_pub_server)

## docs

* [蚂蚁金服开放平台](https://openhome.alipay.com/platform/appManage.htm)
* [支付宝支付](https://docs.open.alipay.com/204/105051/)
* [支付宝登录](https://docs.open.alipay.com/218/105329/)
* [应用签名工具](https://opendocs.alipay.com/open/common/104062)

## android

```groovy
buildscript {
    dependencies {
        // Android 11兼容，需升级Gradle到3.5.4/3.6.4/4.x.y
        classpath 'com.android.tools.build:gradle:3.5.4'
    }
}
```

```
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

## ios

```
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
alipay: identifier=alipay schemes=${your app scheme name} # schemes 不能为纯数字，推荐：alipay${appId}
```

```
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>alipay</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## flutter

* break change
    * 2.2.0: Alipay 单例
    * 2.1.0: nullsafety & 不再支持 Android embedding v1

* snapshot

```
dependencies:
  alipay_kit:
    git:
      url: https://github.com/rxreader/alipay_kit.git
```

* release

```
dependencies:
  alipay_kit: ^${latestTag}
```

```
dependencies:
  # 请不要进行配置 iOS 相关配置，否则 Apple Store 审核时会拒绝
  alipay_kit: ^${latestTag}-Android-Only
```

* example

[示例](./example/lib/main.dart)


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
