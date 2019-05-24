# fake_alipay

[![Build Status](https://cloud.drone.io/api/badges/v7lin/fake_alipay/status.svg)](https://cloud.drone.io/v7lin/fake_alipay)
[![Codecov](https://codecov.io/gh/v7lin/fake_alipay/branch/master/graph/badge.svg)](https://codecov.io/gh/v7lin/fake_alipay)
[![GitHub Tag](https://img.shields.io/github/tag/v7lin/fake_alipay.svg)](https://github.com/v7lin/fake_alipay/releases)
[![Pub Package](https://img.shields.io/pub/v/fake_alipay.svg)](https://pub.dartlang.org/packages/fake_alipay)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/v7lin/fake_alipay/blob/master/LICENSE)

flutter版支付宝SDK

## fake 系列 libraries

* [flutter版微信SDK](https://github.com/v7lin/fake_wechat)
* [flutter版腾讯(QQ)SDK](https://github.com/v7lin/fake_tencent)
* [flutter版新浪微博SDK](https://github.com/v7lin/fake_weibo)
* [flutter版支付宝SDK](https://github.com/v7lin/fake_alipay)
* [flutter版腾讯(信鸽)推送SDK](https://github.com/v7lin/fake_push)

## dart/flutter 私服

* [simple_pub_server](https://github.com/v7lin/simple_pub_server)

## docs

* [蚂蚁金服开放平台](https://openhome.alipay.com/platform/appManage.htm)
* [支付宝支付](https://docs.open.alipay.com/204/105051/)
* [支付宝登录](https://docs.open.alipay.com/218/105329/)

## android

````
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
````

## ios

````
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
alipay: identifier=alipay schemes=${your app scheme name} # schemes 不能为纯数字，推荐：alipay${appId}
````

````
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
````

## flutter

* snapshot

````
dependencies:
  fake_alipay:
    git:
      url: https://github.com/v7lin/fake_alipay.git
````

* release

````
dependencies:
  fake_alipay: ^${latestTag}
````

* example

[示例](./example/lib/main.dart)

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
